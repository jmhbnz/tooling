#!/bin/bash
tmate -S /tmp/$USER.tmate.tmate new-session -s $USER -n $USER -d
tmate -S /tmp/$USER.tmate.tmate set-window-option -t $USER automatic-rename off 
tmate -S /tmp/$USER.tmate.tmate set-window-option -t $USER allow-rename off
tmate -S /tmp/$USER.tmate.tmate attach
