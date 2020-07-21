Tracking changes to NOOBS binaries
==================================

As fas as possible, NOOBS binaries are used as is. However, as NOOBS is updated, new feature may come along that could be made use of. Also changes may impact the way WaSaK operates. For these reasons, some changes to the NOOBS filesystems are tracked.

recovery.cmdline
----------------

This can contain options to control the NOOBS recovery program. **vncinstall** and **forcetrigger** are used so that the VNC server is started and the OS selection menu is triggered. The first process the kernel starts can be specified here with the **init=/init** option.

recovery.rfs
------------

The recovery.rfs file is a SquashFS file that does not need to be fully extracted to append new files. Existing files in the SquashFS can't be changed using the standard mksquashfs tool. However, files can be added. To change or delete files, the SquashFS has to be extracted and re-squashed.

Tracking relevant NOOBS updates
-------------------------------

The **recovery.cmdline** and **init** files are copied from NOOBS and kept in this repository so that changes to these can be tracked. By keeping track of these files, new features added to the kernel or bug fixes in the initialisation will likely be detected. Any detected changes can be considered for inclusion in this project. File lists of the boot files and the files in **recovery.rfs** are also kept for tracking new utilities that may be added to newer NOOBS versions.
