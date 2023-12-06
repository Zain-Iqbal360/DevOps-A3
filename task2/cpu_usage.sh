#!/bin/bash

# Set the thresholds
LOW_THRESHOLD=10
HIGH_THRESHOLD=75

# Email notification status
low_notified=0
high_notified=0
cpu_high=0
cpu_low=0
email=$1
while true; do
    # Get current CPU utilization
    cpu_util=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d "." -f1)

    # Check if CPU utilization is below the low threshold
    if [[ $cpu_util -lt $LOW_THRESHOLD ]]; then
        cpu_low=1
        cpu_high=0
    elif [[ $cpu_util -gt $HIGH_THRESHOLD ]]; then
        cpu_high=1
        cpu_low=0
    else
        cpu_low=0
        cpu_high=0
    fi

    # Send email only if the CPU crossed the threshold and hasn't been notified
    if [[ $cpu_low -eq 1 && $low_notified -eq 0 ]]; then
        echo -e "To:$email\nSubject: Low CPU Utilization Alert\n\nCPU utilization is below $LOW_THRESHOLD%: $cpu_util%" | ssmtp $email
        low_notified=1
        high_notified=0
    elif [[ $cpu_high -eq 1 && $high_notified -eq 0 ]]; then
        echo -e "To: $email\nSubject: High CPU Utilization Alert\n\nCPU utilization is above $HIGH_THRESHOLD%: $cpu_util%" | ssmtp $email
        high_notified=1
        low_notified=0
    elif [[ $cpu_util -ge $LOW_THRESHOLD && $cpu_util -le $HIGH_THRESHOLD ]]; then
        # Reset notification flags if CPU utilization is within thresholds
        low_notified=0
        high_notified=0
    fi

    # Adjust the sleep duration based on how frequently you want to check the CPU utilization
    sleep 300  # 300 seconds (5 minutes) interval
done

