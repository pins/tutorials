<!--
Copyright 2021-present Open Networking Foundation

SPDX-License-Identifier: Apache-2.0
-->

## Build ONOS with PINS

This section provides instructions to build ONOS and add the PINS driver and SAI
pipeliner. You may use this to customize the SAI pipeliner for your network.

### Method 1 (recommended): Building ONOS with required PINS apps

The Docker image that was used in Exercise 4 (`dmoro92/pins-onos:0.0.1`) is
hosted on [Docker Hub](https://hub.docker.com/r/dmoro92/pins-onos/tags).

If you'd like to build the image yourself, you can download the Dockerfile and
supporting code from [Github](https://github.com/pins/pins-onos) and follow the
instructions in the `README.md`.

The following prerequisites are required:

* Docker is running, and the build user has permissions to create and run
  containers/images
* python 3 and python 3 pip
* j2cli library (installed via pip)

### Method 2: Building ONOS separately

You will need to run a single instance of ONOS. The ONOS wiki, [Single Instance
Docker
Deployment](https://wiki.onosproject.org/display/ONOS/Single+Instance+Docker+deployment),
provides additional details. If you prefer to build ONOS yourself, follow the
instructions in the [ONOS Github
repository](https://github.com/opennetworkinglab/onos).

* This docker run command will also pull the latest version of ONOS.

    ```
    docker run --rm -t -d -p 8181:8181 -p 8101:8101 -p 5005:5005 -p 830:830 --name onos onosproject/onos:latest
    ```

* Verify that ONOS and p4rt are running.

    ```
    docker ps
    ```

#### PINS ONOS Driver and SAI Pipeliner

If you started ONOS using Method #2, use the following steps to build the
SONiC/PINS driver and SAI pipeliner. They will need to be manually installed on
the ONOS instance you just started.

1. Clone the PINS/sonic-onos-driver repository using one of the following:
    * HTTPS:       `git clone https://github.com/pins/sonic-onos-driver.git`
    * SSH:            `git clone git@github.com:pins/sonic-onos-driver.git`
    * GitHub CLI:  `gh repo clone pins/sonic-onos-driver`
2. Go to the new directory: `cd sonic-onos-driver`
3. Run `make build_driver build_pipeliner`
4. Run `make push_driver push_pipeliner [ONOS_IP=$ONOS_IP_ADDR]
   [ONOS_PORT=$ONOS_API_PORT]`
    * `ONOS_IP` default value is `localhost`
    * `ONOS_PORT` default value is `8181`
