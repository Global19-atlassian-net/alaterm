# Part of Alaterm, version 2.
# Routine for installing templates.

callerok="no"
echo "$(caller)" | grep -F alaterm-installer >/dev/null 2>&1
[ "$?" -ne 0 ] && callerok="yes"
echo "$(caller)" | grep -F update-alaterm >/dev/null 2>&1
[ "$?" -ne 0 ] && callerok="yes"
if [ "$callerok" = "no" ] ; then
        echo "This file is not stand-alone."
        echo "It must be sourced from alaterm-installer or update-alaterm."
        echo exit 1
fi


# install_template creates an Alaterm file, from a file in templates folder.
install_template() { # Takes 1 or 2 arguments: filename in /templates, chmod.
	t="$here/templates/$1"
	if [ ! -f "$t" ] ; then
		echo -e "$PROBLEM install_template cannot locate file:"
		echo "  templates/$1"
		exit 1
	fi
	if [ "$#" -gt 2 ] ; then
		echo -e "$PROBLEM More than 2 arguments for:"
		echo "  install_template $1"
		exit 1
	fi
	if [ "$#" = "2" ] ; then # Optional chmod.
		ok="no"
		[[ "$2" =~ ^[1-7][0-7][0-7]$ ]] && ok="yes" # 3 digits.
		[[ "$2" =~ ^[0=7][1-7][0-7][0-7]$ ]] && ok="yes" # 4 digits.
		if [ "$ok" != "yes" ] ; then
			echo -e "$PROBLEM Bad chmod code $2 for:"
			echo "  install_template $1."
			exit 1
		fi
	fi
	fs="" # Initialize.
	fs="$(grep "laterm:file=" $t 2>/dev/null)" # Find the instruction.
	# Extract destination filename from filestring:
	fs="$(echo $fs | sed 's/.*laterm:file=//')"
	fs="$(echo $fs | sed 's/ .*//')" # Destination ends at space.
	if [ "$fs" = "" ] ; then
		echo -e "$PROBLEM Cannot find instruction, Alaterm:file="
		echo "  in templates/$1."
		exit 1
	fi
	# Expand filestring variables, if present.
	# These are paths containing / so alternative ! must be used in sed:
	fs="$(echo $fs | sed "s!\$alatermTop!$alatermTop!")"
	fs="$(echo $fs | sed "s!\$PREFIX!$PREFIX!")"
	fs="$(echo $fs | sed "s!\$HOME!$HOME!")"
	fs="$(echo $fs | sed "s!\$launchCommand!$launchCommand!")"
	# If necessary, create the directory path:
	dir="$(echo $fs | sed 's![^/]*$!!')" # Path only.
	mkdir -p "$dir" 2>/dev/null
	if [ "$?" -ne 0 ] ; then
		echo -e "$PROBLEM Cannot create directory:"
		echo "  $dir"
		echo "  required by install_template $1."
		exit 1
	fi
	sleep .05
	cp "$t" "$fs"
	sleep .05
	sed -i '/laterm:file=/d' "$fs" # Remove instruction line.
	# After removing instruction, most templates are installed verbatim.
	# Use PARSE for variables that must be expanded there.
	sed -i "s!PARSE\$launchCommand!$launchCommand!" "$fs"
	sed -i "s!PARSE\$alatermTop!$alatermTop!" "$fs"
	sed -i "s!PARSE\$userLocale!$userLocale!" "$fs"
	sed -i "s!PARSE\$PREFIX!$PREFIX!" "$fs" # Termux.
	sed -i "s!PARSE\$HOME!$HOME!" "$fs" # Termux.
	# chmod if specified:
	if [ "$#" = "2" ] ; then
		chmod "$2" "$fs"
	else
		chmod 644 "$fs"
	fi
	sleep .05
} # End install_template.

# Developer-only routine for testing templates, without real installation:
if [[ "$here" =~ TAexp-min ]] ; then # Specially-named folder.
	alatermTop="$alatermTop-dev"
	launchCommand="$launchCommand-dev"
	mkdir -p "$alatermTop"
	cd "$here/templates"
	templates="$(ls)"
	echo "Reading templates..."
	for template in $templates ; do # No quotes.
		if [[ "$template" =~ bash$ ]] ; then
			install_template "$template" 755
		else
			install_template "$template"
		fi
	done
	cp "$alatermTop/usr/local/scripts/$launchCommand" "$PREFIX/bin/"
	echo "Developer exit."
	exit 0
fi
##
