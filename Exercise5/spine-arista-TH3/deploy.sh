#!/bin/bash
set -x 
sudo cp config_db.json /etc/sonic/
sudo cp port_config.ini /usr/share/sonic/device/x86_64-arista_7060dx4_32/Arista-7060DX4-C32
sudo cp th3-a7060dx4-c32-32x400G.config.bcm /usr/share/sonic/device/x86_64-arista_7060dx4_32/Arista-7060DX4-C32
