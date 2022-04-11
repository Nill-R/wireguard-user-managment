#!/usr/bin/env bash

filename='/etc/wireguard/wg-hosts'

if test ! -f "$filename"; then
	echo $filename does not exist && exit 255
fi

n=1
while read line; do
	rsync /etc/wireguard/wg-all.conf $line:/etc/wireguard/
	n=$((n + 1))
done <$filename
