#!/bin/bash

. $(git rev-parse --show-toplevel)/functions.sh

get_boot_options() {

    # Get array of first partitions for each drive
    local arr=($(lsblk -l -o NAME | grep "[a-z]1$"))
    local i=0;

    # Iterate array
    for dev in ${arr[@]}; do

        # Only list FAT32 partitions
        local fs=$(lsblk -n -o FSVER "/dev/$dev")
        if [ "$fs" == "FAT32" ] ; then
            local line=$(lsblk -n -o NAME,FSVER,FSAVAIL,MOUNTPOINT "/dev/$dev")
            i=$(( i + 1 ))
            IFS=''
            OPTIONS+=( $i $line )
        fi
    done
}

get_choice() {
    CHOICE=$(dialog --clear \
                --menu "Select the partition to extract the root files:" \
                15 80 6 \
                ${OPTIONS[@]} \
                2>&1 >/dev/tty)
    clear > /dev/tty             
   
    if [ -n "$CHOICE" ] ; then
        echo "${OPTIONS[$(( CHOICE * 2 - 1 ))]}"
    fi

}

check_boot_dev() {
    if [ -n "$BOOT_DEV" ] ; then
        local dev=$(echo "$BOOT_DEV" | awk '{print $1}')
        local check=$(lsblk -n -o NAME,FSVER,FSAVAIL,MOUNTPOINT "/dev/$dev")
        if [ "$BOOT_DEV" == "$check" ] ; then
            echo "$check"
        fi
    fi
}

get_mnt() {
    if [ -n "$BOOT_DEV" ] ; then
        local dev=$(echo "$BOOT_DEV" | awk '{print $1}')
        lsblk -n -o MOUNTPOINT "/dev/$dev"
    fi
}

check_wpa() {
    WPA="$MNT/wpa_supplicant.conf"
    if [ ! -f "$WPA" ] ; then
        WPA="$WPA.bak"
    fi

    if [ -f "$WPA" ] ; then
        echo "$WPA"
    fi
}

BOOT_DEV=$(check_boot_dev)
if [ -z "$BOOT_DEV" ] ; then

    # Create empty array
    OPTIONS=()

    get_boot_options
    BOOT_DEV=$(get_choice)
    set_var BOOT_DEV "$BOOT_DEV"
fi

MNT="$(get_mnt)"

# Check mount point has at least four characters
if [ "${#MNT}" -ge "4" ] ; then

    # Check for wpa_supplicant.conf
    if [ -z "$(check_wpa)" ] ; then
        echo "The wpa_supplicant.conf file was not found on $MNT. This will be needed for wireless networks."
    fi
    
    # Unzip to mounted device
    ( ZIP="$ROOT/boot.zip" && cd "$MNT" && unzip "$ZIP" )
fi

