#!/usr/bin/env bash

REPO_DIR=$(pwd)
cd $(mktemp -d /tmp/script.XXXXXXX) || exit
TEMP_DIR=$(pwd)

sudo apt update
sudo apt install -y jq wireguard

arch=$(uname -m)

mkdir -p /etc/wireguard/ui

upstreamdata=$(curl -s "https://api.github.com/repos/ngoduykhanh/wireguard-ui/releases/latest")

if [ $arch = "x86_64" ]; then
	wireguard_ui_url=$(echo "$upstreamdata" | jq -r '.assets[]  | select(.name | contains("linux-amd64")).browser_download_url' | grep -v md5)
fi

if [ $arch = aarch64 ]; then
	wireguard_ui_url=$(echo "$upstreamdata" | jq -r '.assets[]  | select(.name | contains("linux-arm64")).browser_download_url' | grep -v md5)
fi

wget -c "$wireguard_ui_url"

tar xfv wireguard-ui*
sudo cp wireguard-ui /usr/local/bin/
sudo cp $REPO_DIR/systemd/* /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable wireguard-ui
sudo systemctl enable wg-all-restart.{path,service}
sudo systemctl start wireguard-ui
sudo systemctl start wg-all-restart.{path,service}

cd ~ || exit
rm -rf "$TEMP_DIR"

exit 0
