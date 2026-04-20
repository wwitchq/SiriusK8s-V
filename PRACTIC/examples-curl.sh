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

