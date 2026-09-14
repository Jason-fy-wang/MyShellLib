#!/usr/bin/env bash

sudo setfacl -m u:${USER}:rw /dev/kvm
