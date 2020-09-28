#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/$launchCommand
# File /usr/local/scripts/PARSE$launchCommand
# Also copied to Termux $PREFIX/bin/.

# This is the Alaterm launch command.
# It cannot be run by an already-launched Alaterm.

mypidof="$(pidof proot 2>/dev/null)"
if [ "$mypidof" != "" ] ; then
	echo "You cannot launch Alaterm while"
	echo "Alaterm is already running,"
	echo "or if another program uses proot."
	exit 1
fi

export alatermTop="PARSE$alatermTop"

# Load the variables defined in Alaterm status file:
if [ -r "$alatermTop/status" ] ; then
	source "$alatermTop/status"
else
	if [ -f "$alatermTop/alastat.orig" ] ; then
		cp "$alatermTop/alastat.orig" "$alatermTop/status"
		chmod 644 "$alatermTop/status"
		source "$alatermTop/status"
		echo -e "$WARNING Did not find Alaterm status file."
		echo "Found alastat.orig. Copied it. Using it."
	else
		echo -e "\e[1;91mPROBLEM.\e[0m Missing Alaterm status file."
		echo "Cannot launch Alaterm without it."
		exit 1
	fi
fi

# Check for necessary Termux support:
hash proot >/dev/null 2>&1
if [ "$?" -ne 0 ] ; then
	echo -e "$PROBLEM Termux does not have proot installed."
	echo "Cannot launch Alaterm now."
	echo "Termux command:  pkg install proot"
	exit 1
fi

# It is possible to install vncservers both in Termux and in Alaterm.
# They conflict if both are in use at the same time.
# Check for active Termux vncserver, kill it, and removes its temp files:
mytvnc=$(pidof Xvnc) # If Xvnc is running, pidof returns its process ID.
if [ "$?" -eq 0 ] ; then
	kill $mytvnc # No quotes.
	rm -r -f /tmp/.X1*
	rm -f /tmp/.X1*
	rm -f ~/.vnc/*.log
	rm -f ~/.vnc/*.pid
fi

# The proot string defines Alaterm paths within its confinement.
# Actually, Alaterm can access most outside files,
# and can even run a few Termux executables.
prsUser="--kill-on-exit --link2symlink -v -1 -0 -r $alatermTop"
prsUser+=" -b /proc -b /system -b /dev -b /data "
# /dev/ashmem or /dev/shm may be called by some programs,
# but they may not exist or be accessible in Alaterm. Bind /tmp instead:
[ ! -r /dev/ashmem ] && prsUser+=" -b $alatermTop/tmp:/dev/ashmem"
[ ! -r /dev/shm ] && prsUser+=" -b $alatermTop/tmp:/dev/shm"
[ -d /sys ] && prsUser+=" -b /sys"
[ -d /vendor ] && prsUser+=" -b /vendor"
[ -d /odm ] && prsuser+=" -b /odm"
[ -d /product ] && prsuser+=" -b /product"
# Many parts of Android /proc are inacessible in Alaterm.
# Bind fake information instead, which fools many programs:
if [ ! -r /proc/stat ] ; then
	prsUser+=" -b $alatermTop/var/binds/dummyPS:/proc/stat"
fi
if [ ! -r /proc/version ] ;then
	prsUser+=" -b $alatermTop/var/binds/dummyPV:/proc/version"
fi
[ -d /sdcard ] && prsUser+=" -b /sdcard" # Built-in.
[ -d /storage ] && prsUser+=" -b /storage" # Removable.
prsUser+=" -b /proc/self/fd/0:/dev/stdin"
prsUser+=" -b /proc/self/fd/1:/dev/stdout"
prsUser+=" -b /proc/self/fd/2:/dev/stderr"
# Starts Alaterm in its /home directory:
prsUser+=" -w /home"
# Keeops pre-defined environment, with these corrections if necessary:
prsUser+=" /usr/bin/env - TERM=$TERM HOME=/home"
# Switches into the default non-root user:
prsUser+=" /bin/su -l user"
# The Termux LD_PRELOAD interferes with proot:
unset LD_PRELOAD
# Now to launch Alaterm:
proot $prsUser # No quotes.
# The above continues to run, until logout of Alaterm.
##
