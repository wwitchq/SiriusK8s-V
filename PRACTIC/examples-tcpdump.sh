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

