#!/bin/bash

# Docker Security Scanner
# Checks containers for security vulnerabilities including:
# - Dangerous capabilities
# - Running as root
# - Filesystem configuration
# - Network settings
# - Volume mounts

set -e

# Color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track issues found
CRITICAL_ISSUES=0
WARNING_ISSUES=0

# Dangerous capabilities that should not be granted
DANGEROUS_CAPS=(
    "NET_ADMIN"
    "SYS_ADMIN"
    "SYS_MODULE"
    "SYS_PTRACE"
    "DAC_READ_SEARCH"
    "DAC_OVERRIDE"
    "NET_RAW"
    "KILL"
)

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_critical() {
    echo -e "${RED}[CRITICAL]${NC} $1"
    ((CRITICAL_ISSUES++))
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    ((WARNING_ISSUES++))
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

check_container_security() {
    local container=$1

    if ! docker inspect "$container" > /dev/null 2>&1; then
        echo -e "${RED}Error: Container '$container' not found${NC}"
        return 1
    fi

    echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
    echo -e "${BLUE}Container: $container${NC}"
    echo -e "${BLUE}═══════════════════════════════════════${NC}"

    # Get container info
    local user=$(docker inspect --format='{{.Config.User}}' "$container")
    local caps_add=$(docker inspect --format='{{json .HostConfig.CapAdd}}' "$container")
    local caps_drop=$(docker inspect --format='{{json .HostConfig.CapDrop}}' "$container")
    local privileged=$(docker inspect --format='{{.HostConfig.Privileged}}' "$container")
    local readonly_root=$(docker inspect --format='{{.HostConfig.ReadonlyRootfs}}' "$container")
    local network_mode=$(docker inspect --format='{{.HostConfig.NetworkMode}}' "$container")
    local pid_mode=$(docker inspect --format='{{.HostConfig.PidMode}}' "$container")
    local ipc_mode=$(docker inspect --format='{{.HostConfig.IpcMode}}' "$container")
    local volumes=$(docker inspect --format='{{json .Mounts}}' "$container")
    local security_opt=$(docker inspect --format='{{json .HostConfig.SecurityOpt}}' "$container")
    local sysctls=$(docker inspect --format='{{json .HostConfig.Sysctls}}' "$container")

    # 1. Check if running as root
    echo -e "\n${BLUE}1. User Execution${NC}"
    if [ -z "$user" ] || [ "$user" = "root" ]; then
        print_critical "Container running as root (User: '$user')"
        echo "  Recommendation: Specify a non-root user in Dockerfile with USER directive"
    else
        print_info "Running as non-root user: $user"
    fi

    # 2. Check Privileged mode
    echo -e "\n${BLUE}2. Privileged Mode${NC}"
    if [ "$privileged" = "true" ]; then
        print_critical "Container running in privileged mode"
        echo "  Recommendation: Remove --privileged flag unless absolutely necessary"
    else
        print_info "Privileged mode: disabled"
    fi

    # 3. Check Capabilities
    echo -e "\n${BLUE}3. Linux Capabilities${NC}"

    if echo "$caps_add" | grep -q "null"; then
        print_info "No additional capabilities added"
    else
        echo "  Added capabilities:"
        echo "$caps_add" | grep -o '"[^"]*"' | tr -d '"' | while read cap; do
            if [[ " ${DANGEROUS_CAPS[@]} " =~ " ${cap} " ]]; then
                print_critical "Dangerous capability added: $cap"
            else
                print_info "Added: $cap"
            fi
        done
    fi

    if echo "$caps_drop" | grep -q "null"; then
        print_warning "No capabilities explicitly dropped"
        echo "  Recommendation: Drop all capabilities and add back only required ones"
        echo "  Example: --cap-drop=ALL --cap-add=NET_BIND_SERVICE"
    else
        echo "  Dropped capabilities:"
        echo "$caps_drop" | grep -o '"[^"]*"' | tr -d '"' | while read cap; do
            if [ "$cap" = "ALL" ]; then
                print_info "Dropped: ALL (Good practice)"
            else
                print_info "Dropped: $cap"
            fi
        done
    fi

    # 4. Check readonly rootfs
    echo -e "\n${BLUE}4. Filesystem Configuration${NC}"
    if [ "$readonly_root" = "true" ]; then
        print_info "Root filesystem is read-only (Good security practice)"
    else
        print_warning "Root filesystem is writable"
        echo "  Recommendation: Use --read-only flag to mount root filesystem as read-only"
    fi

    # 5. Check Network mode
    echo -e "\n${BLUE}5. Network Configuration${NC}"
    if [ "$network_mode" = "host" ]; then
        print_critical "Container using host network mode"
        echo "  Recommendation: Use bridge network mode for isolation (default)"
    else
        print_info "Network mode: $network_mode"
    fi

    # 6. Check PID mode
    echo -e "\n${BLUE}6. Process Namespace${NC}"
    if [ "$pid_mode" = "host" ]; then
        print_critical "Container sharing host PID namespace"
        echo "  Recommendation: Use container's own PID namespace (default)"
    else
        print_info "PID mode: $pid_mode"
    fi

    # 7. Check IPC mode
    echo -e "\n${BLUE}7. IPC Namespace${NC}"
    if [ "$ipc_mode" = "host" ]; then
        print_warning "Container sharing host IPC namespace"
        echo "  Recommendation: Use container's own IPC namespace (default)"
    else
        print_info "IPC mode: $ipc_mode"
    fi

    # 8. Check Volume mounts
    echo -e "\n${BLUE}8. Volume Mounts${NC}"
    if echo "$volumes" | grep -q "\[\]"; then
        print_info "No volumes mounted (minimal attack surface)"
    else
        echo "  Mounted volumes:"
        docker inspect --format='{{range .Mounts}}{{.Source}} -> {{.Destination}} ({{.Mode}}){{"\n"}}{{end}}' "$container" | while read line; do
            if [ ! -z "$line" ]; then
                if echo "$line" | grep -qE "(/|:ro)"; then
                    if echo "$line" | grep -q ":rw"; then
                        print_warning "Volume mounted read-write: $line"
                    else
                        print_info "Volume mounted read-only: $line"
                    fi
                else
                    print_info "$line"
                fi
            fi
        done
    fi

    # 9. Check security options
    echo -e "\n${BLUE}9. Security Options (AppArmor/SELinux)${NC}"
    if echo "$security_opt" | grep -q "null"; then
        print_warning "No security options configured"
        echo "  Recommendation: Use AppArmor or SELinux profiles for additional isolation"
    else
        echo "  Security options:"
        echo "$security_opt" | grep -o '"[^"]*"' | tr -d '"' | while read opt; do
            print_info "$opt"
        done
    fi

    # 10. Check sysctls
    echo -e "\n${BLUE}10. System Control Parameters${NC}"
    if echo "$sysctls" | grep -q "null"; then
        print_info "No custom sysctls configured"
    else
        echo "  Custom sysctls:"
        echo "$sysctls" | grep -o '"[^"]*"' | tr -d '"' | while read sysctl; do
            print_warning "Custom sysctl: $sysctl (Verify necessity)"
        done
    fi
}

print_summary() {
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}Security Check Summary${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}\n"

    if [ $CRITICAL_ISSUES -gt 0 ]; then
        echo -e "${RED}Critical Issues: $CRITICAL_ISSUES${NC}"
    fi

    if [ $WARNING_ISSUES -gt 0 ]; then
        echo -e "${YELLOW}Warnings: $WARNING_ISSUES${NC}"
    fi

    if [ $CRITICAL_ISSUES -eq 0 ] && [ $WARNING_ISSUES -eq 0 ]; then
        echo -e "${GREEN}No critical issues or warnings found!${NC}"
    fi

    echo -e "\n${BLUE}Best Practices Checklist:${NC}"
    echo "  ☐ Run as non-root user"
    echo "  ☐ Drop all capabilities (--cap-drop=ALL)"
    echo "  ☐ Add only required capabilities"
    echo "  ☐ Use read-only root filesystem (--read-only)"
    echo "  ☐ Use bridge network mode (avoid --network=host)"
    echo "  ☐ Use container PID namespace (avoid --pid=host)"
    echo "  ☐ Use container IPC namespace (avoid --ipc=host)"
    echo "  ☐ Mount volumes as read-only when possible"
    echo "  ☐ Use security profiles (AppArmor/SELinux)"
    echo "  ☐ Avoid running privileged containers"
    echo ""
}

# Main script execution
if [ $# -eq 0 ]; then
    print_header "Docker Security Scanner"
    echo "Usage: $0 <container_name_or_id>"
    echo ""
    echo "This script checks container security configuration including:"
    echo "  - User execution (root vs non-root)"
    echo "  - Privileged mode"
    echo "  - Linux capabilities"
    echo "  - Filesystem configuration"
    echo "  - Network namespace"
    echo "  - Process and IPC namespace"
    echo "  - Volume mounts"
    echo "  - Security options (AppArmor/SELinux)"
    echo "  - System control parameters"
    echo ""
    echo "Examples:"
    echo "  $0 app                              # Check single container"
    echo "  $0 postgres                         # Check postgres container"
    echo "  docker ps -q | xargs -I{} $0 {}   # Check all running containers"
    exit 0
fi

for container in "$@"; do
    check_container_security "$container"
done

print_summary

# Exit with error code if critical issues found
if [ $CRITICAL_ISSUES -gt 0 ]; then
    exit 1
fi

exit 0
