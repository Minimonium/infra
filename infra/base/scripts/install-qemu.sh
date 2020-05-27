#!/bin/bash

# https://sourceware.org/bugzilla/show_bug.cgi?id=23960
dpkg --add-architecture i386

apt update
apt install -y qemu-user-static:i386
