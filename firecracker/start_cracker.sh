#!/usr/bin/env bash

API_SOCKET="/tmp/firecracker.socket"

# Remove API unix socket
rm -f $API_SOCKET

# Run firecracker
./firecracker --api-sock "${API_SOCKET}" --enable-pci