#!/bin/bash

# Quick debugging commands

# tcpdump helpers
tcpdump_app_connections() {
    echo "Capturing HTTP traffic between nginx and app..."
    docker-compose exec nginx tcpdump -i eth0 -A 'tcp port 3000'
}

tcpdump_db_connections() {
    echo "Capturing PostgreSQL connections..."
    docker-compose exec postgres tcpdump -i eth0 -A 'tcp port 5432'
}

tcpdump_all_traffic() {
    echo "Capturing all traffic..."
    docker-compose exec app tcpdump -i eth0 -c 100
}

# strace helpers
strace_app_startup() {
    echo "Tracing app startup..."
    docker-compose exec app strace -f -e trace=execve,open,read -o /tmp/strace.log ./app
}

strace_current_app() {
    echo "Tracing currently running app..."
    app_pid=$(docker-compose exec -T app pgrep -f "^/app/app$" | head -1)
    if [ ! -z "$app_pid" ]; then
        docker-compose exec app strace -p $app_pid -f
    fi
}

# curl helpers
test_health() {
    echo "Testing /health endpoint..."
    curl -v http://localhost/health
}

test_status() {
    echo "Testing /api/status endpoint..."
    curl -v http://localhost/api/status
}

test_rate_limit() {
    echo "Rapid requests to test rate limiting..."
    for i in {1..30}; do
        curl -s -w "Request $i: %{http_code}\n" http://localhost/api/status
    done
}

# Log viewers
show_middleware_logs() {
    docker-compose logs -f rate-limiter
}

show_app_logs() {
    docker-compose logs -f app
}

show_db_logs() {
    docker-compose logs -f postgres
}

show_nginx_logs() {
    docker-compose logs -f nginx
}

# Database helpers
query_requests() {
    docker-compose exec -T postgres psql -U demo -d demo << SQL
SELECT timestamp, method, path, status_code, response_time_ms, rate_limited
FROM request_logs
ORDER BY timestamp DESC
LIMIT 20;
SQL
}

query_request_stats() {
    docker-compose exec -T postgres psql -U demo -d demo << SQL
SELECT
  status_code,
  COUNT(*) as count,
  AVG(response_time_ms)::numeric(10,2) as avg_response_ms,
  MAX(response_time_ms) as max_response_ms
FROM request_logs
GROUP BY status_code
ORDER BY count DESC;
SQL
}

# Container inspection
inspect_app() {
    docker inspect sirius_app
}

inspect_rate_limiter() {
    docker inspect sirius_rate-limiter
}

# System information
show_docker_stats() {
    docker stats --no-stream sirius_*
}

show_container_ps() {
    container=$1
    [ -z "$container" ] && container="app"
    docker-compose exec "$container" ps aux
}

# Help
debug_help() {
    echo "Available debugging functions:"
    echo ""
    echo "Network Debugging:"
    echo "  tcpdump_app_connections      - Capture HTTP traffic between nginx and app"
    echo "  tcpdump_db_connections       - Capture PostgreSQL connections"
    echo "  tcpdump_all_traffic          - Capture all network traffic"
    echo ""
    echo "System Call Tracing:"
    echo "  strace_app_startup           - Trace app startup"
    echo "  strace_current_app           - Trace running app process"
    echo ""
    echo "API Testing:"
    echo "  test_health                  - Test health endpoint"
    echo "  test_status                  - Test API status endpoint"
    echo "  test_rate_limit              - Test rate limiting with 30 requests"
    echo ""
    echo "Log Viewing:"
    echo "  show_middleware_logs         - View middleware logs"
    echo "  show_app_logs                - View app logs"
    echo "  show_db_logs                 - View database logs"
    echo "  show_nginx_logs              - View nginx logs"
    echo ""
    echo "Database Queries:"
    echo "  query_requests               - Show recent requests from logs"
    echo "  query_request_stats          - Show request statistics by status code"
    echo ""
    echo "Container Information:"
    echo "  inspect_app                  - Show app container details"
    echo "  inspect_rate_limiter         - Show rate-limiter container details"
    echo "  show_docker_stats            - Show real-time container stats"
    echo "  show_container_ps            - Show processes in a container"
    echo ""
    echo "Usage: source debug-helpers.sh && debug_help"
    echo ""
}

