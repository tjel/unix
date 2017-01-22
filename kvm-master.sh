#!/bin/bash

OSvariant="ubuntu16.04"
Name="$OSvariant-test-7"

Virttype="kvm"
Hypervisor="qemu:///system"
Vcpu="1"
Memory="512"

# qemu-img create -f qcow2 -o preallocation=metadata /mnt/SSD2/vm/wotlk.qcow2
# format=qcow2,bus=virtio,cache=none
# DiskPath="/home/tjel/kvm/vm-images/centos7.img"
DiskPath="/home/tjel/kvm/vm-images/$Name.img"
DiskSize="10"


# --cdrom
# Cdrom="/home/tjel/images/CentOS-7-x86_64-Minimal.iso"
# --livecd
# Livecd=""

# --location
# Location="http://ftp.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/"
# Location="http://us.archive.ubuntu.com/ubuntu/dists/xenial/main/installer-amd64/"
# Location="/home/tjel/images/CentOS-7-x86_64-Minimal.iso"
# Location="/home/tjel/images/alpine-virt-3.5.0-x86_64.iso"
# Location="/home/tjel/images/alpine-vanilla-3.5.0-x86_64.iso"
# Location="/home/tjel/images/alpine-extended-3.5.0-x86_64.iso"
# Location="http://debian.ethz.ch/ubuntu/ubuntu/dists/xenial/main/installer-amd64/"
Location="/home/tjel/images/ubuntu-16.04.1-server-amd64.iso"
# Location="/home/tjel/images/CorePlus-current.iso"


# not used here but kept for consistency
# --console pty,target_type=serial
# --console pty,target_type=virtio

# "vnc", "vnc,port=5999", "vnc,password=foo", "spice"
Graphics="none"

# Network="--network bridge=br0"
# Network="--network model=virtio,bridge=br0"
# Network="--network model=virtio,mac=52:54:00:00:00:00"
# Network="--network model=virtio,bridge=br0,mac=52:54:00:00:00:00"

# --extra-args works only with --location
# ExtraArgs="hostname=test ip=10.10.10.120 dns=31.3.135.232 gateway=10.10.10.1 netmask=255.255.255.0 console=tty0 console=ttyS0,115200"
# ExtraArgs="console=ttyS0"
# ExtraArgs="console=ttyS0,115200n8 serial"
ExtraArgs="console=tty0 console=ttyS0,115200"

sudo virt-install \
--os-variant=$OSvariant \
--name=$Name \
--virt-type=$Virttype \
--connect=$Hypervisor \
--vcpus=$Vcpu \
--memory=$Memory \
--disk path=$DiskPath,size=$DiskSize \
--location=$Location \
--graphics=$Graphics \
--hvm \
--debug \
--extra-args="$ExtraArgs" \
--console pty,target_type=serial

