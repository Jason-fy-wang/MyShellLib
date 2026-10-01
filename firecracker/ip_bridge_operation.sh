#!/usr/bin/env bash


# create bridge
ip link add name br0 type bridge
ip link set br0 up


# add physical interfaces to the bridge
ip addr flush dev eth0
ip link set eth0 master br0
ip link set eth0 up

ip addr flush dev eth1
ip link set eth1 master br0
ip link set eth1 up

# assign IP to the bridge
ip addr add 192.168.1.10/24 dev br0
ip route add default via 192.168.1.1

# verify the bridge
ip link show type bridge
bridge link show
ip addr show br0
## show mac forward table
bridge fdb show dev br0


# enable STP on the bridge
### enable
ip link set br0 type bridge stp_state 1
### disable
ip link set br0 type bridge stp_state 0

# set bridge properties
## set forward delay (default 15s)
ip link set br0 type bridge forward_delay 400
## set hello time
ip link set br0 type bridge hello_time 200
## set max age
ip link set type br0 bridge max_age 2000


# remove the interface from bridge
ip link set eth1 nomaster

# delete the bridge
## first remove all the members
ip link set eth0 nomaster
ip link set eth1 nomaster

## delete the bridge
ip link set br0 down
ip link delete br0 type bridge


