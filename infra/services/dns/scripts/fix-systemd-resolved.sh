#!/bin/bash

sed -i 's,#DNSStubListener=yes,DNSStubListener=no,' /etc/systemd/resolved.conf
rm -f /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
service systemd-resolved restart
cat /etc/resolv.conf