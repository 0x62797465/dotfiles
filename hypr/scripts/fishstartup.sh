#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    # Use 'mpstat' to get the CPU usage
    cpu_idle=$(mpstat 1 1 | awk '/Average/ {print $NF}')
    cpu_usage=$(echo "100 - $cpu_idle" | bc)
    echo $cpu_usage
}

# Function to get memory usage
get_memory_usage() {
    # Use 'free' to get the memory usage
    mem_total=$(free | awk '/Mem/ {print $2}')
    mem_used=$(free | awk '/Mem/ {print $3}')
    mem_usage=$(echo "$mem_used / $mem_total * 100" | bc -l)
    echo $mem_usage
}

# Thresholds
cpu_threshold=90
mem_threshold=80

# ANSI color code for yellow
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get current CPU and memory usage
current_cpu_usage=$(get_cpu_usage)
current_mem_usage=$(get_memory_usage)

# Print CPU usage if over threshold
if (( $(echo "$current_cpu_usage > $cpu_threshold" | bc -l) )); then
    echo -e "${YELLOW}Warning: ${NC}CPU usage is over $cpu_threshold%: ${current_cpu_usage}%"
fi

# Print memory usage if over threshold
if (( $(echo "$current_mem_usage > $mem_threshold" | bc -l) )); then
    echo -e "${YELLOW}Warning: ${NC}Memory usage is over $mem_threshold%: ${current_mem_usage}%"
fi

