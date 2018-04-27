#!/bin/bash
TEST=$(ip a | grep mtu | wc -l)
sleep 3
[ "4" = $TEST ] && reboot