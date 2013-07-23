#!/bin/sh
setxkbmap -layout us,ru 
setxkbmap -option 'grp:alt_space_toggle'
xmodmap -e 'remove Lock = Caps_Lock'
xmodmap -e 'keysym Caps_Lock = Control_L'
xmodmap -e 'add Control = Control_L'
