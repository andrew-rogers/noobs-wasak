How NOOBS-WaSaK initialises
===========================

init file
---------

An alternative **init** file is used to start WaSaK. The new init file is called **init_wasak** and can also start the NOOBS recovery program. With an additional cmdline option, **wasak**, the NOOBS-WaSaK system is initialised instead of the NOOBS system. **init_wasak** is a slightly modified version of the original NOOBS **init**. By minimising theses changes new versions of NOOBS can be more easily be utilised.

The purpose of the changes are to load WaSak from a script, **wasak.sh**, stored on the boot partition of the SD Card.

Changes to recovery.cmdline
---------------------------

Additional cmdline options is used to indicate that the WaSaK initialisation is required. The cmdline should contain **init=/init_wasak** and **wasak** options, e.g.

```
runinstaller quiet ramdisk_size=32768 root=/dev/ram0 init=/init_wasak vt.cur_default=1 elevator=deadline sdhci.debug_quirks2=4 wasak
```

Starting the network
--------------------

As WaSaK support headless install, the network is used to control the system and must be brought up automatically. WaSaK uses the DHCP client daemon, **dhcpcd**, from the NOOBS system to start the networking. Wireless networks are configured using the **wpa_supplicant.conf** file stored on the boot partition of the SD Card. NOOBS renames this file to **wpa_supplicant.conf.bak** so that is used if **wpa_supplicant.conf** is not found.

WaSak Extensions
----------------

WaSaK extensions are loaded by the **wasak.sh** file stored on the boot partition of the SD Card. This file is dot-sourced from the **init_wasak** file and therefore does not require its execute permission flag to be set. This allows the file to be stored on the FAT32 boot partition where it can be easily accessed for future updates and user modification.

The WaSaK extensions are stored as zip files in the **wasak_packages** directory on the boot partition of the SD Card. Each zip file can contain a **POSTINST.sh** that finalises the installation and may start services included in the extension. The zip files are expanded to the **/opt** directory and the **POSTINST.sh** is sourced by **wasak.sh**.
