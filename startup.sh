#!/bin/sh

# Tray software
if [ -z "$(pgrep stalonetray)" ] ; then
    stalonetray \
	--icon-gravity E \
	--geometry 4x1-0+0 \
	--max-geometry 4x1-0+0 \
	--background '#1d1f21' \
	--skip-taskbar \
	--icon-size 21 \
	--kludges force_icons_size \
	--window-strut none \
	&
fi

# Network manager
if [ -z "$(pgrep nm-applet)" ] ; then
    nm-applet --sm-disable &
fi

# Empathy chat program
if [ -z "$(pgrep empathy)" ] ; then
    empathy -h -n &
fi

# Dropbox
DROPBOX=`dropbox running`
if [ "$?" = "0" ] ; then
    dropbox start
fi

