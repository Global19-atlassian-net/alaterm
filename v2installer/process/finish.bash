# Part of Alaterm, version 2.
# Routine for creating the launch command, then finish.

echo "$(caller)" | grep -e alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo "This file is not stand-alone."
	echo "It must be sourced from alaterm-installer."
	echo exit 1
fi

# This function creates or edits Termux $HOME/.bashrc.
# Previous references to Alaterm are removed, to avoid duplication.
modify_termuxBashrc() {
	tbrc="$HOME/.bashrc" # Termux home, not Alaterm home.
	touch "$tbrc" # If not already there, create it.
	grep "launch.*laterm" "$tbrc" >/dev/null 2>&1
	if [ "$?" -ne 0 ] ; then
		echo "To launch Alaterm, command:  alaterm" >> "$tbrc"
	fi
} # End modify_termuxBashrc.


# Sequence of actions.
# Install help:
cp -r -f "$here/help-alaterm" "$alatermTop/usr/local/"
mkdir -p "$alatermTop/system"
mkdir -p "$alatermTop/vendor"
mkdir -p "$alatermTop/odm"
# Intercept Alaterm calls to inappropriate Termux executables:
install_template "pkg.bash" "755"
create_fakeExecutables # Defined in globals.bash.
# Let user know when Alaterm logs out, and returns to Termux:
install_template "bash.bash_logout.bash"
# Install launchCommand, and copy to Termux, whether or not devmode:
install_template "launchcommand.bash" "755"
cp "$alatermTop/usr/local/scripts/$launchCommand" "$PREFIX/bin/"
# Let Termux know that Alaterm is installed:
[ -z "$devmode" ] && modify_termuxBashrc

# Extras:
install_template "TeXworks.conf"
mkdir -p "$alatermTop/home/.config/dbus" # Needed for some applications.
install_template "dbus-programs.bash" "755"
install_template "dbus-programs.hook"
mkdir -p "$alatermTop/home/.local/share/applications" # Custom *.desktop.
install_template "mimeapps-list.bash" "755"
install_template "mimeapps-list.hook"
install_template "autoremove.bash" "755"
install_template "ban-menu-items.bash" "755"
install_template "ban-menu-items.hook"
install_template "compile-libde265.bash" "755"
install_template "compile-libmad.bash" "755"
install_template "compile-libmpeg2.bash" "755"

# Finalize:
echo "createdLaunch=yes" >> "$alatermTop/status"
echo "let scriptRevision=$thisRevision" >> "$alatermTop/status"
echo "completedInstall=yes" >> "$alatermTop/status"
echo "## Installation complete." >> "$alatermTop/status"
echo "## Anything after this is an update." >> "$alatermTop/status"
# Make backup copy of original status file:
cp "$alatermTop/status" "$alatermTop/status.orig"
[ -z "$devmode" ] && chmod 400 "$alatermTop/status.orig"
##
