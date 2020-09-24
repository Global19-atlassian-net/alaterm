#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/vncserver
# File /usr/local/scripts/vncserver, created by Alaterm installer.
# This is an ESSENTIAL part of Alaterm. Do not remove it.

# September 2020 update to /usr/bin/vncserver is incompatible with Alaterm.
# This file is read earlier in PATH, and over-rides /usr/bin/vncserver.

if [ "$(whoami)" = "root" ] ; then
	echo "Alaterm vncserver cannot be used by root."
	echo "Nothing done."
	exit 1
fi

show_usage() {
	echo "Alaterm vncserver is /usr/local/scripts/vncserver."
	echo "Usage:"
	echo "  vncserver :1     [Starts display :1. No other.]"
	echo "  vncserver -kill  [Kills the server.]"
	echo "  vncserver -list  [DISPLAY PID, or exit 1.]"
	echo "Otherwise, shows this usage."
	exit 0
}

if [[ "$1" =~ ^:0 ]] || [[ "$1" =~ ^:[2-9] ]] ; then
	echo "Only display :1 allowed. Nothing done."
	exit 1
fi

goodarg="no"
[ "$1" = ":1" ] && goodarg="yes"
[ "$1" = "-kill" ] && goodarg="yes"
[ "$1" = "-list" ] && goodarg="yes"
[ "$goodarg" = "no" ] && show_usage

if [ "$1" = "-kill" ] ; then # Kills server. Ignores any following argument.
	# Remove these files, whether or not existing vnc server:
	rm -r -f /tmp/.X1*
	rm -r -f /tmp/.*X1*
	rm -f ~/.vnc/*.log
	rm -f ~/.vnc/*.pid
	rm -f ~/.Xauthority && touch ~/.Xauthority
	rm -f ~/.X11authority && touch ~/.X11authority
	rm -f ~/.ICEauthority && touch ~/.ICEauthority
	# Find running VNC server, if any:
	currvnc=$(pidof Xvnc) 2>/dev/null
	kill $currvnc >/dev/null 2>&1 # No quotes.
	if [ "$?" -eq 0 ] ; then
		echo "Killed vncserver. To restart:  vncserver :1"
		exit 0
	else
		echo "Alaterm vncserver was not running."
		exit 1
	fi
fi

if [ "$1" = "-list" ] ; then
	currvnc=$(pidof Xvnc) 2>/dev/null
	if [ "$?" -eq 0 ] ; then
		echo "DISPLAY  PID"
		echo ":1       $currvnc"
		exit 0
	else
		echo "Alaterm vncserver was not running."
		exit 1
	fi
fi

# From here, single argument was :1.

mygeom="1280x800" # Default.
if [ -r "$HOME/.vnc/config" ] ; then
	mygeom="$(grep ^geometry $HOME/.vnc/config 2>/dev/null)"
	if [ "$?" -eq 0 ] ; then
		mygeom="$(echo $mygeom | sed 's/.*= *//' | sed 's/X/x/')"
		mygeom="$(echo $mygeom | sed 's/ *//' | sed 's/#.*//')"
		myxg="$(echo $mygeom | sed 's/x.*//')"
		myyg="$(echo $mygeom | sed 's/.*x//')"
		[[ "$myxg" =~ ^[1-9][0-9][0-9] ]] && myxg="ok"
		[[ "$myyg" =~ ^[1-9][0-9][0-9] ]] && myyg="ok"
		if [ "$myxg" != "ok" ] || [ "$myyg" != "ok" ] ; then
			mygeom="1280x800"
			echo -e "$WARNING Bad geometry in ~/.vnc/config."
			echo -e "Using default 1280x800 instead."
		fi
	fi
fi

currvnc=$(pidof Xvnc) 2>/dev/null
if [ "$?" -eq 0 ] ; then
	echo "Alaterm vncserver already running at :1."
	echo "Nothing done."
	exit 0
else
	# start-vnc.pl requires -fromvncserver. No quotes on $mygeom:
	perl /usr/local/scripts/start-vnc.pl -fromvncserver $mygeom
fi
##
