<!--
Copyright 2021-present Open Networking Foundation

SPDX-License-Identifier: Apache-2.0
-->

## Build SONiC/PINS Target Image

### Initialize Build Environment

This section provides instructions to build your target image. After you build
your image, follow the instructions in [Exercise 1 - Deploy SONiC/PINS Target
Image to Switches](./Exercise1).

The following software is needed to build the image: `curl, zip, unzip, tar,
python, j2cli` and `docker`.
> Note: Ensure that docker is not installed through snap. You may follow this guide [here](https://docs.docker.com/engine/install/ubuntu/). Follow post-install steps to make sure docker runs without `sudo`.
 
 If you need to do a local build of the ONOS driver and SAI
pipeline, you will also need `maven` and a Java JDK.

1. Clone the PINS/sonic-buildimage repository using one of the following:
    * HTTPS:       `git clone https://github.com/sonic-net/sonic-buildimage.git`
    * SSH:         `git clone git@github.com:sonic-net/sonic-buildimage.git`
    * Github CLI:  `gh repo clone sonic-net/sonic-buildimage`
2. Change to the new directory: `cd sonic-buildimage`
3. Ensure that overlay module is loaded on your development system: `sudo modprobe overlay`
4. (Optional) Checkout a specific branch. By default, it uses master branch: `git checkout [branch_name]`
5. Download submodules and checkout the correct commit number: `make init`

### Build Target Binary

Configure your build variables (`$BUILD_VARS`) on the command line or in the
`rules/config` file. Here are some examples:

* Debian Buster is the currently supported version; hence use `NOJESSIE=1
  NOSTRETCH=1`
* The default password for the admin user, `YourPaSsWoRd,` should be overridden
  with a local value.
* Setting the cache method, `SONIC_DPKG_CACHE_METHOD=rwcache`, speeds up the
  build process (after the first time) by caching non-SONiC specific build
  products such as the Linux kernel.
* Set `INCLUDE_P4RT=y` to build the P4RT app and configure the image to run it
    * `INCLUDE_P4RT` is the name in rules/config
    * `SONIC_INCLUDE_P4RT=y` is used on the command line
    * Confirm by looking at the `INCLUDE_P4RT` line in the build config when
      starting any build

Sample values for `$DESIRED_PLATFORM` are `barefoot, broadcom, marvell,
mellanox, cavium, centec, nephos, innovium, vs`.

Run the make commands.

1. Configure the desired platform. \
`$BUILD_VARS make configure PLATFORM=$DESIRED_PLATFORM`
2. (Optional) Determine the target list for the configured PLATFORM. \
`$BUILD_VARS make list`
    * Many individual software targets are listed, as well as the platform
      target with the form: `target/sonic-$PLATFORM.bin` or
      `target/sonic-$PLATFORM.swi`
3. Build the target. \
`$BUILD_VARS make target/sonic-$PLATFORM.bin`

Examples:

```
NOJESSIE=1 NOSTRETCH=1 make configure PLATFORM=barefoot

NOJESSIE=1 NOSTRETCH=1 PASSWORD=passwd make target/sonic-barefoot.bin
```

### Monitoring and Troubleshooting

* Individual logs and artifacts
    * Deb target logs and artifacts will be in `target/deb/buster`
    * Python Deb target logs and artifacts will be in `target/python-debs`
    * Python Wheel target logs and artifacts will be in `target/python-wheels`
    * Docker backup files and logs, and the actual switch target file and log
      file will be in `target`
* The first time you make a target will be very time-consuming. Use the
  `rwcache` option to speed up subsequent makes.
* Due to race conditions, the build may fail. However, if you rerun the make
  command, it may succeed the second time. We have seen this for the `barefoot`
  target.
* If an error occurs during SONiC build, try `make local_build_driver` and `make
  local_build_pipeliner.` \
We tested with JDK 11 / Maven 3.6.3 installed. If you want to use a newer JDK,
you may also need a more recent Maven version (e.g., try JDK 17 / Maven 3.8).
    * Check the version of JDK:

        ```
        java --version
        mvn --version
        ```

    * To change version:

        ```
        sudo update-java-alternatives -s java-1.11.0-openjdk-amd64
        ```

    * To install maven and jdk, if they aren’t installed:

        ```
        sudo apt update
        sudo apt install maven
        sudo apt install openjdk-11-jdk-headless
        ```

    * Build the driver and pipeliner locally:

        ```
        sudo make local_build_driver local_build_pipeliner
        ```
