#!/bin/bash

mkdir workspace
cd workspace
wget https://github.com/pins/p4rt-client/releases/download/202112/p4rt-client
wget https://github.com/pins/p4rt-client/releases/download/202112/macToIpV6
cp ../Exercise3/onf.p4info.pb.txt ../Exercise3/p4rt-client-setup.sh .
cp ../Exercise4/flow-objectives.sh ../Exercise4/*.json .

