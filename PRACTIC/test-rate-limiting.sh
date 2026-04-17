#!/bin/bash

# Rate Limiting Test Script
# Demonstrates rate limiting behavior and recovery

ENDPOINT=${1:-"http://localhost"}
REQUESTS=${2:-50}

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Rate Limiting Demonstration${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
echo "Configuration:"
echo "  Endpoint: $ENDPOINT/api/status"
echo "  Rate Limit: 10 requests/second"
echo "  Burst Capacity: 20 requests"
echo "  Test Requests: $REQUESTS"
echo ""

# Arrays to track results
status_200=0
status_429=0
status_other=0
response_times=()

echo -e "${BLUE}Starting rapid requests...${NC}\n"

for i in $(seq 1 $REQUESTS); do
    # Get response code and time
    response=$(curl -s -w "\n%{http_code}\n%{time_total}" -o /dev/null "$ENDPOINT/api/status")
    http_code=$(echo "$response" | head -1)
    response_time=$(echo "$response" | tail -1)

    response_times+=("$response_time")

    # Count status codes
    case $http_code in
        200)
            status_200=$((status_200 + 1))
            printf "${GREEN}✓${NC} Request %3d: HTTP %3d (%.3fs)\n" "$i" "$http_code" "$response_time"
            ;;
        429)
            status_429=$((status_429 + 1))
            printf "${RED}✗${NC} Request %3d: HTTP %3d (%.3fs) - RATE LIMITED\n" "$i" "$http_code" "$response_time"
            ;;
        *)
            status_other=$((status_other + 1))
            printf "${YELLOW}!${NC} Request %3d: HTTP %3d (%.3fs)\n" "$i" "$http_code" "$response_time"
            ;;
    esac

    # Small delay between rapid requests (optional, adjust as needed)
    # Uncomment to slow down test
    # sleep 0.05
done

# Calculate statistics
echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Results Analysis${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"

echo "Status Code Distribution:"
echo -e "  ${GREEN}200 OK:${NC}                    $status_200 requests"
echo -e "  ${RED}429 Too Many Requests:${NC}  $status_429 requests"
if [ $status_other -gt 0 ]; then
    echo -e "  ${YELLOW}Other:${NC}                     $status_other requests"
fi
echo ""

# Calculate percentage
if [ $REQUESTS -gt 0 ]; then
    success_percent=$((status_200 * 100 / REQUESTS))
    limited_percent=$((status_429 * 100 / REQUESTS))
    echo "Success Rate:"
    echo -e "  ${GREEN}Successful: ${success_percent}%${NC}"
    echo -e "  ${RED}Rate Limited: ${limited_percent}%${NC}"
fi

# Response time analysis
if [ ${#response_times[@]} -gt 0 ]; then
    echo ""
    echo "Response Time Analysis:"

    # Find min, max, and average
    min_time=${response_times[0]}
    max_time=${response_times[0]}
    total_time=0

    for time in "${response_times[@]}"; do
        total_time=$(echo "$total_time + $time" | bc)
        if (( $(echo "$time < $min_time" | bc -l) )); then
            min_time=$time
        fi
        if (( $(echo "$time > $max_time" | bc -l) )); then
            max_time=$time
        fi
    done

    avg_time=$(echo "scale=3; $total_time / ${#response_times[@]}" | bc)

    echo "  Min: ${min_time}s"
    echo "  Max: ${max_time}s"
    echo "  Avg: ${avg_time}s"
fi

# Expected behavior explanation
echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Expected Behavior${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"

echo "Token Bucket Algorithm (10 req/s, burst 20):"
echo ""
echo "1. INITIAL PHASE (Burst):"
echo "   - First 20 requests get HTTP 200 (burst capacity)"
echo "   - Requests use pre-allocated burst tokens"
echo ""
echo "2. RATE LIMITING PHASE:"
echo "   - After burst exhausted, requests exceed rate"
echo "   - Incoming requests get HTTP 429 (Too Many Requests)"
echo "   - Server allows ~10 requests/second to pass through"
echo ""
echo "3. RECOVERY PHASE:"
echo "   - Pause test for >1 second"
echo "   - Tokens refill at 10 req/s rate"
echo "   - More requests succeed after pause"
echo ""

# Suggest recovery test
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Recovery Test${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Waiting 3 seconds for token refill...${NC}"
sleep 3

echo -e "${YELLOW}Sending 10 more requests (should succeed):${NC}\n"

recovery_success=0
for i in $(seq 1 10); do
    response=$(curl -s -w "%{http_code}" -o /dev/null "$ENDPOINT/api/status")

    if [ "$response" = "200" ]; then
        recovery_success=$((recovery_success + 1))
        echo -e "${GREEN}✓${NC} Recovery Request $i: HTTP $response"
    else
        echo -e "${RED}✗${NC} Recovery Request $i: HTTP $response"
    fi
done

echo ""
if [ $recovery_success -eq 10 ]; then
    echo -e "${GREEN}✓ All recovery requests succeeded - Rate limiter working correctly!${NC}"
elif [ $recovery_success -ge 8 ]; then
    echo -e "${YELLOW}◆ Most recovery requests succeeded - Rate limiter recovery working${NC}"
else
    echo -e "${RED}✗ Recovery test failed - Possible rate limiter issue${NC}"
fi

# Advanced test: Concurrent requests
echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Advanced Test: Concurrent Requests${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"

echo -e "${YELLOW}Sending 5 concurrent requests...${NC}\n"

concurrent_status_200=0
concurrent_status_429=0

for i in {1..5}; do
    (
        response=$(curl -s -w "%{http_code}" -o /dev/null "$ENDPOINT/api/status")
        echo "  Concurrent Request $i: HTTP $response"
    ) &
done

wait

echo ""
echo "All concurrent requests completed."

# Test different clients/IPs
echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Per-Client Rate Limiting Test${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"

echo "Rate limiting is per IP address. Each client gets independent limit."
echo "Testing from same IP (all share same limit):"
echo ""

for i in $(seq 1 5); do
    response=$(curl -s -w "%{http_code}" -o /dev/null "$ENDPOINT/api/status")
    echo "  Request from localhost: HTTP $response"
done

echo ""
echo "Note: To test from different IPs, modify X-Real-IP header:"
echo ""
for i in {1..3}; do
    response=$(curl -s -w "%{http_code}" -o /dev/null \
        -H "X-Real-IP: 192.168.1.$i" \
        "$ENDPOINT/api/status")
    echo "  Request from 192.168.1.$i: HTTP $response"
done

# Performance test
echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Performance Metrics${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}\n"

echo "Measuring sustained throughput (30 seconds)..."
start_time=$(date +%s%N)
request_count=0
success_count=0

for i in $(seq 1 100); do
    response=$(curl -s -w "%{http_code}" -o /dev/null "$ENDPOINT/api/status" 2>/dev/null)
    request_count=$((request_count + 1))

    if [ "$response" = "200" ]; then
        success_count=$((success_count + 1))
    fi

    # Check if 30 seconds have passed
    current_time=$(date +%s%N)
    elapsed=$(echo "scale=3; ($current_time - $start_time) / 1000000000" | bc)

    if (( $(echo "$elapsed >= 30" | bc -l) )); then
        break
    fi
done

end_time=$(date +%s%N)
elapsed_ns=$((end_time - start_time))
elapsed_s=$(echo "scale=2; $elapsed_ns / 1000000000" | bc)

throughput=$(echo "scale=2; $request_count / $elapsed_s" | bc)
success_rate=$(echo "scale=1; $success_count * 100 / $request_count" | bc)

echo "Duration: ${elapsed_s}s"
echo "Total Requests: $request_count"
echo "Successful: $success_count (${success_rate}%)"
echo "Throughput: ${throughput} req/s"
echo ""

if (( $(echo "$throughput > 10" | bc -l) )); then
    echo -e "${GREEN}✓ Sustained throughput is above rate limit (expected due to burst)${NC}"
else
    echo -e "${YELLOW}◆ Sustained throughput below 10 req/s (steady state)${NC}"
fi

echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test Complete${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
