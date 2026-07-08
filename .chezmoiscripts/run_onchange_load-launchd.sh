#!/bin/sh

PLIST="$HOME/Library/LaunchAgents/com.neo.dotfiles.plist"
UID_NUM=$(id -u)

launchctl bootout "gui/$UID_NUM/com.neo.dotfiles" 2>/dev/null
launchctl bootstrap "gui/$UID_NUM" "$PLIST"
