## Introduction

Welcome to the PINS-ONOS tutorial! **P4 Integrated Network Stack** (PINS) is a project that provides components and modifications to SONiC, allowing P4 and P4Runtime (P4RT) to control the network stack remotely. The Open Compute Project (OCP) [summit in November 2021](https://opennetworking.org/events/ocp-global-summit-2021/) launched PINS ([talk video](https://www.youtube.com/watch?v=QOASuHSn7z8) (34:09), [talk slides](https://fntech.sfo2.digitaloceanspaces.com/PresentationMediaUploads/31/1993/OCP-PINS-2021-1c98a1591d51078fc4118646f5bd0e97.pdf), [complete demonstration video](https://www.youtube.com/watch?v=iZuWdiV9dnc) (10:49), and [demonstration slides](https://opennetworking.org/wp-content/uploads/2021/12/PINS-OCP-2021-Demo-Slides.pdf)). 

This tutorial targets students and practitioners who want to run a functional SDN stack on SONiC. This document describes the required components, configuration, and commands to observe the interactions between a PINS switch and the SDN control plane. 


### Background


#### Highlights

The highlights of the PINS/SONiC project are:



* **Opt-In Path Towards SDN**: incrementally implement new SDN functions in SONiC 
* **Hybrid Control Plane Support**: choose the network control plane and assign which parts run locally or remotely
* **Familiar Interface**: model the SAI pipeline in P4 to control bridging, routing, ACLs, tunnels, and more
* **Rapid Innovation**: model new features in P4 and expose them to control plane applications. 
* **Automated Validation**: test and validate packet paths in the forwarding pipeline with P4Runtime.


#### Why would you want to add SDN functionality to SONiC? 

When you add SDN functionality to SONiC, you can enable hitless route sequencing and inline network functions such as load balancers and firewalls. But more importantly, you can optimize data center utilization by analyzing Inband Network Telemetry (INT) and implementing Weighted Cost MultiPath (WCMP, aka UCMP). 


#### What SDN functionality does PINS add to SONiC? 

SONiC is based on a Switch Abstraction Interface (SAI), a standardized interface to allow programming and managing switch ASICs in a vendor-independent fashion. PINS works on all existing SONiC targets using SAI features, including fixed functions (e.g., routing) and configurable ones (e.g., ACLs). PINS programs the SAI pipeline in P4, bringing SDN capabilities to SONiC.


#### What components does PINS add to SONiC?

SONiC is structured into various containers that communicate via a shared Redis instance through multiple logical databases. The PINS project adds capabilities to SONiC as described in the [high-level design](https://github.com/pins/SONiC/blob/pins-hld/doc/pins/pins_hld.md), [definitions](https://github.com/Azure/SONiC/blob/078b908db3604e17f5b07e3656388a164e209427/doc/pins/pins_hld.md#definitions--abbreviations), and the [PINS architectural diagram](https://github.com/Azure/SONiC/blob/078b908db3604e17f5b07e3656388a164e209427/doc/pins/pins_hld.md#architecture).  [P4Runtime (P4RT)](https://github.com/pins/SONiC/blob/p4rt_hld/doc/pins/p4rt_app_hld.md) is a new application running in its own container that receives P4 programming requests from an SDN controller. P4RT writes intents to new P4 tables and supports clients with state information. New components (Github: [Azure/sonic-pins](https://github.com/Azure/sonic-pins)) include [P4Orch](https://github.com/pins/SONiC/blob/pins-hld/doc/pins/pins_hld.md#p4-orchagent) and [P4RT tables](https://github.com/pins/SONiC/blob/pins-hld/doc/pins/pins_hld.md#p4-appl-db-tables) to process database entries, create SAI objects, and add to the ASIC database. PINS also introduces modifications to [sonic-swss](https://github.com/Azure/sonic-swss), [sonic-swss-common](https://github.com/Azure/sonic-swss-common), and [sonic-buildimage](https://github.com/Azure/sonic-buildimage). 


### Tutorial Outline

The tutorial and hands-on exercises familiarize users with PINS ([webpage](https://opennetworking.org/pins/), [Working Group Github repository](https://github.com/pins), [wiki](https://wiki.opennetworking.org/display/COM/PINS)). Activities assume a basic knowledge of SONiC ([webpage](https://azure.github.io/SONiC/), [Github repository](https://github.com/Azure/SONiC/), [wiki](https://github.com/azure/sonic/wiki)) and SDN, including the [P4 language](https://p4.org) and ONOS ([webpage](https://opennetworking.org/onos/), [wiki](https://wiki.onosproject.org/display/ONOS/ONOS)). We provide participants with configuration files and scripts.

The exercises provide step-by-step instructions and validation as follows:

1. [Exercise 1 - Deploy SONiC/PINS Target Image](./Exercise1): deploy target images on your switches
2. [Exercise 2 - Configure Tutorial Network](./Exercise2): configure host and switch interfaces
3. [Exercise 3 - Set Up Pipeline and Routes](./Exercise3): set up connections using a simple command-line interface for P4Runtime. This exercise uses only one route between two switches.
4. [Exercise 4 - Deploy and Configure ONOS](./Exercise4): deploy ONOS on your server and push the network configuration using flow objectives instead of the p4rt-client in the previous exercise. This exercise enables ECMP with two routes between the two switches.
5. [Exercise 5 - PINS Fabric Demonstration](./Exercise5): This exercise explores the demonstration environment at the OCP summit. ONF implemented PINS on a 2x2 SD-Fabric and demonstrated WCMP.
6. Appendix - References: [Other Examples and Tutorials](References.md) are provided for particular areas of interest (i.e., P4, P4Runtime, gNMI, OpenConfig, ONOS, SONiC).
7. Appendix - Build it Yourself: instructions to [build a SONiC/PINS target image](BuildTargetImage.md) and [build ONOS with PINS](BuildONOSwithPINS.md).


### Software Used in Tutorial

To complete the exercises in this tutorial, you will use a variety of Linux and SONiC commands either directly or in the scripts we provide. Because there may be more than one way to view the same information, you may use alternate commands. Some of the software you’ll use include docker, redis-cli, and curl. 

For exercises 1 and 2, you will need to get the SONiC target images with PINS for your switches (.swi and/or .bin). If your switches do not have a previous version of SONiC installed, you will need to use the ONIE or Aboot installation software on your switch. 

Exercise 3 provides instructions to get `p4rt-client` and `macToIpv6`. Exercise 4 provides instructions to get an ONOS image with the PINS driver and pipeline installed. The [PINS tutorials repository](https://github.com/pins/tutorials) contains sample configuration files for the exercises.

Download the configuration file examples from GitHub or clone the repository using one of the following:

* HTTPS:	`git clone https://github.com/pins/tutorials.git` 
* SSH:		`git clone git@github.com:pins/tutorials.git`
* GitHub CLI:	`gh repo clone pins/tutorials`
