const http = require('http');
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const PORT = process.env.LISTEN_PORT || 3000;
const UPSTREAM_URL = process.env.UPSTREAM_URL || 'http://app:8080';
const LOG_DIR = '/app/logs';

// Ensure logs directory exists
if (!fs.existsSync(LOG_DIR)) {
  fs.mkdirSync(LOG_DIR, { recursive: true });
}

// PostgreSQL connection
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'demo'
});

// Rate limiting - token bucket algorithm
const requestCounters = {};
const MAX_REQUESTS_PER_SECOND = 10;
const BURST_SIZE = 20;

function getRateLimitKey(req) {
  return req.socket.remoteAddress || '127.0.0.1';
}

function isRateLimited(key) {
  const now = Date.now();
  if (!requestCounters[key]) {
    requestCounters[key] = { tokens: BURST_SIZE, lastRefill: now };
    return false;
  }

  const counter = requestCounters[key];
  const timePassed = (now - counter.lastRefill) / 1000;
  counter.tokens = Math.min(BURST_SIZE, counter.tokens + timePassed * MAX_REQUESTS_PER_SECOND);
  counter.lastRefill = now;

  if (counter.tokens >= 1) {
    counter.tokens -= 1;
    return false;
  }

  return true;
}

function logRequest(req, statusCode, responseTime, rateLimited) {
  const timestamp = new Date().toISOString();
  const logEntry = {
    timestamp,
    method: req.method,
    path: req.url,
    status_code: statusCode,
    response_time_ms: responseTime,
    client_ip: req.socket.remoteAddress || 'unknown',
    user_agent: req.headers['user-agent'] || 'unknown',
    rate_limited: rateLimited
  };

  // Write to file
  const logLine = JSON.stringify(logEntry);
  fs.appendFile(path.join(LOG_DIR, `requests-${new Date().toISOString().split('T')[0]}.log`), 
    logLine + '\n', (err) => {
      if (err) console.error('File log error:', err);
    });

  // Write to database
  pool.query(
    'INSERT INTO request_logs (timestamp, method, path, status_code, response_time_ms, client_ip, user_agent, rate_limited) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)',
    [logEntry.timestamp, logEntry.method, logEntry.path, logEntry.status_code, 
     logEntry.response_time_ms, logEntry.client_ip, logEntry.user_agent, logEntry.rate_limited],
    (err) => {
      if (err) console.error('Database log error:', err);
    }
  );
}

const server = http.createServer((req, res) => {
  const startTime = Date.now();
  const clientKey = getRateLimitKey(req);
  const rateLimited = isRateLimited(clientKey);

  // Health check
  if (req.url === '/health' && req.method === 'GET') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'middleware healthy' }));
    logRequest(req, 200, Date.now() - startTime, false);
    return;
  }

  // Rate limiting response
  if (rateLimited) {
    res.writeHead(429, { 'Content-Type': 'application/json', 'Retry-After': '1' });
    res.end(JSON.stringify({ error: 'Too many requests' }));
    logRequest(req, 429, Date.now() - startTime, true);
    return;
  }

  // Proxy request to upstream
  const upstreamOptions = new URL(UPSTREAM_URL);
  upstreamOptions.pathname = req.url;
  upstreamOptions.method = req.method;
  upstreamOptions.headers = req.headers;
  delete upstreamOptions.headers.host;

  const proxyReq = http.request(upstreamOptions, (proxyRes) => {
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res);
    
    res.on('finish', () => {
      logRequest(req, proxyRes.statusCode, Date.now() - startTime, false);
    });
  });

  proxyReq.on('error', (err) => {
    console.error('Proxy error:', err);
    res.writeHead(502, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Bad gateway' }));
    logRequest(req, 502, Date.now() - startTime, false);
  });

  req.pipe(proxyReq);
});

server.listen(PORT, () => {
  console.log(`Rate limiter middleware listening on port ${PORT}`);
  console.log(`Proxying to: ${UPSTREAM_URL}`);
  console.log(`Logging to: ${LOG_DIR}`);
});

process.on('SIGTERM', () => {
  console.log('SIGTERM received, closing gracefully');
  server.close(() => {
    pool.end(() => {
      process.exit(0);
    });
  });
});
