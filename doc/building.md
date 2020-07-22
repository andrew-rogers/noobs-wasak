Building the WaSaK boot files
=============================

The boot files are created in the **boot** directory by running

```
$ wasak/mkbootdir.sh
```

**wasak/mkbootdir.sh** will run the **wasak/pkg_build.sh** script which will then build the WaSaK extension packages and create zip files for each extension package in the **boot/wasak_packages** directory.

Copying to SD Card
------------------

The boot files are to be copied onto the first partition of the SD Card alongside the existing NOOBS boot files. Note that the **recovery.rfs** and **recovery.cmdline** files are replaced.

Locate the mount point of the first partition of the SD Card by running

```
$ mount
```
Which will produce something like the below

```
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sys on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
dev on /dev type devtmpfs (rw,nosuid,relatime,size=1972872k,nr_inodes=493218,mode=755)
run on /run type tmpfs (rw,nosuid,nodev,relatime,mode=755)
/dev/sda5 on / type ext4 (rw,relatime)
fusectl on /sys/fs/fuse/connections type fusectl (rw,nosuid,nodev,noexec,relatime)
gvfsd-fuse on /run/user/1000/gvfs type fuse.gvfsd-fuse (rw,nosuid,nodev,relatime,user_id=1000,group_id=1000)
/dev/sdd1 on /run/media/andrew/C0BE-D6CB type vfat (rw,nosuid,nodev,relatime,uid=1000,gid=1000,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,showexec,utf8,flush,errors=remount-ro,uhelper=udisks2)
```

The last entry shows where the first partition of the SD Card is mounted. For the above example, this is **/run/media/andrew/C0BE-D6CB**. If the first partition is mounted then run a command similar to

```
$ cp -r boot/* /run/media/andrew/C0BE-D6CB/
```
but replacing the mount point with the mount point discovered above.

### Manual mounting of first partition ###

If the first partition does not get automatically mounted, then this will need to be done manually. It is important to ensure the correct device is used for the SD Card. On some configurations, the first partition will fail to automatically mount once NOOBS has modified the partition table, manual mount still works.

Example manual mount and copy

```
# mkdir /mnt/sd
# mount -t vfat /dev/sdd1 /mnt/sd
# cp -r boot/* /mnt/sd
# sync
# umount /mnt/sd
```



