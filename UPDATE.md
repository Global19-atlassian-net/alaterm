#### Updates to Alaterm

Latest scriptRevision is 220.<br>
Fixes issues caused by changed tigervnc software.<br>
Upgrades version 1 to version 2.

Launch Alaterm. Command: `echo $scriptRevision` then compare to above.
If an update exists, then:

1. Download and unzip a fresh copy of the Alaterm repository,
into your Alaterm home directory. IMPORTANT: Updates must be run
from within launched Alaterm.

2. Enter the `v2installer` folder. Command: `bash update-alaterm`

The script will auto-detect whether you need the update, and apply it.
This is a fast procedure, usually involving
no more than tweaks to existing configuration files, or new
utility scripts.

Remember: Alaterm does not provide programs.
It is an installer for programs provided by Arch Linux ARM.
To update installed Linux software: `pacman -Syu`

