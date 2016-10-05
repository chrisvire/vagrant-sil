#!/usr/bin/env bash

dconf write /com/canonical/unity/launcher/favorites "['application://org.gnome.Nautilus.desktop', 'application://firefox.desktop', 'application://unity-control-center.desktop', 'unity://running-apps', 'application://gnome-terminal.desktop', 'unity://expo-icon', 'unity://devices']"
dconf write /com/canonical/unity/integrated-menus true
dconf write /org/gnome/desktop/session/idle-delay 'uint32 0'
dconf write /org/gnome/desktop/screensaver/lock-enabled false

dconf write /com/canonical/unity/lenses/remote-content-search "'none'"
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors false
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/foreground-color "'rgb(0,255,0)'"
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color "'rgb(0,0,0)'"

echo export FEEDBACK=off >> ~/.profile
echo export WESAY_TRACK_AS_DEVELOPER=1 >> ~/.profile

sed -i.bak '/\\e\]/! s@\\w@\\w$(__git_ps1)@g; s@\\\$@\\n\\\$@g' .bashrc
