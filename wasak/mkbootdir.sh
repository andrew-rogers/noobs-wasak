#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

# Copy the latest NOOBS recovery.rfs.
mkdir -p "$ROOT/boot"
rm -f "$ROOT/boot/recovery.rfs"

if [ -f "$LATEST_RFS" ] ; then 
    cp "$LATEST_RFS" "$ROOT/boot/recovery.rfs"
else
    echo "Could not find NOOBS recovery.rfs file."
fi

# Append init_wasak to the recovery.rfs SquashFS.
[ -f "$ROOT/boot/recovery.rfs" ] && mksquashfs "$ROOT/wasak/init_wasak" "$ROOT/boot/recovery.rfs" -all-root

# Copy the WaSaK initialisation script.
cp "$ROOT/wasak/wasak.sh" "$ROOT/boot/"

# Copy the new cmdline
cp "$ROOT/wasak/recovery.cmdline" "$ROOT/boot/"

# Invoke the package builder
$ROOT/wasak/pkg_build.sh
