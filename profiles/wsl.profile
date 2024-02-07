#!/bin/bash

function fixdns()
{
  sudo /home/ghostlapdev/.wsl/fixdns.sh
#   # write /etc/wsl.conf
#   sudo echo "[network]" > /etc/wsl.conf
#   echo "generateResolvConf = false" >> /etc/wsl.conf
#   echo "" >> /etc/wsl.conf
#   echo "nameserver 8.8.8.8" >> /etc/wsl.conf
#   echo "nameserver 8.8.8.4" >> /etc/wsl.conf
# 
#   # write /etc/resolve.conf
#   echo "nameserver 8.8.8.8" > /etc/resolve.conf
#   echo "nameserver 8.8.8.4" >> /etc/resolve.conf
}

function testdns()
{
  curl https://google.com
}

function healthcheck()
{
  curl https://reckon.ghostlaplabs.io/healthz.txt
}

function catclip()
{
  [ -z "$1" ] && echo "usage: catclip $filename" && return 1
  [ ! -f "$1" ] && echo "file doesn't exist ${1}" && return 1

  cat "$1" | clip
}
