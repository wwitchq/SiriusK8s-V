#!/bin/bash

# API Testing Script
# Tests various endpoints and HTTP scenarios

set -e

ENDPOINT=${1:-"http://localhost"}
VERBOSE=${2:-"-v"}

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

test_count=0
passed_count=0
failed_count=0

print_test() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Test: $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    ((test_count++))
}

pass() {
    echo -e "${GREEN}✓ PASSED${NC}: $1"
    ((passed_count++))
}

fail() {
    echo -e "${RED}✗ FAILED${NC}: $1"
    ((failed_count++))
}

check_status() {
    local response=$1
    local expected_code=$2
    local test_name=$3

    local http_code=$(echo "$response" | tail -1)

    if [ "$http_code" = "$expected_code" ]; then
        pass "$test_name (HTTP $http_code)"
        return 0
    else
        fail "$test_name (Expected $expected_code, got $http_code)"
        return 1
    fi
}

print_test "Health Check Endpoint"
response=$(curl -s -w "\n%{http_code}" "$ENDPOINT/health")
body=$(echo "$response" | head -1)
code=$(echo "$response" | tail -1)

echo "Response: $body"
check_status "$response" "200" "Health endpoint returns 200"

if echo "$body" | grep -q "healthy"; then
    pass "Health response contains 'healthy'"
else
    fail "Health response missing 'healthy' keyword"
fi

print_test "API Status Endpoint"
response=$(curl -s -w "\n%{http_code}" "$ENDPOINT/api/status")
body=$(echo "$response" | head -1)
code=$(echo "$response" | tail -1)

echo "Response: $body"
check_status "$response" "200" "API status returns 200"

if echo "$body" | grep -q "users_count"; then
    pass "API response contains 'users_count'"
else
    fail "API response missing 'users_count'"
fi

print_test "Root Path Endpoint"
response=$(curl -s -w "\n%{http_code}" "$ENDPOINT/")
code=$(echo "$response" | tail -1)

if [ "$code" = "200" ] || [ "$code" = "404" ]; then
    pass "Root path returns valid status ($code)"
else
    fail "Root path returns unexpected status ($code)"
fi

print_test "Custom Headers"
response=$(curl -s -w "\n%{http_code}" \
    -H "X-Request-ID: test-123" \
    -H "User-Agent: SRE-Workshop" \
    "$ENDPOINT/health")
code=$(echo "$response" | tail -1)

check_status "$response" "200" "Request with custom headers succeeds"

print_test "Verbose Output Test"
echo "Showing full request/response headers:"
curl -v "$ENDPOINT/health" 2>&1 | head -20

print_test "Response Time Measurement"
times=""
for i in {1..5}; do
    time_ms=$(curl -w "%{time_total}\n" -o /dev/null -s "$ENDPOINT/health")
    times="$times\n$time_ms"
    echo "Request $i: ${time_ms}s"
done
pass "Completed 5 requests to measure response time"

print_test "Connection Timeout Test"
response=$(curl -s -w "\n%{http_code}" --max-time 2 "$ENDPOINT/health")
code=$(echo "$response" | tail -1)

if [ "$code" = "200" ]; then
    pass "Request completed within 2 second timeout"
else
    fail "Request exceeded timeout or failed"
fi

print_test "Redirect Behavior"
response=$(curl -s -w "\n%{http_code}" -L "$ENDPOINT/health")
code=$(echo "$response" | tail -1)

if [ "$code" = "200" ]; then
    pass "Redirect following works correctly"
else
    fail "Redirect following failed"
fi

print_test "Invalid Endpoint"
response=$(curl -s -w "\n%{http_code}" "$ENDPOINT/nonexistent")
code=$(echo "$response" | tail -1)

if [ "$code" = "404" ] || [ "$code" = "405" ]; then
    pass "Invalid endpoint returns appropriate error ($code)"
else
    fail "Invalid endpoint returned unexpected code ($code)"
fi

print_test "POST Request to GET Endpoint"
response=$(curl -s -w "\n%{http_code}" -X POST "$ENDPOINT/health")
code=$(echo "$response" | tail -1)

if [ "$code" = "405" ] || [ "$code" = "501" ]; then
    pass "POST to GET endpoint rejected ($code)"
else
    echo "Note: Expected 405/501, got $code (may be due to nginx configuration)"
fi

print_test "Request with Auth Header"
response=$(curl -s -w "\n%{http_code}" \
    -H "Authorization: Bearer test-token-123" \
    "$ENDPOINT/health")
code=$(echo "$response" | tail -1)

check_status "$response" "200" "Request with auth header succeeds"

print_test "Accept Header Negotiation"
response=$(curl -s -w "\n%{http_code}" \
    -H "Accept: application/json" \
    "$ENDPOINT/api/status")
body=$(echo "$response" | head -1)
code=$(echo "$response" | tail -1)

check_status "$response" "200" "JSON content type accepted"
if echo "$body" | grep -E '^\{.*\}$' > /dev/null; then
    pass "Response is valid JSON"
else
    fail "Response is not valid JSON: $body"
fi

print_test "Large Header Values"
large_value=$(printf 'x%.0s' {1..500})
response=$(curl -s -w "\n%{http_code}" \
    -H "X-Custom-Header: $large_value" \
    "$ENDPOINT/health")
code=$(echo "$response" | tail -1)

if [ "$code" = "200" ] || [ "$code" = "431" ]; then
    pass "Large header handled appropriately ($code)"
else
    fail "Large header caused unexpected error ($code)"
fi

print_test "Follow Location Header"
response=$(curl -s -w "\n%{http_code}" -i "$ENDPOINT/health" 2>&1)
if echo "$response" | grep -i "location"; then
    echo "Location header found"
    pass "Response includes location header"
else
    echo "Note: No location header in response"
fi

print_test "Cache Control Headers"
response=$(curl -s -D - "$ENDPOINT/health" 2>&1)
if echo "$response" | grep -i "cache-control"; then
    pass "Cache-Control header present"
else
    echo "Note: No Cache-Control header (may be acceptable)"
fi

print_test "Content-Length Header"
response=$(curl -s -D - "$ENDPOINT/health" 2>&1)
if echo "$response" | grep -i "content-length"; then
    pass "Content-Length header present"
else
    fail "Content-Length header missing"
fi

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "Total Tests: $test_count"
echo -e "${GREEN}Passed: $passed_count${NC}"
echo -e "${RED}Failed: $failed_count${NC}"

if [ $failed_count -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed. Review output above.${NC}"
    exit 1
fi
