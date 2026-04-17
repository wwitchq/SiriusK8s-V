# SRE Practical Workshop - Complete Stack Guide

A comprehensive practical workshop demonstrating production-grade SRE concepts including Kubernetes troubleshooting, Docker containerization, rate limiting, network debugging, system tracing, and security scanning.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        NGINX (Port 80/443)                  │
│                    Rate Limiting & Reverse Proxy             │
└─────────────────────────┬──────────────────────────────────┘
                          │
┌─────────────────────────▼──────────────────────────────────┐
│              Node.js Middleware (Port 3000)                 │
│            Rate Limiting + Dual Logging Service             │
│         (File logs + PostgreSQL Database logging)           │
└─────────────────────────┬──────────────────────────────────┘
                          │
┌─────────────────────────▼──────────────────────────────────┐
│              Go Application Server (Port 8080)              │
│                  Health & Status Endpoints                  │
│              Database Connection with Retry Logic           │
└─────────────────────────┬──────────────────────────────────┘
                          │
┌─────────────────────────▼──────────────────────────────────┐
│              PostgreSQL Database (Port 5432)                │
│              Persistent Volume (postgres_data)              │
│          Request Logs & Application State Storage           │
└─────────────────────────────────────────────────────────────┘
```

## Prerequisites

- **Docker**: v20.10+ ([Install Docker](https://docs.docker.com/install/))
- **Docker Compose**: v1.29+ ([Install Docker Compose](https://docs.docker.com/compose/install/))
- **curl**: For testing HTTP endpoints
- **tcpdump**: For network analysis (usually pre-installed on Linux)
- **strace**: For system call tracing
- **jq**: For JSON parsing (optional but recommended)

### Verify Installation

```bash
docker --version
docker-compose --version
curl --version
tcpdump --version
strace --version
```

## Project Structure

```
.
├── docker-compose.yml          # Multi-service orchestration
├── Dockerfile.app              # Go application container
├── Dockerfile.middleware       # Node.js middleware container
├── init-db.sql                 # PostgreSQL initialization script
├── break-db.sh                 # Database corruption script (intentional)
├── main.go                     # Go HTTP server
├── go.mod                      # Go dependencies
├── go.sum                       # Go dependency lock file
├── middleware.js               # Node.js rate limiter & logger
├── package.json                # Node.js dependencies
├── nginx.conf                  # Nginx reverse proxy configuration
├── check-docker-security.sh    # Security scanner for containers
├── test-api.sh                 # Script to test API endpoints
├── test-rate-limiting.sh       # Script to test rate limiting
├── setup-debugging.sh          # Setup debugging environment
└── README.md                   # This file
```

## Quick Start

### 1. Build and Start All Services

```bash
# Build images and start containers
docker-compose up --build

# Expected output shows all 4 services starting:
# - postgres
# - app
# - rate-limiter
# - nginx
```

### 2. Verify Services Are Running

```bash
# Check status of all containers
docker-compose ps

# Expected output:
# NAME         COMMAND              STATUS
# postgres     postgres             Up (healthy)
# app          ./app                Up (healthy)
# rate-limiter node middleware.js   Up (healthy)
# nginx        nginx -g daemon      Up (healthy)
```

### 3. Test the Stack

```bash
# Health check endpoints
curl -v http://localhost/health

# Expected response:
# HTTP/1.1 200 OK
# {
#   "status": "healthy",
#   "service": "health-check"
# }

# API status endpoint
curl -v http://localhost/api/status

# Expected response:
# HTTP/1.1 200 OK
# {
#   "status": "ok",
#   "users_count": 3,
#   "message": "Database connection successful"
# }
```

## Workshop Lessons

### Lesson 1: Nginx Configuration & Reverse Proxying
**Topics**: Upstream configuration, worker processes, logging formats, rate limiting zones

**Key Files**: `nginx.conf`

**Activities**:
1. Review nginx configuration structure
2. Understand upstream definitions
3. Study rate limiting zones and burst parameters
4. Examine access log format with request details

**Commands**:
```bash
# View Nginx logs
docker-compose logs -f nginx

# Reload Nginx configuration (without restart)
docker-compose exec nginx nginx -s reload

# Check Nginx configuration syntax
docker-compose exec nginx nginx -t

# View current connections
docker-compose exec nginx ss -tlnp
```

### Lesson 2: Docker Containerization & Multi-Stage Builds
**Topics**: Dockerfile optimization, multi-stage builds, Alpine Linux, security

**Key Files**: `Dockerfile.app`, `Dockerfile.middleware`

**Activities**:
1. Examine multi-stage Go build (builder + runtime stages)
2. Analyze layer efficiency (ca-certificates, postgresql-client inclusion)
3. Review Node.js minimal Dockerfile
4. Understand image size optimization

**Commands**:
```bash
# Inspect image details
docker image inspect sirius_app:latest

# Check image layers
docker history sirius_app:latest

# View image size
docker images sirius_*

# Examine container filesystem
docker-compose exec app ls -lah /app
```

### Lesson 3: Rate Limiting & Middleware Architecture
**Topics**: Token bucket algorithm, middleware design, request forwarding

**Key Files**: `middleware.js`, `nginx.conf`

**Activities**:
1. Study token bucket implementation (10 req/s, burst 20)
2. Understand per-IP rate limiting
3. Trace request flow through middleware
4. Review HTTP status codes (429 Too Many Requests)

**Commands**:
```bash
# Test rate limiting
bash test-rate-limiting.sh

# Check rate limiter logs
docker-compose logs -f rate-limiter

# View request logs in real-time
docker-compose exec rate-limiter tail -f /app/logs/requests-*.log

# Query database for logged requests
docker-compose exec postgres psql -U demo -d demo \
  -c "SELECT * FROM request_logs ORDER BY timestamp DESC LIMIT 10;"
```

### Lesson 4: Logging & Observability
**Topics**: Dual logging (files + database), structured logging, query performance

**Key Files**: `middleware.js`, `init-db.sql`

**Activities**:
1. Understand dual-logging architecture (file + database)
2. Examine JSON log structure
3. Query request_logs table
4. Analyze request patterns and performance

**Commands**:
```bash
# View file-based logs
docker-compose exec rate-limiter cat /app/logs/requests-*.log | jq .

# Query database logs with filtering
docker-compose exec postgres psql -U demo -d demo << EOF
SELECT timestamp, method, path, status_code, response_time_ms, rate_limited
FROM request_logs
WHERE status_code = 429
ORDER BY timestamp DESC;
EOF

# Get statistics
docker-compose exec postgres psql -U demo -d demo << EOF
SELECT
  status_code,
  COUNT(*) as count,
  AVG(response_time_ms) as avg_response_ms,
  MAX(response_time_ms) as max_response_ms
FROM request_logs
GROUP BY status_code
ORDER BY count DESC;
EOF
```

### Lesson 5: Network Debugging & Security
**Topics**: tcpdump packet analysis, curl advanced features, Docker security scanning

**Key Files**: `check-docker-security.sh`

**Activities**:
1. Capture and analyze network traffic with tcpdump
2. Use curl for HTTP testing and debugging
3. Run security scanner on containers
4. Understand packet flows between services

**Commands**:
```bash
# Network debugging
bash test-api.sh
bash test-rate-limiting.sh
bash setup-debugging.sh
```

## Network Debugging (tcpdump)

### Capture HTTP Traffic Between Nginx and Middleware

```bash
# Start packet capture on rate-limiter service network
docker-compose exec nginx tcpdump -i eth0 -A 'tcp port 3000'

# In another terminal, make requests
curl -v http://localhost/api/status

# tcpdump output shows:
# - TCP handshake (SYN, ACK)
# - HTTP request with headers
# - HTTP response with status code
# - TCP FIN (connection close)
```

### Analyze Specific Protocols

```bash
# DNS queries
docker-compose exec nginx tcpdump -i eth0 -A 'udp port 53'

# PostgreSQL connections
docker-compose exec postgres tcpdump -i eth0 -A 'tcp port 5432'

# All traffic to middleware
docker-compose exec nginx tcpdump -i eth0 'dst port 3000'
```

## HTTP Testing with curl

### Basic Health Check

```bash
# Simple request
curl http://localhost/health

# Verbose mode (shows headers)
curl -v http://localhost/health

# Include response headers
curl -i http://localhost/health

# Custom headers
curl -H "User-Agent: SRE-Workshop" \
     -H "X-Request-ID: test-123" \
     http://localhost/api/status
```

### Test Rate Limiting

```bash
# Single request
curl http://localhost/api/status

# Rapid requests (will trigger rate limiting)
for i in {1..30}; do curl http://localhost/api/status; done

# Measure response times
curl -w "Time: %{time_total}s\n" http://localhost/api/status

# Save response to file
curl -o response.json http://localhost/api/status
```

### Advanced curl Features

```bash
# Follow redirects
curl -L http://localhost/api/status

# Include cookies
curl -b "session=abc123" http://localhost/api/status

# Send POST data
curl -X POST -d '{"key":"value"}' \
     -H "Content-Type: application/json" \
     http://localhost/api/status

# Retry on failure
curl --retry 3 --retry-delay 1 http://localhost/api/status

# Timeout
curl --max-time 5 http://localhost/api/status

# Custom response format
curl -w "\nStatus: %{http_code}\nTime: %{time_total}s\n" \
     http://localhost/api/status
```

## Intentional Failure Scenarios

### Scenario 1: Database Corruption

Demonstrates troubleshooting when database becomes unavailable.

```bash
# In one terminal, watch logs
docker-compose logs -f app

# In another terminal, run the break script
docker-compose exec postgres bash < break-db.sh

# Expected behavior:
# - Application attempts database query
# - Query fails (table doesn't exist)
# - API returns 500 error
# - Requests get logged in middleware despite app failure

# Fix the database
docker-compose restart postgres
```

### Scenario 2: Rate Limiting Exceeded

Demonstrates rate limiting behavior and recovery.

```bash
# Generate rapid requests
for i in {1..50}; do
  curl -s http://localhost/api/status -w "Request $i: %{http_code}\n"
  sleep 0.05
done

# You'll see:
# - First 10 requests: 200 OK
# - Next 10 requests: 429 Too Many Requests
# - Pause 1+ second
# - More requests: 200 OK (tokens refilled)
```

### Scenario 3: Service Dependency Failure

```bash
# Stop the application
docker-compose stop app

# Try to make requests
curl http://localhost/api/status

# Expected: 502 Bad Gateway (middleware can't reach app)
curl http://localhost/health  # Still works (health endpoint in rate-limiter)

# Restart
docker-compose start app
```

## Docker Security Scanning

### Run Security Check on All Containers

```bash
# Make the script executable
chmod +x check-docker-security.sh

# Check single container
./check-docker-security.sh app

# Check all running containers
docker ps -q | xargs -I{} ./check-docker-security.sh {}

# Or check specific containers
./check-docker-security.sh app postgres rate-limiter nginx
```

### Expected Output

```
[CRITICAL] Container running as root (User: 'root')
[WARNING] No capabilities explicitly dropped
[CRITICAL] Container using host network mode
[INFO] Mounted volumes...
```

### Security Best Practices Implemented

The stack demonstrates:

```bash
# Check what the script recommends
./check-docker-security.sh app | grep "Recommendation"
```

**Improvements to make**:
1. Run apps as non-root user (add `USER` directive in Dockerfile)
2. Drop all capabilities: `--cap-drop=ALL`
3. Add required capabilities only: `--cap-add=NET_BIND_SERVICE`
4. Use read-only filesystem: `--read-only`
5. Avoid host network/pid/ipc modes
6. Use security profiles (AppArmor/SELinux)

## System Call Tracing (strace)

### Understanding Application Behavior

```bash
# Trace the Go application
docker-compose exec app strace -p $(docker-compose exec -T app pgrep app)

# Wait for a request and observe system calls:
# - socket() - Create network socket
# - connect() - Connect to database
# - read()/write() - Communication
# - open() - File access
# - futex() - Synchronization

# Trace with summary
strace -c ./app

# Trace specific syscalls
strace -e trace=network ./app
strace -e trace=file ./app
strace -e trace=process ./app
```

### Application Startup Tracing

```bash
# Run app with strace and capture startup
docker-compose exec app strace -f -e trace=execve,open,read \
  ./app 2>&1 | head -50

# Look for:
# - Binary loading
# - Library dependencies
# - Configuration file reading
# - Socket binding
```

## Database Management

### Connect to PostgreSQL

```bash
# Interactive psql session
docker-compose exec postgres psql -U demo -d demo

# Common commands in psql:
# \dt          - List tables
# \d users     - Describe users table
# SELECT * FROM users;
# SELECT * FROM request_logs LIMIT 10;
# \q           - Exit
```

### Backup and Restore

```bash
# Backup database
docker-compose exec postgres pg_dump -U demo demo > backup.sql

# Restore from backup
cat backup.sql | docker-compose exec -T postgres psql -U demo demo
```

### Monitor Active Connections

```bash
# Show active connections
docker-compose exec postgres psql -U demo -d demo \
  -c "SELECT * FROM pg_stat_activity;"

# Show query performance
docker-compose exec postgres psql -U demo -d demo \
  -c "SELECT query, calls, mean_time FROM pg_stat_statements \
      ORDER BY mean_time DESC LIMIT 10;"
```

## Performance Testing

### Load Testing with ApacheBench

```bash
# Install ApacheBench if not present
apt-get install apache2-utils

# Run load test (100 requests, 10 concurrent)
ab -n 100 -c 10 http://localhost/api/status

# Expected metrics:
# - Requests per second
# - Mean time per request
# - Failed requests (should be 0)
```

### Load Testing with wrk

```bash
# Clone and build wrk
git clone https://github.com/wg/wrk.git
cd wrk && make

# Run benchmark
./wrk -t4 -c100 -d30s http://localhost/api/status

# Expected output:
# - Running 30 seconds
# - 4 threads, 100 concurrent connections
# - Requests/sec, Avg latency, Max latency
```

## Troubleshooting

### All Services Not Starting

```bash
# Check Docker daemon
docker ps

# Check compose file validity
docker-compose config

# View service logs
docker-compose logs
docker-compose logs app
docker-compose logs postgres
```

### Port Already in Use

```bash
# Find process using port
lsof -i :80
lsof -i :5432

# Kill process
kill -9 <PID>

# Or modify docker-compose.yml ports
```

### Database Connection Failures

```bash
# Check PostgreSQL status
docker-compose logs postgres

# Verify connection string in app
docker-compose logs app | grep -i postgres

# Test connection manually
docker-compose exec postgres psql -U demo -d demo -c "SELECT 1;"
```

### Rate Limiting Not Working

```bash
# Check middleware logs
docker-compose logs rate-limiter

# Verify token bucket implementation
docker-compose exec rate-limiter cat middleware.js | grep -A 5 "token"

# Check rate-limiter connectivity
docker-compose exec app curl http://rate-limiter:3000/health
```

## File Locations in Containers

### Go Application
- **Binary**: `/app/app`
- **Working Directory**: `/app`
- **Logs**: (sent to stdout, captured by Docker)

### Node.js Middleware
- **Code**: `/app/middleware.js`
- **Logs**: `/app/logs/requests-YYYY-MM-DD.log`
- **Node Modules**: `/app/node_modules`

### PostgreSQL
- **Data Directory**: `/var/lib/postgresql/data`
- **Config**: `/etc/postgresql`
- **Database**: `demo`
- **User**: `demo` (password: `demo`)

### Nginx
- **Config**: `/etc/nginx/nginx.conf`
- **Logs**: `/var/log/nginx/`
- **Pid**: `/var/run/nginx.pid`

## Environment Variables

```bash
# Database connection (app)
DB_HOST=postgres
DB_PORT=5432
DB_NAME=demo
DB_USER=demo
DB_PASSWORD=demo

# Rate limiter
UPSTREAM_HOST=app
UPSTREAM_PORT=8080
RATE_LIMIT=10
BURST=20

# PostgreSQL
POSTGRES_DB=demo
POSTGRES_USER=demo
POSTGRES_PASSWORD=demo
```

## Cleanup

### Stop All Services

```bash
# Stop services but keep volumes
docker-compose stop

# Restart services
docker-compose start
```

### Complete Cleanup

```bash
# Stop and remove containers, networks
docker-compose down

# Also remove volumes
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

## Advanced Workshops

### Workshop A: Build Kubernetes from Scratch
- Manually install etcd, API Server, Controller Manager, Scheduler
- Create and deploy pods manually
- Understand cluster networking
- See `SRE_Interview_Preparation.docx` for detailed curriculum

### Workshop B: Advanced Troubleshooting
1. **Network Layer**: tcpdump, netstat, ss commands
2. **Application Layer**: curl, logs, database queries
3. **System Layer**: strace, ltrace, perf
4. **Container Layer**: docker inspect, docker stats, docker logs

### Workshop C: Production Hardening
1. Run security scanner on all containers
2. Implement least-privilege user accounts
3. Drop unnecessary capabilities
4. Enable read-only filesystems
5. Use network policies
6. Implement resource limits

## Additional Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Go Documentation](https://golang.org/doc/)
- [Node.js Documentation](https://nodejs.org/en/docs/)

### Linux Tools
- `man tcpdump` - Packet capture manual
- `man strace` - System call tracing manual
- `man curl` - URL retrieval tool manual
- `man ps` - Process information
- `man ss` - Socket statistics
- `man journalctl` - Journal log retrieval

### Security References
- [OWASP Container Security](https://owasp.org/www-community/attacks/Docker_Escape)
- [CIS Docker Benchmark](https://www.cisecurity.org/cis-benchmarks/)
- [Container Security Best Practices](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

## Next Steps

1. **Complete Lesson 1-5**: Follow each lesson using the commands above
2. **Run Intentional Failures**: Trigger database corruption and network issues
3. **Security Hardening**: Use the security scanner to identify and fix issues
4. **Performance Analysis**: Use load testing and metrics to understand system behavior
5. **Document Findings**: Create your own troubleshooting playbook

---

**Created for**: SRE Interview Preparation Workshop
**Difficulty**: Intermediate to Advanced
**Time Estimate**: 7.5 hours (5 × 1.5 hour lessons)
