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

