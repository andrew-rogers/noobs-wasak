#!/bin/sh

. $(git rev-parse --show-toplevel)/functions.sh

check() {
    fn=$1
    bn=$(basename "$fn" .zip)
    root="$NOOBS_ROOTS/$bn"

    if [ ! -d "$root" ] ; then
        mkdir -p "$root"
        unzip "$fn" -d "$root"
        track "$bn" "$root"
    fi
}

track() {
    bn="$1"
    root="$2"
    fldir="$ROOT/file-lists/$bn"
    flmd="$ROOT/tracking/file-list.md"
    tracking="$ROOT/tracking"

    set_var LATEST_RFS "$root/recovery.rfs"

    # Produce new lists for NOOBS version
    mkdir -p "$fldir"
    ( cd "$root" && find ./ -printf '%M\t%s\t%p\n') | sed 's|[.]/||' > "$fldir/boot.ls"
    unsquashfs -ll "$root/recovery.rfs" | sed 's|squashfs-root||' | awk '{print $1 "\t" $2 "\t" $3 "\t" $6}' > "$fldir/root.ls"

    # Update the tracker lists
    echo "Files found in $bn" > "$flmd"
    echo "==============================" >> "$flmd"
    echo "" >> "$flmd"
    echo "Files that go in the boot partition of the SD Card" >> "$flmd"
    echo "--------------------------------------------------" >> "$flmd"
    echo "" >> "$flmd"
    echo '```' >> "$flmd"
    cat "$fldir/boot.ls" >> "$flmd"
    echo '```' >> "$flmd"
    echo "" >> "$flmd"
    echo "Files that go in the root partition of the SD Card" >> "$flmd"
    echo "--------------------------------------------------" >> "$flmd"
    echo "" >> "$flmd"
    echo '```' >> "$flmd"
    cat "$fldir/root.ls" >> "$flmd"
    echo '```' >> "$flmd"

    # Copy the recovery.cmdline and init files
    cp "$root/recovery.cmdline" "$tracking/"
    unsquashfs -f -d "$tracking" "$root/recovery.rfs" init
}

for filename in "$DOWNLOADS"/NOOBS_lite_v*.zip; do
    if [ -f "$filename" ] ; then
        check "$filename"
    fi
done

# Reload the variables
if [ -f "$ROOT/variables.sh" ] ; then
    . "$ROOT/variables.sh"
fi

if [ -z "$LATEST_RFS" ] ; then
    echo "No NOOBS recovery.rfs has been located."
fi
