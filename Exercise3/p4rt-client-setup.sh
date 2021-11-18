#!/bin/bash
./p4rt-client -pushP4Info -server=10.70.2.5:9559 -p4info=onf.p4info.pb.txt
./p4rt-client -addRouterInt -server 10.70.2.5:9559 -routerInterface="Ethernet0" -routerPortId=1000 -routerIntMAC="a8:2b:b5:f0:f0:f5" -egressPort="Ethernet0"
./p4rt-client -addNeighbor -server 10.70.2.5:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:ede3" -destMAC="a8:2b:b5:f0:ed:e3"
./p4rt-client -addNextHop -server 10.70.2.5:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:ede3" -nextHopId="switch2"
./p4rt-client -addIpV4 -server 10.70.2.5:9559 -routedNetwork=10.2.2.0/24 -nextHopId="switch2"

./p4rt-client -pushP4Info -server=10.70.2.6:9559 -p4info=onf.p4info.pb.txt
./p4rt-client -addRouterInt -server 10.70.2.6:9559 -routerInterface="Ethernet0" -routerPortId=1000 -routerIntMAC="a8:2b:b5:f0:ed:e3" -egressPort="Ethernet0"
./p4rt-client -addNeighbor -server 10.70.2.6:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:f0f5" -destMAC="a8:2b:b5:f0:f0:f5"
./p4rt-client -addNextHop -server 10.70.2.6:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:f0f5" -nextHopId="switch1"
./p4rt-client -addIpV4 -server 10.70.2.6:9559 -routedNetwork=10.1.1.0/24 -nextHopId="switch1"

