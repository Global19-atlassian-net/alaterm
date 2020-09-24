#!/usr/bin/env perl
# Alaterm:file=$alatermTop/usr/local/scripts/start-vnc.pl
# File /usr/local/scripts/start-vnc.pl, created by Alaterm installer.
# This is an ESSENTIAL Alaterm file. Do not remove it.
# Based on older version of /usr/bin/vncserver.
# See above file for Copyright, License, and credits.

# Do not invoke this file directly.
# It is invoked by vncserver, in /usr/local/scripts not /usr/bin.

# This file will only start Xvnc at display :1, 127.0.0.1:5901.

if ($#ARGV < 1) { # Perl counts from 0. So, two arguments.
	warn "start-vnc.pl cannot be invoked directly.\nNothing done.\n";
	exit 1;
}
if ($ARGV[0] ne "-fromvncserver") {
	warn "start-vnc.pl cannot be invoked directly.\nNothing done.\n";
	exit 1;
}

print "\e[1;92mJust a moment...\e[0m\n";

# Set some default options:
$optstring = ":1 -pn -auth /home/.Xauthority -rfbwait 20000 ";
$optstring .= "-rfbauth /home/.vnc/passwd -rfbport 5901 ";
$optstring .= "-geometry $ARGV[1]"; 
# Create cookie and related files:
unlink("/home/.vnc/localhost:1.log");
$cookie = `mcookie`;
open(XAUTH, "|xauth -f /home/.Xauthority source -");
print XAUTH "add localhost:1 . $cookie\n";
print XAUTH "add localhost/unix:1 . $cookie\n";
close(XAUTH);
# Xvnc command:
$cmd = "/usr/bin/Xvnc $optstring";
# Log the command:
$cmd .= " >> " . '/home/.vnc/localhost:1.log' . " 2>&1";
# Run command and record the process ID.
$pidFile = "/home/.vnc/localhost:1.pid";
system("$cmd & echo \$! >$pidFile");
# Give Xvnc a chance to start:
sleep(3);
# Verify that it started:
unless (kill 0, `cat $pidFile`) {
    warn "Could not start Xvnc.\n\n";
    unlink $pidFile;
    open(LOG, "</home/.vnc/localhost:1.log");
    while (<LOG>) { print; }
    close(LOG);
    die "\n";
}
# Greeting message:
print "\e[92mNew localhost:1 at 127.0.0.1:5901.\e[0m\n";
$ENV{DISPLAY}= ":1";
$ENV{VNCDESKTOP}= "localhost:1";
system("/home/.vnc/xstartup >> " . '/home/.vnc/localhost:1.log' . " 2>&1 &");
exit;
##
