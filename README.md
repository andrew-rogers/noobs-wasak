# NOOBS Without a Screen and Keyboard (WaSaK)

## NOOBS supports headless OS installation...

Before going further, NOOBS does offer the option of (headless installation of Raspberry Pi operating systems)[https://www.raspberrypi.org/documentation/configuration/wireless/headless.md]. The NOOBS installer can be operated remotely using VNC and provides a desktop like experience.

## ...so why WaSaK?

* Embedded applications might not need to provide a desktop experience.
* Remote terminal access prior to any installation.
* Avoid repartitioning of SD Card until required by you! NOOBS modifies the SD Card partition table even before an OS is selected for installation.
* Because repartitioning is avoided, the SD Card can still be accessed when inserted into an Android device.
* WaSak extension packages are zip files, easily accessible on most devices.
* Allows much more hacking and hands-on learning.
* Does not require installation of a VNC viewer.
* Dedicated embedded applications can be facilitated simply by creating a WaSaK extension package without requiring a desktop OS.

## NOOBS (and WaSaK) is an Operating System!

The NOOBS distributions contain the bootloader, kernel and root filesystem files required for an OS. WaSaK uses these files as part of its initialisation sequence and thus avoids lengthy **buildroot** builds. NOOBS has done it for us! NOOBS has a lot of utilities that a system administrator might use and are also likely to be useful to users of WaSaK.

## What WaSaK does

The main purpose of the original NOOBS initialisation is to start a Qt based recovery and OS installation GUI. WaSaK replaces this initialisation sequence and starts its own extensions. The details can be found in [doc/init.md].
