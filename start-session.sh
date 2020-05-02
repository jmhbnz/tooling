#!/bin/bash
tmate -S /tmp/$USER.$USER.tmate new-session -s $USER -n $USER -d
tmate -S /tmp/$USER.$USER.tmate set-window-option -t $USER automatic-rename off 
tmate -S /tmp/$USER.$USER.tmate set-window-option -t $USER allow-rename off
