#!/bin/bash
# Alaterm:file=$alatermTop/usr/local/scripts/ps
# File /usr/local/scripts/ps, created by Alaterm installer.
# This is an ESSENTIAL file in Alaterm. Do not remove it.

# /usr/bin/ps and /system/bin/ps do not work in Alaterm.
# This substitute provides the information.
# It appears earlier in PATH.

cd /proc # Yes, it is mounted. But not all of it is readable.

procnums=""
fours=""
fives=""

proclist=$(ls 2>/dev/null)

for p in $proclist ; do
	if [ -d "$p" ] && [ -r "$p" ] ; then
		if [[ "$p" =~ ^[1-9] ]] ; then
			procnums+="$p "
		fi
	fi
done

for n in $procnums ; do # No quotes.
	if [ -e "$n/exe" ] ; then # The exe is a link to executable.
		s=$(ls -l "$n/exe" | sed 's/.*-> *//') # Executable filenhame.
		if [[ "$s" =~ com.termux/files ]] ; then
			t="$s" # Leave as-is, with Termux file path.
		else
			t="$(echo $s | sed 's/.*\///g')" # Strip file path.
		fi

		if [[ "$n" =~ ^[1-9][0-9][0-9][0-9]$ ]] ; then
			fours+="\n $n pts/0      00:00:00 $t"
		else
			fives+="\n$n pts/0      00:00:00 $t"
		fi
	fi
done

printf "  PID TTY            TIME CMD"
printf "$fours"
printf "$fives\n"
# The final item will be bash, referring to this script itself.
##
