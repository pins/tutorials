<!--
Copyright 2021-present Open Networking Foundation

SPDX-License-Identifier: Apache-2.0
-->

## Exercise 3 - Set Up Pipeline and Routes

There are several ways to set up an SAI pipeline and routes. This exercise uses
the [P4RT client](https://github.com/pins/p4rt-client), and the next exercise
uses ONOS. The [P4RT shell](https://github.com/p4lang/p4runtime-shell) is
another alternative not currently illustrated in this tutorial. For this
exercise, we will use `p4rt-client` to isolate our initial SONiC behavior via
the PINS P4Runtime interface. You will be able to ping between your two hosts
through the PINS fabric at the end of this exercise.

If you prefer to skip this exercise, you can move directly to [Exercise 4 -
Deploy and Configure ONOS](../Exercise4) section and use flow objectives to set
up the routes.

### Starting From Scratch

This section contains tips to help you get a clean system, especially if you
have run through these exercises previously.

1. Make sure that ONOS is not already running.

    ```
    Server$ docker kill onos
    ```

2. Make sure the option, `-default_vrf_id=vrf-0`, is _not_ in the `p4rt.sh`
   file.

    ```
    Switch$ docker exec p4rt cat /usr/bin/p4rt.sh
    P4RT_ARGS=" -default_vrf_id=vrf-0 --alsologtostderr --logbuflevel=-1 "
    ```

3. If it is there, remove it with the following command, verify, and reload the
   configuration.

    ```
    Switch$ docker exec p4rt sed -i 's/ -default_vrf_id=vrf-0//g' /usr/bin/p4rt.sh
    Switch$ docker exec p4rt cat /usr/bin/p4rt.sh
    Switch$ sudo config reload -yf
    ```

If you reload the configuration on your switches or reboot them, review Exercise
2. Here is a summary of the commands you may need.

1. Are there any custom interface requirements, such as speed?

    ```
    switch1$ sudo config interface speed Ethernet120 40000
    switch2$ sudo config interface speed Ethernet120 40000
    ```

2. Reconfigure the interface IP address.

    ```
    switch1$ sudo config interface ip add Ethernet120 10.1.1.1/24
    switch2$ sudo config interface ip add Ethernet120 10.2.2.1/24
    ```

3. Verify switches and hosts, as you did in Exercise 2.

    ```
    switch1$ show interfaces status
    switch1$ show ip interfaces
    switch2$ show interfaces status
    switch2$ show ip interfaces
    host1$ ip address
    host1$ ip route
    host2$ ip address
    host2$ ip route
    ```

### Software for this Exercise

<!-----

You have some errors, warnings, or alerts. If you are using reckless mode, turn it off to see inline alerts.
* ERRORs: 1
* WARNINGs: 0
* ALERTS: 1

Conversion time: 0.835 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β33
* Tue Feb 22 2022 16:11:51 GMT-0800 (PST)
* Source doc: SONiC/PINS Tutorial
* This is a partial selection. Check to make sure intra-doc links work.

ERROR:
undefined internal link to this URL: "#heading=h.2p04fx16tvl9".link text: Software Used in Tutorial
?Did you generate a TOC?

----->


<p style="color: red; font-weight: bold">>>>>>  gd2md-html alert:  ERRORs: 1; WARNINGs: 0; ALERTS: 1.</p>
<ul style="color: red; font-weight: bold"><li>See top comment block for details on ERRORs and WARNINGs. <li>In the converted Markdown or HTML, search for inline alerts that start with >>>>>  gd2md-html alert:  for specific instances that need correction.</ul>

<p style="color: red; font-weight: bold">Links to alert messages:</p><a href="#gdcalert1">alert1</a>

<p style="color: red; font-weight: bold">>>>>> PLEASE check and correct alert issues and delete this message and the inline alerts.<hr></p>


The sample configuration files in this exercise, `onf.p4info.pb.txt` and `p4rt-client-setup.sh`, are found in the PINS tutorials repository. 



1. Download the files for Exercise3 or clone the repository, as described in 
[Software Used in Tutorial](../README.md#software-used-in-tutorial).

2. Go to the directory with the configuration files for Exercise3. 

    ```
    Server$ cd $TUTORIALS_PATH/Exercise3

    ```

There are two utilities used in this exercise, `p4rt-client` and `macToIpV6.`The `p4rt-client` configures the SAI layer of a SONiC-based switch via the P4Runtime Service. It can configure the switch, but it is not a runtime controller and cannot handle incoming packets. The `macToIpV6` utility takes a MAC address in the format `00:11:22:33:44:55` and prints the IPv6 link-local address to STDOUT. Linux and MacOS (Intel and M1) versions of these utilities are available for your server in [p4rt-client releases](https://github.com/pins/p4rt-client/releases). 

3. To get Linux versions of these utilities, use the following commands:

    ```
    Server$ wget https://github.com/pins/p4rt-client/releases/download/202112/p4rt-client
    Server$ wget https://github.com/pins/p4rt-client/releases/download/202112/macToIpV6
    ```

4. Make sure the script and programs are executable.

    ```
    Server$ cd $TUTORIALS_PATH/Exercise3
    Server$ chmod 0755 p4rt-client-setup.sh p4rt-client macToIpV6
    ```
### p4rt-client Command Line Interface

We will run `p4rt-client` commands (see
[Usage](https://github.com/pins/p4rt-client#usage) or use `p4rt-client -help` )
on the server to configure routes in both directions. For convenience, here are
the options we will use in this exercise:

* `-pushP4Info` loads the P4 mapping file into the switch. This file contains
  references to tables and actions for the P4Runtime application.
* `-addRouterInt` creates a virtual interface and map it to a physical interface
* `-addNeighbor` defines an adjacent entity (e.g., switch, router, server)
* `-addNextHop` creates a NextHop label for an interface and neighbor
  combination
* `-addIpV4` creates a route entry and point it to a NextHop
* `-destMAC`is the MAC address of the destination switch
* `-egressPort` is the switch port to egress (default 10000)
* `-neighborName` is the link-local address for `-destMAC` (use the `macToIpV6`
  conversion utility)
* `-nextHopId` is the name to associate with the next hop entry
* `-p4info` is the p4info text filename that describes the p4 application
* `-routerInterface` is the name to give the router interface
* `-routerPortId` is the port number to assign to the router interface port
  (default 9999999)
* `-routerIntMac` is the MAC address of the source switch to be used for the
  router interface (e.g., 00:00:00:11:22:dd)
* `-routedNetwork` is the IP address space (CIDR) for the host you want to
  connect to (e.g., 1.2.3.4/8)
* `-server` is the IP address and port of the p4rt server on the switch

The `p4rt-client` commands will add database entries to Redis DB that establish
the routes on each switch.

| p4rt-client Command      | Resulting table entry in Redis   |
|--------------------------|----------------------------------|
| Push P4 information      | DEFINITION:ACL_ACL_INGRESS_TABLE |
| Add the router interface | FIXED_ROUTER_INTERFACE_TABLE     |
| Add the router neighbor  | FIXED_NEIGHBOR_TABLE             |
| Add the next hop         | FIXED_NEXTHOP_TABLE              |
| Add the IPv4 address     | FIXED_IPV4_TABLE                 |

### Setting Up Routes in the SONiC Redis Database

1. First, `ssh` into the switches, and you will not find any routes in the SONiC
   Redis database.

    ```
    Switch$ redis-cli keys P4*
    (empty array)
    ```

2. Edit the sample script file, `p4rt-client-setup.sh`, to reflect the routes
   available in your network. In our example, we set up routes through Ethernet0
   on the two switches. We did not use Ethernet104 in this example.

    ```
    Server$ vim p4rt-client-setup.sh

    #!/bin/bash
    ./p4rt-client -pushP4Info -server=10.70.2.5:9559 -p4info=onf.p4info.pb.txt
    ./p4rt-client -addRouterInt -server 10.70.2.5:9559 -routerInterface="Ethernet0" -routerPortId=1000 -routerIntMAC="a8:2b:b5:f0:f0:f5" -egressPort="Ethernet0"
    ./p4rt-client -addNeighbor -server 10.70.2.5:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:ede3" -destMAC="a8:2b:b5:f0:ed:e3"
    ./p4rt-client -addNextHop -server 10.70.2.5:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:ede3" -nextHopId="as7712-3"
    ./p4rt-client -addIpV4 -server 10.70.2.5:9559 -routedNetwork=10.2.2.0/24 -nextHopId="as7712-3"

    ./p4rt-client -pushP4Info -server=10.70.2.6:9559 -p4info=onf.p4info.pb.txt
    ./p4rt-client -addRouterInt -server 10.70.2.6:9559 -routerInterface="Ethernet0" -routerPortId=1000 -routerIntMAC="a8:2b:b5:f0:ed:e3" -egressPort="Ethernet0"
    ./p4rt-client -addNeighbor -server 10.70.2.6:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:f0f5" -destMAC="a8:2b:b5:f0:f0:f5"
    ./p4rt-client -addNextHop -server 10.70.2.6:9559 -routerInterface="Ethernet0" -neighborName="fe80::aa2b:b5ff:fef0:f0f5" -nextHopId="as7712-2"
    ./p4rt-client -addIpV4 -server 10.70.2.6:9559 -routedNetwork=10.1.1.0/24 -nextHopId="as7712-2"
    ```

3. Run the script.

    ```
    Server$ ./p4rt-client-setup.sh
    ```

4. Check the routes in SONiC’s Redis DB on each switch.

    ```
    switch1$ redis-cli keys P4*
    1) "P4RT:FIXED_NEIGHBOR_TABLE:{\"match/neighbor_id\":\"fe80::aa2b:b5ff:fef0:ede3\",\"match/router_interface_id\":\"Ethernet0\"}"
    2) "P4RT:FIXED_IPV4_TABLE:{\"match/ipv4_dst\":\"10.2.2.0/24\",\"match/vrf_id\":\"\"}"
    3) "P4RT:DEFINITION:ACL_ACL_INGRESS_TABLE"
    4) "P4RT:FIXED_ROUTER_INTERFACE_TABLE:{\"match/router_interface_id\":\"Ethernet0\"}"
    5) "P4RT:FIXED_NEXTHOP_TABLE:{\"match/nexthop_id\":\"as7712-3\"}"
    
    switch2$ redis-cli keys P4*
    1) "P4RT:FIXED_NEXTHOP_TABLE:{\"match/nexthop_id\":\"as7712-2\"}"
    2) "P4RT:FIXED_ROUTER_INTERFACE_TABLE:{\"match/router_interface_id\":\"Ethernet0\"}"
    3) "P4RT:DEFINITION:ACL_ACL_INGRESS_TABLE"
    4) "P4RT:FIXED_IPV4_TABLE:{\"match/ipv4_dst\":\"10.1.1.0/24\",\"match/vrf_id\":\"\"}"
    5) "P4RT:FIXED_NEIGHBOR_TABLE:{\"match/neighbor_id\":\"fe80::aa2b:b5ff:fef0:f0f5\",\"match/router_interface_id\":\"Ethernet0\"}"
    ```

**IMPORTANT: See the Troubleshooting section below if you do not see these five
entries in Redis.**

### Generate Routed Traffic

1. Clearing counters will make it easier to monitor the traffic in this
   exercise.

    ```
    switch1$ sonic-clear counters
    switch2$ sonic-clear counters
    ```

2. Ping between the hosts, and they now work through the fabric.

    ```
    host1$ ping 10.2.2.2  (works)
    host2$ ping 10.1.1.2  (works)
    ```

3. Verify the ping traffic.

    ```
    switch1$ show interfaces counters
    switch2$ show interfaces counters
    ```

### Troubleshooting

Try reloading the configuration on the switch and then reconfigure the switch
interfaces as you did in [Exercise 2](../Exercise2).

```
Switch$ sudo config reload -yf
```

Try rebooting the switch and then verify connections and reconfigure the switch
Interfaces as you did in Exercise 2.

```
Switch$ sudo reboot now
```
