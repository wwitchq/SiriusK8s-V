# SRE Practical Workshop - Quick Reference Guide

Fast lookup for common commands and troubleshooting during the workshop.

## 🚀 Quick Start (5 minutes)

```bash
# Start the entire stack
docker-compose up --build

# In another terminal, test it works
curl http://localhost/health
curl http://localhost/api/status

# You're done! Stack is running.
```

## 📊 Services & Ports

| Service | Port | Command |
|---------|------|---------|
| Nginx (LB/Proxy) | 80, 443 | `docker-compose logs -f nginx` |
| Rate Limiter | 3000 | `docker-compose logs -f rate-limiter` |
| Go App | 8080 | `docker-compose logs -f app` |
| PostgreSQL | 5432 | `docker-compose logs -f postgres` |

## 🧪 Testing Commands

### Health & Status
```bash
curl http://localhost/health           # Quick health check
curl http://localhost/api/status       # Get user count from DB
curl -v http://localhost/health        # Show headers
```

### Test Rate Limiting
```bash
bash test-rate-limiting.sh             # Auto-test with 50 requests
bash test-api.sh                       # Full API test suite

# Manual rate limit test
for i in {1..30}; do
  curl -s -w "Request $i: %{http_code}\n" http://localhost/api/status
done
```

### Database Checks
```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U demo -d demo

# Inside psql:
SELECT * FROM users;                   # View users
SELECT * FROM request_logs LIMIT 5;    # View request logs
SELECT COUNT(*) FROM request_logs;     # Total requests
```

## 🔍 Debugging Tools

### View Logs
```bash
docker-compose logs app                # View app logs
docker-compose logs -f rate-limiter    # Follow middleware logs (live)
docker-compose logs -f --tail 20 nginx # Last 20 nginx lines
docker-compose logs --timestamps app   # With timestamps
```

### Network Debugging (tcpdump)
```bash
# Monitor traffic between nginx and middleware
docker-compose exec nginx tcpdump -i eth0 -A 'tcp port 3000'

# Monitor database connections
docker-compose exec app tcpdump -i eth0 -A 'tcp port 5432'

# Save to file
docker-compose exec nginx tcpdump -i eth0 -w /tmp/capture.pcap
```

### System Call Tracing (strace)
```bash
# Trace all syscalls
docker-compose exec app strace -o /tmp/trace.log ./app

# Trace only network calls
docker-compose exec app strace -e trace=network ./app

# Get summary
docker-compose exec app strace -c ./app
```

### Container Inspection
```bash
# Check security configuration
./check-docker-security.sh app

# View running processes
docker-compose exec app ps aux

# View network configuration
docker-compose exec app ip addr show

# View open ports
docker-compose exec app ss -tlnp
```

## 🔧 Advanced Debugging

### Setup Debugging Environment
```bash
bash setup-debugging.sh                 # Install tools in containers
source ./debug-helpers.sh               # Load helper functions
debug_help                              # Show all available functions
```

### Example Commands (after setup)
```bash
# Use helper functions
test_health                             # Quick health test
query_requests                          # View request logs from DB
show_middleware_logs                    # Watch middleware logs
tcpdump_app_connections                 # Capture HTTP traffic
```

## 💥 Intentional Failure Scenarios

### Break the Database
```bash
# Corrupt database (drops users table)
docker-compose exec postgres bash < break-db.sh

# Watch the errors
docker-compose logs -f app

# Fix it
docker-compose restart postgres
```

### Stop a Service
```bash
# Stop application
docker-compose stop app
curl http://localhost/api/status        # Gets 502 Bad Gateway

# Stop database
docker-compose stop postgres
docker-compose logs app                 # Shows connection errors

# Restart
docker-compose start app
docker-compose start postgres
```

### Fill the Rate Limiter
```bash
# Rapid requests exceed rate limit
for i in {1..50}; do
  curl -s http://localhost/api/status -w "%{http_code}\n"
done

# You'll see: 200, 200, ..., 200, 429, 429, 429, ...
```

## 📈 Performance Testing

### Quick Load Test
```bash
# Install Apache Bench
apt-get install apache2-utils

# Run 100 requests, 10 concurrent
ab -n 100 -c 10 http://localhost/api/status

# Results show:
# - Requests per second
# - Mean time per request
# - Failed requests
```

### Real-time Stats
```bash
# Monitor container resources
docker stats sirius_*

# Watch response times
curl -w "%{time_total}s\n" http://localhost/health
```

## 🔐 Security Scanning

```bash
# Run security scanner on all containers
docker ps -q | xargs -I{} ./check-docker-security.sh {}

# Or check specific container
./check-docker-security.sh app

# Expected issues to fix:
# - Running as root user
# - Dangerous capabilities
# - Writable root filesystem
# - Host network mode
```

## 📂 File Locations in Containers

| File | Location | Container |
|------|----------|-----------|
| App binary | `/app/app` | app |
| Middleware code | `/app/middleware.js` | rate-limiter |
| Request logs | `/app/logs/requests-YYYY-MM-DD.log` | rate-limiter |
| Nginx config | `/etc/nginx/nginx.conf` | nginx |
| DB data | `/var/lib/postgresql/data` | postgres |

## 🗄️ Database Connection String

```
postgresql://demo:demo@postgres:5432/demo
```

Environment variables in docker-compose.yml:
- `DB_HOST=postgres`
- `DB_PORT=5432`
- `DB_USER=demo`
- `DB_PASSWORD=demo`
- `DB_NAME=demo`

## 🛠️ Common Troubleshooting

### "Connection refused"
```bash
# Service not running?
docker-compose ps              # Check status
docker-compose logs postgres   # Check error logs
docker-compose restart app     # Restart service
```

### "Port already in use"
```bash
# Find what's using port 80
lsof -i :80

# Kill process
kill -9 <PID>

# Or change docker-compose.yml ports
```

### "Database table not found"
```bash
# Reinitialize database
docker-compose down -v         # Delete volumes
docker-compose up --build      # Recreate from init script
```

### "Rate limiting not working"
```bash
# Check middleware is running
docker-compose ps rate-limiter

# View middleware logs
docker-compose logs rate-limiter | tail -20

# Test middleware directly
curl -v http://localhost:3000/health
```

### "Can't connect to database"
```bash
# Check PostgreSQL is running
docker-compose ps postgres

# Test connection
docker-compose exec postgres psql -U demo -d demo -c "SELECT 1;"

# Check logs
docker-compose logs postgres | tail -20
```

## 📋 Lesson Checklist

### Lesson 1: Nginx Configuration
- [ ] Review nginx.conf
- [ ] Understand upstream configuration
- [ ] Study rate limiting zones
- [ ] Reload nginx: `docker-compose exec nginx nginx -s reload`

### Lesson 2: Docker Containerization
- [ ] Examine Dockerfile.app
- [ ] Review multi-stage build
- [ ] Check image size: `docker images sirius_*`
- [ ] Inspect layers: `docker history sirius_app`

### Lesson 3: Rate Limiting & Middleware
- [ ] Run `bash test-rate-limiting.sh`
- [ ] View middleware.js token bucket code
- [ ] Check response codes (200 vs 429)
- [ ] Verify per-IP rate limiting

### Lesson 4: Logging & Observability
- [ ] View file logs: `docker-compose exec rate-limiter cat /app/logs/requests-*.log | jq`
- [ ] Query database: `query_requests` (in debug-helpers)
- [ ] Run analytics query
- [ ] Correlate file logs with database records

### Lesson 5: Network Debugging & Security
- [ ] Run tcpdump on port 3000
- [ ] Use curl for HTTP testing
- [ ] Run security scanner
- [ ] Trace system calls with strace

## 🎯 Key Learning Points

1. **Rate Limiting**: Token bucket with per-IP tracking
2. **Logging**: Dual logging (files + database) for observability
3. **Networking**: Request flow through nginx → middleware → app → database
4. **Troubleshooting**: Use logs, tcpdump, curl, strace, and container inspection
5. **Security**: Check capabilities, users, filesystem permissions, network mode
6. **Performance**: Monitor response times, requests per second, error rates

## 📚 Documentation Files

- `README.md` - Full workshop documentation
- `QUICK-REFERENCE.md` - This file
- `SRE_Interview_Preparation.docx` - Interview prep materials
- `SRE_Practical_Workshop.pptx` - Presentation slides

## 🆘 Help & Examples

```bash
# View all examples
bash examples-tcpdump.sh       # tcpdump examples
bash examples-curl.sh          # curl examples
bash examples-strace.sh        # strace examples

# Load helper functions
source debug-helpers.sh && debug_help

# Check system requirements
docker --version
docker-compose --version
curl --version
```

## 🚀 Next Steps After Workshop

1. Implement improvements identified by security scanner
2. Set up container registry and CI/CD
3. Deploy to Kubernetes cluster
4. Monitor with Prometheus/Grafana
5. Implement alerting rules
6. Create runbooks for common failures
7. Practice incident response drills

---

**Workshop Duration**: 7.5 hours (5 × 1.5 hour lessons)
**Difficulty**: Intermediate to Advanced
**Prerequisites**: Docker basics, Linux command line, basic networking knowledge

For detailed explanations, see README.md or SRE_Interview_Preparation.docx
