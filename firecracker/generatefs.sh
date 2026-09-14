#!/usr/bin/env bash

ARCH="$(uname -m)"
S3="https://s3.amazonaws.com/spec.ccfc.min"

# Fetch latest CI artifact build. `sort` + `tail` returns artifacts with latest YYYYMMDD.
CI_ARTIFACTS_PREFIX=$(curl -fsSL "$S3?list-type=2&prefix=firecracker-ci/&delimiter=/" \
    | grep -oP "(?<=<Prefix>)firecracker-ci/[0-9]{8}-[^/]+/(?=</Prefix>)" \
    | sort \
    | tail -1)

latest_kernel_key=$(curl -fsSL "$S3?list-type=2&prefix=${CI_ARTIFACTS_PREFIX}${ARCH}/vmlinux-" \
      | grep -oP "(?<=<Key>)(${CI_ARTIFACTS_PREFIX}${ARCH}/vmlinux-[0-9]+\.[0-9]+\.[0-9]{1,3})(?=</Key>)" \
      | sort -V \
      | tail -1)

# Download a linux kernel binary
wget "$S3/${latest_kernel_key}"

latest_ubuntu_key=$(curl -fsSL "$S3?list-type=2&prefix=${CI_ARTIFACTS_PREFIX}${ARCH}/ubuntu-" \
      | grep -oP "(?<=<Key>)(${CI_ARTIFACTS_PREFIX}${ARCH}/ubuntu-[0-9]+\.[0-9]+\.squashfs)(?=</Key>)" \
      | sort -V \
      | tail -1)
ubuntu_version=$(basename $latest_ubuntu_key .squashfs | grep -oE '[0-9]+\.[0-9]+')

# Download a rootfs from Firecracker CI
wget -O ubuntu-$ubuntu_version.squashfs.upstream "$S3/$latest_ubuntu_key"

# The rootfs in our CI doesn't contain SSH keys to connect to the VM
# For the purpose of this demo, let's create one and patch it in the rootfs
unsquashfs ubuntu-$ubuntu_version.squashfs.upstream
ssh-keygen -f id_rsa -N ""
cp -v id_rsa.pub squashfs-root/root/.ssh/authorized_keys
# update permission
chmod 700 /mnt/rfs/root/.ssh
chmod 600 /mnt/rfs/root/.ssh/authorized_keys
mv -v id_rsa ./ubuntu-$ubuntu_version.id_rsa

# create ext4 filesystem image
sudo chown -R root:root squashfs-root
truncate -s 1G ubuntu-$ubuntu_version.ext4
sudo mkfs.ext4 -d squashfs-root -F ubuntu-$ubuntu_version.ext4

# Verify everything was correctly set up and print versions
echo
echo "The following files were downloaded and set up:"
KERNEL=$(ls vmlinux-* | tail -1)
[ -f $KERNEL ] && echo "Kernel: $KERNEL" || echo "ERROR: Kernel $KERNEL does not exist"
ROOTFS=$(ls *.ext4 | tail -1)
e2fsck -fn $ROOTFS &>/dev/null && echo "Rootfs: $ROOTFS" || echo "ERROR: $ROOTFS is not a valid ext4 fs"
KEY_NAME=$(ls *.id_rsa | tail -1)
[ -f $KEY_NAME ] && echo "SSH Key: $KEY_NAME" || echo "ERROR: Key $KEY_NAME does not exist"

