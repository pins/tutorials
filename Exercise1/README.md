## Exercise 1 - Deploy SONiC/PINS Target Image to Switches

This exercise will take you through the deployment of the SONiC/PINS target image on your switches. If you have questions about SONiC deployment, see the [SONiC documentation](https://github.com/Azure/SONiC/wiki/).


### Get the SONiC/PINS Target Image(s) for Your Switches

SONiC/PINS images for select targets are currently available on Github. There is one SONiC/PINS image per ASIC, so be sure to select the correct image for your switch. Most images end in `.bin`, except Arista switches, which end in `.swi`.

You can either access the image directly on Github or copy the image to your local server or switch. This tutorial illustrates some of your choices, but getting the image is up to you. Your hardware vendor may have switch-specific instructions to acquire and load software.

To copy the link from Github, go to [PINS releases](https://github.com/pins/sonic-buildimage-public/releases/tag/202106-10-27), select your target image, and copy the URL.

Example URL for a Broadcom-based target image from Github:

```
https://github.com/pins/sonic-buildimage-public/releases/download/202106-10-27/sonic-broadcom.bin
```

*Note: The default username/password for PINS images on Github is:* `admin/admin`

If you are a systems integrator and you are creating a custom image for your switch, you will need to follow the instructions in [Build SONiC/PINS Target Image](../BuildTargetImage.md). For help, please use the SONiC/PINS support channels.


### Installers

Three installers are available to deploy the SONiC/PINS target image.



1. The SONiC installer upgrades a switch with SONiC installed to SONiC/PINS. (brownfield) \
Reference: [SONiC installer](https://github.com/Azure/SONiC/blob/master/doc/SONiC-User-Manual.md#3231-sonic-installer)
2. The ONIE installer bootstraps a switch without SONiC. If your switch does not have ONIE, you will need to install it first. (greenfield)  \
Reference: [SONiC ONIE installation instructions](https://github.com/Azure/SONiC/blob/master/doc/SONiC-User-Manual.md#1121-install-sonic-onie-image)
3. The Aboot installer bootstraps Arista switches without SONiC. (greenfield)  \
Reference: [SONiC EOS installation instructions](https://github.com/Azure/SONiC/blob/master/doc/SONiC-User-Manual.md#1122-install-sonic-eos-image)


#### SONiC Installer 

Login via `ssh` to a switch that is running SONiC and use the `sonic-installer` application as root (or using `sudo`) to manage and upgrade target images. The new SONiC/PINS target image must be loaded on the switch or available on the network.


<table>
  <tr>
   <td colspan="2" ><code>sonic-installer</code>
   </td>
  </tr>
  <tr>
   <td>cleanup
   </td>
   <td>Remove installed images except <em>current</em> and <em>next.</em>
   </td>
  </tr>
  <tr>
   <td>install
   </td>
   <td>Install image from local binary or URL.
   </td>
  </tr>
  <tr>
   <td>list
   </td>
   <td>List installed images.
   </td>
  </tr>
  <tr>
   <td>remove
   </td>
   <td>Uninstall an image.
   </td>
  </tr>
  <tr>
   <td>rollback-docker
   </td>
   <td>Rollback docker image to the previous version.
   </td>
  </tr>
  <tr>
   <td>set-default
   </td>
   <td>Choose the default image to boot from.
   </td>
  </tr>
  <tr>
   <td>set-next-boot
   </td>
   <td>Choose an image for the next reboot (one-time action).
   </td>
  </tr>
  <tr>
   <td>upgrade-docker
   </td>
   <td>Upgrade docker image from local binary or URL.
   </td>
  </tr>
  <tr>
   <td>verify-next-image
   </td>
   <td>Verify the next image for a reboot.
   </td>
  </tr>
</table>




1. Install the SONiC/PINS target image directly from GitHub, or via HTTP on another server, or using a local image:

    ```
    Switch$ sudo sonic-installer install <copied GitHub URL>
    ```
    or

    ```
    Switch$ sudo sonic-installer install http://$IMAGE_SERVER/$IMAGE_DIR/$IMAGE
    ```
    or

    ```
    Switch$ sudo sonic-installer install /home/admin/$IMAGE
    ```

2. Reboot the switch for the “**Next**” image to run.
    ```
    Switch$ sudo reboot now
    ```

Example: 


```
Switch$ sudo sonic-installer install https://github.com/pins/sonic-buildimage-public/releases/download/202106-10-27/sonic-broadcom.bin
New image will be installed, continue? [y/N]: y
Downloading image...
...99%, 1030 MB, 10348 KB/s, 0 seconds left...

Installing image SONiC-OS-pins_202106-10.27.21.0-59cbf5b58 and setting it as default...
…
Done

Switch$ sudo sonic-installer list
Current: SONiC-OS-pins_202106-10.27.21.0-59cbf5b58
Next: SONiC-OS-pins_202106-10.27.21.0-59cbf5b58
Available:
SONiC-OS-pins_202106-10.27.21.0-59cbf5b58
SONiC-OS-master.0-dirty-20220107.112242

Switch$ sudo reboot now
```



#### ONIE Installer

The ONIE installer does not necessarily have SSL installed to get a target image directly from GitHub. One alternative is to download the target image onto your server (e.g., `wget`) and run a web server (e.g., python’s `SimpleHTTPSever`) to give local access to the image (e.g., `http://${YOUR_IP}:8000/sonic-broadcom.bin`).



1. Make the target image accessible to ONIE on your switch.

    Example:


    ```
    Server$ wget https://github.com/pins/sonic-buildimage-public/releases/download/202106-10-27/sonic-broadcom.bin
    Server$ python -m SimpleHTTPServer
    ```


2. Instead of logging in to the switch via `ssh`, you will need to connect a console cable (e.g., USB, DB-9) from the switch to an adjacent computer. Then, open the console software (e.g., `screen` or `minicom`) and connect to the switch over the serial port. Note that the baud rate is switch-specific for the serial port you are using.

    Examples:


    ```
    Server$ sudo screen /dev/ttyUSB0 115200
    Server$ sudo screen /dev/ttyUSB1 115200
    ```



    If the `screen` program acts unexpectedly, use `Ctrl-a d` to exit `screen` and then reset the console connection. (unplug the cable)

3. Log in to the switch (default username/password is "admin/YourPaSsWoRd" for SONiC images and "admin/admin" for PINS images) and reboot.
    ```
    Switch$ sudo reboot now
    ```
4. Use the arrow key from the Grub menu to select `ONIE`, then select `ONIE Installer`.
5. When you see the message, “_ONIE Starting ONIE Service Discovery_,” enter the following command.
    ```
    ONIE# onie-discovery-stop
    ```
6. Install the target image.

    Example installation from ONF’s server (10.128.13.243) in step 1:


    ```
    ONIE# onie-nos-install http://10.128.13.243:8000/sonic-broadcom.bin
    ```


7. After the software is loaded, it will reboot and present you with a SONiC login prompt.


#### Aboot Installer

The Aboot installer does not necessarily have SSL installed to get a target image directly from GitHub. One alternative is to download the target image onto your server (e.g., `wget`) and run a web server (e.g., python’s `SimpleHTTPSever`) to give local access to the image (e.g., `http://${YOUR_IP}:8000/sonic-aboot.broadcom.swi).`



1. Make the target image accessible to Aboot on your switch.

    Example:


    ```
    Server$ wget https://github.com/pins/sonic-buildimage-public/releases/download/202106-10-27/sonic-aboot.broadcom.swi
    Server$ python -m SimpleHTTPServer
    ```


2. Instead of logging in to the switch via `ssh`, you will need to connect a console cable (e.g., USB, DB-9) from the switch to an adjacent computer. Then, open the console software (e.g., `screen` or `minicom`) and connect to the switch over the serial port. Note that the baud rate is switch-specific for the serial port you are using.

    Example:


    ```
    Server$ sudo screen /dev/ttyUSB3
    ```



    If the `screen` program acts unexpectedly, use `Ctrl-a d` to exit `screen` and then reset the console connection. (unplug the cable)

3. Log in to the switch (default username/password is "admin/YourPaSsWoRd" for SONiC images and "admin/admin" for PINS images) and reboot. 
    ```
    Switch$ sudo reboot now
    ```


    NOTE: You can stop syslog messages with `sudo dmesg -D`

4. When prompted, hold down `Ctrl-c` to get to the Aboot menu.
5. Get an IP address for the switch by running a DHCP client, if necessary.

    ```
    Aboot# udhcpc
    ```


6. Follow switch-specific instructions from your hardware vendor to acquire and load software in the expected location. In this case, the image is expected to be in the `/mnt/flash` directory.  \
Example:

    ```
    Aboot# cd /mnt/flash
    Aboot# wget http://10.128.13.243:8000/sonic-aboot.broadcom.swi
    ```


7. Boot the new image.

    ```
    Aboot# boot sonic-aboot.broadcom.swi
    ```


8. Once the software is loaded, it will reboot and present you with a SONiC login prompt.


### Validate SONiC/PINS Installation

Log in to the switch and verify that the installation is correct. (NOTE: It may take 3 to 5 minutes for all containers to be up.) The examples below are from the configuration at ONF.



1. Verify that the installed version is the expected version of SONiC with PINS.

    ```
    Switch$ show version
    SONiC Software Version: SONiC.pins_202106-10.27.21.0-59cbf5b58
    ```


2. Verify that P4Runtime (P4RT) is running by checking that the container is up.

    ```
    Switch$ docker ps
    1ef0e269306a  docker-sonic-p4rt:latest "/usr/local/bin/supe…" 6 days ago  Up 6 days p4rt
    ```


3. Verify that P4Runtime (P4RT) is running by checking that the container is up and bound to port 9559:

    ```
    Switch$ sudo netstat -lpnt | grep p4rt
    tcp6       0      0 :::9559                :::*    LISTEN      2346/p4rt
    ```

### Troubleshooting

If p4rt is not running correctly and you need to restart it, use the following command.


```
Switch$ sudo service p4rt restart
```


Use` show logging -f `to tail the log file and watch for errors. You may want to filter for p4rt:


```
Switch$ show logging -f | grep p4rt
```


If you see the following message, SONiC/PINS has gone into a critical state and will not accept any writes until the device is rebooted:


```
Sep 17 20:35:13.681725 pins-as7712-3 NOTICE p4rt#p4rt: :- CallLuaScript: Component p4rt:p4rt successfully updated state from UP to ERROR.
```


You can look at previous messages to determine why this occurred. One possibility is that ONOS is running in your network and pushing a different version of p4info to the switch. **_The P4 pipeline can only be pushed once before you configure the routes._** If ONOS is running on a server connected to the switch, kill the docker container for ONOS. Regardless of the cause of a critical state, we recommend that you reboot your switches.

The `pmon` and `snmp` processes will log numerous errors unless configured with NMS. To eliminate those errors, use the following command.


```
Switch$ show logging -f | grep -v pmon | grep -v snmp
```


Check `/etc/sonic/config_db.json` for interface configuration. A mismatched FEC prevents the interface from going to an UP/UP state. If you modify this file, use the `sudo config reload -y` command to restart the docker containers and incorporate the changes.

The [Troubleshooting section](https://github.com/Azure/SONiC/blob/master/doc/SONiC-User-Manual.md#6-troubleshooting) of the SONiC User Manual is helpful if you run into problems. 


### Note About Custom Configuration

The primary SONiC configuration file, `/etc/sonic/config_db.json`, is specific to a switch/ASIC combination. If you get the SONiC/PINS image described above, you will have the default file for the target. Instead, you may get the configuration file from your switch vendor, or you may customize it yourself. As you follow this tutorial, you may notice extraneous hosts, devices, or links as SONiC tries to implement the configuration in `config_db.json`. 

This tutorial assumes you understand your network requirements, and you can choose to ignore any configuration that is not relevant to the exercises in this tutorial. Alternatively, you could remove any configuration not part of this tutorial. One example is BGP configuration commands, which are not part of these SDN exercises. You could edit the file to remove anything you don’t want to see, or you could use a simple script such as the following example to remove BGP from the configuration file on your switch.


```
cat /etc/sonic/config_db.json | jq 'del(.BGP_NEIGHBOR)|del(.INTERFACE)' | sudo tee /etc/sonic/config_db.json >/dev/null
```


The compiled P4 program, `onf.p4info.pb.txt`, contains ACLs. If your switch does not support ACLs, you will need to modify the P4 program and recompile it for your switch.

