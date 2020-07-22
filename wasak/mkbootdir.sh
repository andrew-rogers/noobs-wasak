#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

# Set the boot directory to the directory holding the latest NOOBS recovery.rfs
BOOT=$(dirname "$LATEST_RFS")

BOOT_ZIP="$ROOT/boot.zip"

patch_recovery_rfs() {
    RFS="$1"

    # Append init_wasak to the recovery.rfs SquashFS.
    [ -f "$RFS" ] && mksquashfs "$ROOT/wasak/init_wasak" "$RFS" -all-root
}

copy_wasak_files() {

    # Copy the WaSaK initialisation script.
    cp "$ROOT/wasak/wasak.sh" "$BOOT/"

    # Copy the new cmdline
    cp "$ROOT/wasak/recovery.cmdline" "$BOOT/"
}

copy_packages() {
    cp -r "$ROOT/boot/wasak_packages" "$BOOT/"
}

create_zip() {
    local src=$(dirname "$LATEST_RFS")
    [ -f "$BOOT_ZIP" ] && rm -f "$BOOT_ZIP"
    (cd "$src" && zip "$BOOT_ZIP" -r *)
}

# Invoke the package builder
$ROOT/wasak/pkg_build.sh

if [ -f "$LATEST_RFS" ] ; then
    patch_recovery_rfs "$LATEST_RFS"
    copy_wasak_files
    copy_packages
    create_zip
else
    echo "Could not find NOOBS recovery.rfs file."
fi

