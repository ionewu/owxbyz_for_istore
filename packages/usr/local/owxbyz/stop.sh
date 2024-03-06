#!/bin/sh

inspath=$(dirname $0)
cd ${inspath}
binpath="$(pwd)/bin/owxbyz"

_stop() {
    chmod +x ${binpath}
    ${binpath} --kill=yes
    docker ps -q -f NAME=owxbyz_ | xargs -n1 docker stop -t 1 >/dev/null 2>&1
}

_stop
_stop
exit 0
