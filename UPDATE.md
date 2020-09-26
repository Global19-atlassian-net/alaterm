#### Updates to Alaterm

Latest scriptRevision is 220.<br>
September 26, 2020.<br>
Fixes issues caused by changed tigervnc software.<br>
Changes order of directories in PATH.<br>
Various cumulative fixes and upgrades.

1. Launch Alaterm. Command: `echo $scriptRevision`<br>
If the value is below the above latest scriptRevision, then continue.
If not, there is nothing to do.

2. Get a fresh copy of the Alaterm repository ZIP archive, at:</br>
https://github.com/cargocultprog/alaterm<br>
Place it in the Alaterm home directory, and unzip it there.<br>
IMPORTANT: Updates must be run from within launched Alaterm.
So, if you have a git clone in Termux, `git pull` will update the code,
but the git code cannot be used for the update, unless you copy it into
the Alaterm home directory.

3. In the unzipped download, Enter the `v2installer` folder.
Command: `bash update-alaterm`

The script will auto-detect whether you need the update, and apply it.
This is a fast procedure, usually involving refreshed configuration files,
or new utility scripts. Typically takes half a minute, or less.

Remember: Alaterm does not provide programs.
It is an installer for programs provided by Arch Linux ARM.
To update installed Linux software: `pacman -Syu`

