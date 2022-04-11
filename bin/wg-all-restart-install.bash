#!/usr/bin/env bash

REPO_DIR=$(pwd)
cd $(mktemp -d /tmp/script.XXXXXXX) || exit
TEMP_DIR=$(pwd)

sudo cp $REPO_DIR/systemd/* /etc/systemd/system/

sudo systemctl enable wg-all-restart.{path,service}
sudo systemctl start wg-all-restart.{path,service}

cd ~ || exit
rm -rf "$TEMP_DIR"

exit 0
