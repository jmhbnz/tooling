#!/bin/bash
set -x
export ALTERNATE_EDITOR=""
BASE=$(basename $1)
tmate -S /tmp/${USER}.${BASE}.iisocket new-session \
      -A -s $USER -n emacs \
      "tmate wait tmate-ready \
&& TMATE_CONNECT=\
\$(tmate display -p '#{tmate_ssh} # ${USER}.${BASE} # $(date) # #{tmate_web}') \
; echo \$TMATE_CONNECT \
; (echo \$TMATE_CONNECT | xclip -i -sel p -f | xclip -i -sel c )2>/dev/null \
; echo Share the above with your friends and hit enter here when done? \
; read ; \
emacsclient -s $BASE --tty $1 2>&1"

