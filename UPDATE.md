#### Updates to Alaterm

Latest scriptRevision is 220.<br>
Fixes issues caused by changed tigervnc software.<br>
Upgrades version 1 to version 2.

1. Launch Alaterm. Command: `echo $scriptRevision` then compare to above.
If an update exists, then continue. If not, there is nothing to do.

2. Get a fresh copy of the Alaterm repository ZIP archive, at:</br>
https://github.com/cargocultprog/alaterm<br>
Place it in the Alaterm home directory, and unzip it there.<br>
IMPORTANT: Updates must be run from within launched Alaterm.
So, if you have a git clone in Termux, `git pull` will update the code,
but the git code cannot be used for the update.

3. In the unzipped download, Enter the `v2installer` folder.
Command: `bash update-alaterm`

The script will auto-detect whether you need the update, and apply it.
This is a fast procedure, usually involving refreshed configuration files,
or new utility scripts. Typically takes half a minute.

Remember: Alaterm does not provide programs.
It is an installer for programs provided by Arch Linux ARM.
To update installed Linux software: `pacman -Syu`

