#!/bin/bash

# Setup Debugging Environment
# Prepares Docker containers with debugging tools (tcpdump, strace, etc.)

set -e

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if docker-compose is running
print_header "Checking Docker Services"

if ! docker-compose ps > /dev/null 2>&1; then
    print_error "Docker Compose services not running. Start with: docker-compose up -d"
    exit 1
fi

print_info "Docker services are running"
docker-compose ps

# Install debugging tools
print_header "Installing Debugging Tools"

# Array of containers to update
containers=("app" "rate-limiter" "postgres" "nginx")

for container in "${containers[@]}"; do
    if docker-compose ps "$container" | grep -q "Up"; then
        print_info "Setting up debugging in $container..."

        # Detect base image and install appropriate tools
        case $container in
            "app")
                # Go app in Alpine
                docker-compose exec -T "$container" sh -c "apk update && apk add tcpdump strace curl less vim" 2>/dev/null || \
                print_warning "Could not install tools in $container (may lack permissions)"
                ;;
            "rate-limiter")
                # Node.js in Alpine
                docker-compose exec -T "$container" sh -c "apk update && apk add tcpdump strace curl less vim" 2>/dev/null || \
                print_warning "Could not install tools in $container"
                ;;
            "postgres")
                # PostgreSQL in Alpine/Debian
                docker-compose exec -T "$container" sh -c "apt-get update && apt-get install -y tcpdump strace curl less vim" 2>/dev/null || \
                docker-compose exec -T "$container" sh -c "apk update && apk add tcpdump strace curl less vim" 2>/dev/null || \
                print_warning "Could not install tools in $container"
                ;;
            "nginx")
                # Nginx in Alpine
                docker-compose exec -T "$container" sh -c "apk update && apk add tcpdump strace curl less vim" 2>/dev/null || \
                print_warning "Could not install tools in $container"
                ;;
        esac
    else
        print_warning "$container is not running"
    fi
done

# Create logging directory
print_header "Preparing Logging Directory"

log_dir="/app/logs"
docker-compose exec -T rate-limiter sh -c "mkdir -p $log_dir && chmod 777 $log_dir" 2>/dev/null || \
print_warning "Could not create logging directory"

print_info "Logging directory prepared"

# Display network information
print_header "Network Configuration"

print_info "Container Networks:"
docker-compose exec -T app ip addr show 2>/dev/null || print_warning "Could not retrieve network info"

print_info "DNS Resolution:"
for container in app rate-limiter postgres nginx; do
    if docker-compose ps "$container" | grep -q "Up"; then
        echo "  $container:"
        docker-compose exec -T "$container" nslookup postgres 2>/dev/null | head -5 || echo "    (nslookup not available)"
    fi
done

# Display port information
print_header "Port Configuration"

print_info "Service Ports:"
echo "  Nginx:          80, 443"
echo "  Rate Limiter:   3000"
echo "  App:            8080"
echo "  PostgreSQL:     5432"

echo ""
print_info "Port Bindings on Host:"
netstat -tlnp 2>/dev/null | grep -E ":(80|443|3000|8080|5432)" || \
echo "  (netstat not available or no ports exposed)"

# Create useful debugging aliases
print_header "Debugging Commands Setup"

print_info "Creating debugging helper functions..."

cat > ./debug-helpers.sh << 'EOF'
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

EOF

chmod +x ./debug-helpers.sh
print_info "Created debug-helpers.sh"
print_info "Usage: source ./debug-helpers.sh && debug_help"

# Create tcpdump example script
print_header "Creating tcpdump Example Scripts"

cat > ./examples-tcpdump.sh << 'EOF'
#!/bin/bash

# tcpdump Examples for Network Debugging

echo "tcpdump Examples"
echo "================"
echo ""

# Example 1: Capture HTTP traffic
echo "1. Capture HTTP traffic between nginx and rate-limiter:"
echo "   docker-compose exec nginx tcpdump -i eth0 -A 'tcp port 3000' | head -50"
echo ""

# Example 2: Capture PostgreSQL traffic
echo "2. Capture PostgreSQL connection attempts:"
echo "   docker-compose exec app tcpdump -i eth0 -A 'tcp port 5432'"
echo ""

# Example 3: Capture DNS queries
echo "3. Capture DNS queries:"
echo "   docker-compose exec nginx tcpdump -i eth0 -A 'udp port 53'"
echo ""

# Example 4: Capture specific packet count
echo "4. Capture 100 packets total:"
echo "   docker-compose exec app tcpdump -i eth0 -c 100"
echo ""

# Example 5: Analyze packet headers
echo "5. Show detailed packet information:"
echo "   docker-compose exec nginx tcpdump -i eth0 -v -v tcp port 3000"
echo ""

# Example 6: Save to file
echo "6. Save packets to file for analysis:"
echo "   docker-compose exec nginx tcpdump -i eth0 -w /tmp/capture.pcap"
echo ""

# Example 7: Filter by source IP
echo "7. Capture traffic from specific IP:"
echo "   docker-compose exec nginx tcpdump -i eth0 'src 172.20.0.3'"
echo ""

# Example 8: Show only SYN packets
echo "8. Show only TCP connection initiations:"
echo "   docker-compose exec nginx tcpdump -i eth0 'tcp[tcpflags] & tcp-syn != 0'"
echo ""

EOF

chmod +x ./examples-tcpdump.sh
print_info "Created examples-tcpdump.sh"

# Create curl example script
print_header "Creating curl Example Scripts"

cat > ./examples-curl.sh << 'EOF'
#!/bin/bash

# curl Examples for HTTP Testing

echo "curl Examples"
echo "=============="
echo ""

# Example 1: Verbose output
echo "1. Show request and response headers:"
echo "   curl -v http://localhost/health"
echo ""

# Example 2: Show response headers only
echo "2. Show response headers only:"
echo "   curl -i http://localhost/health"
echo ""

# Example 3: Measure response time
echo "3. Measure response time:"
echo "   curl -w 'Response time: %{time_total}s\n' -o /dev/null -s http://localhost/health"
echo ""

# Example 4: Custom headers
echo "4. Send custom headers:"
echo "   curl -H 'X-Request-ID: test-123' -H 'User-Agent: SRE-Workshop' http://localhost/health"
echo ""

# Example 5: Follow redirects
echo "5. Follow redirects automatically:"
echo "   curl -L http://localhost/health"
echo ""

# Example 6: Save response to file
echo "6. Save response to file:"
echo "   curl -o response.json http://localhost/api/status"
echo ""

# Example 7: Test rate limiting
echo "7. Rapid requests (will trigger rate limiting):"
echo "   for i in {1..30}; do curl -s -w 'Request \$i: %{http_code}\n' http://localhost/api/status; done"
echo ""

# Example 8: Custom timeout
echo "8. Set timeout for slow connections:"
echo "   curl --max-time 5 http://localhost/health"
echo ""

# Example 9: Authentication
echo "9. Send authentication header:"
echo "   curl -H 'Authorization: Bearer token-123' http://localhost/api/status"
echo ""

# Example 10: POST request
echo "10. Send POST data:"
echo "    curl -X POST -d '{\"key\":\"value\"}' -H 'Content-Type: application/json' http://localhost/health"
echo ""

# Example 11: Retry on failure
echo "11. Retry failed requests:"
echo "    curl --retry 3 --retry-delay 1 http://localhost/health"
echo ""

# Example 12: Show full HTTP exchange
echo "12. Show complete HTTP exchange:"
echo "    curl -v --trace-ascii /tmp/trace.txt http://localhost/health"
echo ""

EOF

chmod +x ./examples-curl.sh
print_info "Created examples-curl.sh"

# Create strace example script
print_header "Creating strace Example Scripts"

cat > ./examples-strace.sh << 'EOF'
#!/bin/bash

# strace Examples for System Call Tracing

echo "strace Examples"
echo "==============="
echo ""

# Example 1: Trace all syscalls
echo "1. Trace all system calls:"
echo "   docker-compose exec app strace -o /tmp/strace.log ./app"
echo "   less /tmp/strace.log"
echo ""

# Example 2: Trace specific syscalls
echo "2. Trace network-related syscalls only:"
echo "   docker-compose exec app strace -e trace=network ./app"
echo ""

# Example 3: Trace file operations
echo "3. Trace file operations:"
echo "   docker-compose exec app strace -e trace=file ./app"
echo ""

# Example 4: Trace process management
echo "4. Trace process-related syscalls:"
echo "   docker-compose exec app strace -e trace=process ./app"
echo ""

# Example 5: Show syscall summary
echo "5. Show summary of syscalls:"
echo "   docker-compose exec app strace -c ./app"
echo ""

# Example 6: Attach to running process
echo "6. Attach to running app process:"
echo "   app_pid=\$(docker-compose exec -T app pgrep -f '^./app\$')"
echo "   docker-compose exec app strace -p \$app_pid"
echo ""

# Example 7: Trace child processes
echo "7. Trace parent and child processes:"
echo "   docker-compose exec app strace -f ./app"
echo ""

# Example 8: Show syscall timing
echo "8. Show timing information:"
echo "   docker-compose exec app strace -t ./app"
echo ""

# Example 9: Filter syscalls
echo "9. Trace only syscalls that failed:"
echo "   docker-compose exec app strace -e trace=file,open,read -f -e status=unfinished ./app"
echo ""

# Example 10: Save to file
echo "10. Save detailed trace to file:"
echo "    docker-compose exec app strace -ff -o /tmp/trace ./app"
echo "    # Output: /tmp/trace.PID for each process"
echo ""

EOF

chmod +x ./examples-strace.sh
print_info "Created examples-strace.sh"

# Final summary
print_header "Setup Complete"

print_info "Debugging environment is ready!"
print_info ""
print_info "Available commands:"
echo "  1. source ./debug-helpers.sh && debug_help"
echo "  2. bash ./examples-tcpdump.sh"
echo "  3. bash ./examples-curl.sh"
echo "  4. bash ./examples-strace.sh"
echo ""

print_info "Quick start debugging:"
echo "  # View middleware logs"
echo "  docker-compose logs -f rate-limiter"
echo ""
echo "  # Test API in another terminal"
echo "  curl -v http://localhost/health"
echo ""
echo "  # Monitor network traffic"
echo "  docker-compose exec nginx tcpdump -i eth0 -A 'tcp port 3000'"
echo ""
echo "  # View database logs"
echo "  docker-compose logs -f postgres"
echo ""

print_info "For more details, see README.md"

