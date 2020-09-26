# Part of Alaterm, version 2.
# Routines for preliminary configuration, after unpacking archive.

echo "$(caller)" | grep -e alaterm-installer >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
        echo "This file is not stand-alone."
        echo "It must be sourced from alaterm-installer."
        echo exit 1
fi


cd "$alatermTop/etc"
touch pacman.conf
sed -i '/^#Color/s/^#//' pacman.conf 2>/dev/null
chmod 644 pacman.conf
install_template "readme-local.md"
echo "" > "$alatermTop/etc/bash.bash_logout" # Written later.
install_template "bash.bashrc.bash" # Does nothing.
# The temporary /etc/profile is a lengthy set of instructions
#   for pre-configuring Arch. It updates, installs and removes packages,
#   creates a new default user with sudo privileges, etc.:
install_template "prelim-profile.bash" # As temporary /etc/profile.
# Create a temporary command for launching Arch as root:
install_template "prelim-launch.bash" "755"
# Now execute that command, which activates /root.bashrc, except devmode test:
if [ "$devmode" != "test" ] ; then
	bash "$alatermTop/prelim-launch.bash"
else # Fake it in devmode test:
	gotSudo="yes" && echo "gotSudo=yes" >> "$alatermTop/status"
fi
temprl="$(grep gotSudo $alatermTop/status 2>/dev/null)"
if [ "$temprl" = "" ] ; then # Failed prelim-launch.bash.
	echo -e "$PROBLEM Could not install sudo."
	rm -f "$alatermTop/prelim-launch.bash"
	exit 1
fi
[ "$devmode" = "test" ] && rm -f "$alatermTop/prelim-launch.bash"
[ "$devmode" = "test" ] && echo -e "$INFO Preliminary configuration done."
completedPrelim="yes" && echo "completedPrelim=yes" >> "$alatermTop/status"
sleep .2
##
