#!/bin/bash

# https://sourceware.org/bugzilla/show_bug.cgi?id=23960
#dpkg --add-architecture i386

apt-get update
apt-get install -y qemu-user-binfmt
#apt-get install -y qemu-user-static:i386
