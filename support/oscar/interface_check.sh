#!/bin/bash
# Bring up static interface if it is down; fails silently if that
# IP address is already assigned to another interface, say via DHCP.
# Example of usage via cron:
#@midnight /root/bin/interface_check.sh > /dev/null 2>&1

IPADDRESS=192.168.0.13    # change to actual private IP address
t1=$(ifconfig | grep -o em1:1)
t2='em1:1'

if [ "$t1" != "$t2" ]; then
  /sbin/ifconfig em1:1 $IPADDRESS netmask 255.255.255.0
fi

exit
