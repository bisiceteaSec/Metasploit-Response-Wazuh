#!/bin/bash

pids=( $(ps -aef | grep "php -r eval(base64_decode(" | grep -v grep | awk '{ print $2 }') )
pty=( $(ps -aef | grep "pty.spawn" | grep -v grep | awk '{ print $2 }') )
ip=( $(netstat -tp | grep "${pids}" |  awk '{ n = split($5, a, ":"); print a[n-1] }') )
if [ "${#pty[@]}" -gt 0 ]; then
  kill -9 "${pty[@]}";
fi
if [ "${#pids[@]}" -gt 0 ]; then
  kill -9 "${pids[@]}";
fi

if [[ z "$pids" ]]; then
  exit 0
else
  iptables -A INPUT -s $ip -j DROP
fi