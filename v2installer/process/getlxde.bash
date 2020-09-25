# Part of Alaterm, version 2.
# Routine for installing the LXDE Desktop.

echo "$(caller)" | grep -e alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi


# Procedure for this part:
[ -z "$devmode" ] && echo -e "$INFO Creating the LXDE graphical desktop..."
install_template "home.vnc-config.conf"
install_template "home.vnc-xstartup.bash" "755"
touch "$alatermTop/home/.Xauthority"
# Instructions for downloading and installing the LXDE Desktop are in here:
install_template "getlxde-profile.bash" # As temporary /etc/profile.
# Create temporary user launch command:
install_template "getlxde-launch.bash" "755"
# Now do it, if not in devmode:
if [ -z "$devmode" ] ; then
	bash "$alatermTop/getlxde-launch.bash"
else
	configuredVnc="yes" && echo "configuredVnc=yes" >> "$alatermTop/status"
fi
tempv="$(grep configuredVnc $alatermTop/status 2>/dev/null)"
if [ "$tempv" = "" ] ; then # Failed temp-userlaunch.bash.
	echo -e "$PROBLEM Failed to configure vncserver."
	rm -f "$alatermTop/getlxde-launch.bash"
	exit 1
else
	[ -z "$devmode" ] && echo -e "$INFO Completed LXDE setup."
fi
[ -z "$devmode" ] && rm -f "$alatermTop/getlxde-launch.bash"
# Install a variety of files:
install_template "home.xinitrc.bash"
install_template "vncserver.bash" "755"
install_template "vncviewer.bash" "755"
install_template "start-vnc.pl" "755"
[ -f "$alatermTop/usr/bin/trash-put" ] && install_template "readme-trash.md"
[ ! -z "$devmode" ] && install_template "readme-trash.md"
install_template "profile.bash" # The real one.
install_template "root.bash_profile.bash"
install_template "root.bashrc.bash"
install_template "home.bash_profile.bash"
install_template "home.bashrc.bash"
install_template "home.Xdefaults.conf" # Nicer xterm than original.
install_template "desktop-items-0.conf" # For pcmanfm.
install_template "panel.conf" # LXDE control panel.
install_template "menu.xml" # Contents of LXDE Menu.
install_template "bookmarks.conf"
install_template "default-resolution.bash" "755"
install_template "lxde-rc.xml"
install_template "nanorc.conf"
[ -z "$devmode" ] && echo -e "$INFO Installed and configured LXDE Desktop."
configuredDesktop="yes"
echo "configuredDesktop=yes" >> "$alatermTop/status"
sleep .2
##
