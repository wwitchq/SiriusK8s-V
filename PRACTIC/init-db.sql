-- Initialize database with users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES
  ('Alice Johnson', 'alice@example.com'),
  ('Bob Smith', 'bob@example.com'),
  ('Charlie Brown', 'charlie@example.com');

-- Create request logs table
CREATE TABLE IF NOT EXISTS request_logs (
  id SERIAL PRIMARY KEY,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  method VARCHAR(10),
  path VARCHAR(255),
  status_code INT,
  response_time_ms INT,
  client_ip VARCHAR(45),
  user_agent TEXT,
  rate_limited BOOLEAN DEFAULT FALSE
);

-- Create index for performance
CREATE INDEX idx_request_logs_timestamp ON request_logs(timestamp DESC);
