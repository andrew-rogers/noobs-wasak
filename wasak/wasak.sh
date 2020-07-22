# Shebang line not needed. This file is sourced by init_wasak when the 'wasak' option is added to the recovery.cmdline
# Because this file is sourced, it does not need execute permission and thus can reside on a FAT filesystem.

PKG_DIR=/mnt/wasak_packages
WPA_CONF=/mnt/wpa_supplicant.conf

start_networks() {
  if [ ! -f "$WPA_CONF" ] ; then
    echo "Unable to find $WPA_CONF, trying $WPA_CONF.bak"
    WPA_CONF="$WPA_CONF.bak"
  fi
  if [ -f "$WPA_CONF" ] ; then
    echo "Starting WiFi with $WPA_CONF"
    /sbin/dhcpcd --noarp -e "wpa_supplicant_conf=$WPA_CONF" --denyinterfaces *_ap
  else
    echo "Unable to find $WPA_CONF. Can't start WiFi."
  fi
}

install_packages() {
    for pkg in "$PKG_DIR"/*.zip; do
        unzip "$pkg"
        . POSTINST.sh
    done
}

# Start DBus - used by wpa_supplicant and wpa_cli
/etc/init.d/S30dbus start > /dev/null

# Pseudoterminals (telnetd, sshd, etc.) require /dev/pts
mkdir /dev/pts
/bin/mount -t devpts none /dev/pts

start_networks

# Create a temporary filesystem to expand the extensions
mount -t tmpfs tmpfs /opt
cd /opt

install_packages

echo "Welcome to WaSaK test shell."
sh

