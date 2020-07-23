Building the WaSaK boot files
=============================

The boot files are created in the **boot.zip** archive by running

```
$ wasak/mkbootdir.sh
```

**wasak/mkbootdir.sh** will run the **wasak/pkg_build.sh** script which will then build the WaSaK extension packages and create zip files for each extension package in the **boot/wasak_packages** directory. The packages will be copied into the NOOBS boot directory prior to the **boot.zip** archive being created.

The WaSaK init script, **init_wasak**, is appended to the original NOOBS **recovery.rfs** and the **recovery.cmdline** file is replaced.

Extracting to SD Card
---------------------

The boot files are to be extracted onto the first partition of the SD Card. In most modern Linux desktop systems the first partition of the SD card will be automatically mounted. The instructions for installing NOOBS onto the SD card can be used to install WaSaK, except that you will extract the WaSaK zip file and not the NOOBS one! WasaK provides a selection menu to make the extraction easier on Linux computers. If you don't want to use the Linux desktop, Mac OS or Windows there are command line methods that can be used, some are discussed below.

### Boot partition selection menu

If the SD card is mounted the **utils/prepareSD.sh** script can be used to extract the boot files. During the first use a menu will appear to allows selection of the relevant device. This menu will not appear on subsequent use unless the device or mount point details change.

### Automatically mounted first partition

Locate the mount point of the first partition of the SD Card by running

```
$ lsblk -l
```
Which will produce something like the below

```
NAME MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda    8:0    0 465.8G  0 disk 
sda1   8:1    0    15G  0 part 
sda2   8:2    0    32G  0 part [SWAP]
sda3   8:3    0  93.2G  0 part 
sda4   8:4    0     1K  0 part 
sda5   8:5    0  83.2G  0 part /
sdd    8:48   1    30G  0 disk 
sdd1   8:49   1    30G  0 part /run/media/andrew/C0BE-D6CB
```

The last entry shows where the first partition of the SD Card is mounted. For the above example, this is **/run/media/andrew/C0BE-D6CB**. If the first partition is mounted then run a command similar to

```
$ MNT=/run/media/andrew/C0BE-D6CB/
$ ( ZIP="$PWD/boot.zip" && cd "$MNT" && unzip "$ZIP" )
```
but replacing the mount point with the mount point discovered above.

### Manual mounting of first partition

If the first partition does not get automatically mounted, then this will need to be done manually. It is important to ensure the correct device is used for the SD Card. On some configurations, the first partition will fail to automatically mount once NOOBS has modified the partition table, manual mount still works.

Example manual mount and zip extraction

```
# mkdir /mnt/sd
# mount -t vfat /dev/sdd1 /mnt/sd
# ( ZIP="$PWD/boot.zip" && cd /mnt/sd && unzip "$ZIP" )
# sync
# umount /mnt/sd
```

