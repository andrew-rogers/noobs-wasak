# Shebang not required. Sourced by pkg_build.

mkdir -p "$dir/bin"
cp "$DOWNLOADS/ttyd_linux.armhf" "$dir/bin"

(cd "$dir" && zip "$PKG_DST/ttyd.zip" -r bin/ POSTINST.sh)

