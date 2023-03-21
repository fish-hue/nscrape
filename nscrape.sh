#!/bin/bash

read -p "Enter the URL to scan: " url
read -p "Enter '4' to scan IPv4 or '6' to scan IPv6: " ip_version
read -p "Enter the port number to use for scanning: " port
read -p "Enter the maximum testing time per host in seconds: " max_time
read -p "Enter a list of plugins to run (leave blank for all): " plugins
read -p "Enter the starting directory for scanning: " root
read -p "Guess additional file names (Y/N): " mutate
read -p "Override the default user agent (Y/N): " user_agent
read -p "Use a proxy (Y/N): " use_proxy
read -p "Enter the pause time between tests in seconds: " pause
read -p "Disable SSL (Y/N): " no_ssl
read -p "Check database and key files for syntax errors (Y/N): " db_check

# set flags based on user input
if [ $ip_version -eq 4 ]; then
  ip_flag="-ipv4"
else
  ip_flag="-ipv6"
fi

if [ -n "$plugins" ]; then
  plugins_flag="-Plugins $plugins"
fi

if [ "$mutate" = "Y" ]; then
  mutate_flag="-mutate"
fi

if [ "$user_agent" = "Y" ]; then
  user_agent_flag="-useragent Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
fi

if [ "$use_proxy" = "Y" ]; then
  use_proxy_flag="-useproxy"
fi

if [ "$no_ssl" = "Y" ]; then
  no_ssl_flag="-nossl"
fi

if [ "$db_check" = "Y" ]; then
  db_check_flag="-dbcheck"
fi

# run nikto with the specified flags
nikto $ip_flag -port $port -maxtime $max_time $plugins_flag -root $root $mutate_flag $user_agent_flag $use_proxy_flag -Pause $pause $no_ssl_flag $db_check_flag -h $url
