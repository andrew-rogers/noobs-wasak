#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

if [ -d "$1" ] ; then
    BOOT=$(cd "$1" && pwd)
else
    BOOT="$ROOT/boot"
fi

patch_recovery_rfs() {
    RFS="$1"

    # Append init_wasak to the recovery.rfs SquashFS.
    [ -f "$RFS" ] && mksquashfs "$ROOT/wasak/init_wasak" "$RFS" -all-root
}

mkdir -p "$BOOT"

# Copy the latest NOOBS recovery files.
if [ -f "$LATEST_RFS" ] ; then
    patch_recovery_rfs "$LATEST_RFS"
    cp -r $(dirname "$LATEST_RFS")/* "$BOOT/"
else
    echo "Could not find NOOBS recovery.rfs file."
fi

# Copy the WaSaK initialisation script.
cp "$ROOT/wasak/wasak.sh" "$BOOT/"

# Copy the new cmdline
cp "$ROOT/wasak/recovery.cmdline" "$BOOT/"

# Invoke the package builder
$ROOT/wasak/pkg_build.sh "$BOOT"

# Copy the wpa_supplicant.conf
cp "$DOWNLOADS/wpa_supplicant.conf" "$BOOT/"
