#!/bin/bash
tmate -S /tmp/$USER.$USER.tmate new-session -s james -n james -d
tmate -S /tmp/$USER.$USER.tmate set-window-option -t james automatic-rename off 
tmate -S /tmp/$USER.$USER.tmate set-window-option -t james allow-rename off
