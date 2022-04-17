#!/bin/bash

dir=`dirname "$0"`

tmpdir=`mktemp -d`
pipe="$tmpdir/x.wav"
touch $pipe

cat - | "$dir"/sonde_sgp.py "$@" > "$pipe" &

tpid=$!

function ex() {
  kill $tpid
  rm $pipe
  rmdir $tmpdir
}

trap ex SIGINT SIGTERM SIGCHLD SIGHUP

tail -c 1048576 -f "$pipe" | ./rs41ecc -v -b 2>&1 | tee -a /tmp/rs41.log

rm $pipe
rmdir $tmpdir
exit
