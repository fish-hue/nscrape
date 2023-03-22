#!/bin/bash

read -p "Enter the URL or IP to scan: " url
read -p "Enter '4' to scan IPv4 or '6' to scan IPv6: " ip_version
read -p "Enter the maximum testing time per host in seconds: " max_time
read -p "Enter a list of plugins to run (leave blank for all): " plugins
read -p "Enter the starting directory for scanning: " root
read -p "Guess additional file names (Y/N): " mutate
read -p "Override the default user agent (Y/N): " user_agent
read -p "Use a proxy (Y/N): " use_proxy
read -p "Enter the pause time between tests in seconds: " pause
read -p "Disable SSL (Y/N): " no_ssl
read -p "Check database and key files for syntax errors (Y/N): " db_check

# Construct the Nikto command based on user inputs
nikto_command="nikto -host $url -maxtime $max_time -root $root -pause $pause -Format txt"

if [ "$ip_version" == "4" ]; then
    nikto_command="$nikto_command -ipv4"
elif [ "$ip_version" == "6" ]; then
    nikto_command="$nikto_command -ipv6"
fi

if [ ! -z "$plugins" ]; then
    nikto_command="$nikto_command -Plugins $plugins"
fi

if [ "$mutate" == "Y" ]; then
    nikto_command="$nikto_command -mutate"
fi

if [ "$user_agent" == "Y" ]; then
    read -p "Enter the custom user agent: " user_agent_value
    nikto_command="$nikto_command -useragent $user_agent_value"
fi

if [ "$use_proxy" == "Y" ]; then
    read -p "Enter the proxy URL: " proxy_url
    nikto_command="$nikto_command -useproxy $proxy_url"
fi

if [ "$no_ssl" == "Y" ]; then
    nikto_command="$nikto_command -nossl"
fi

if [ "$db_check" == "Y" ]; then
    nikto_command="$nikto_command -dbcheck"
fi

# Run the Nikto command on ports 80, 440, and 8080 can be adjusted as needed
nikto_command="$nikto_command -port 80,440,8080"
echo "Running the following Nikto command: $nikto_command"
$nikto_command

# Save the output to a file named after the IP or URL entered
output_file="$url.txt"
echo "Saving the output to file: $output_file"
$nikto_command -output $output_file
