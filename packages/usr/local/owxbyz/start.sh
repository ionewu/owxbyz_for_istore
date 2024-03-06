#!/bin/sh

stpath="${1}"
bkpath="${2}"

inspath="${0%/*}"
cd ${inspath}
binpath="$(pwd)/bin/owxbyz"

_start() {
    params=""
    params="${params} -d"
    params="${params} -s"

    if [ -n "${stpath}" ] ; then
        params="${params} --store=${stpath}"
    fi

    if [ -n "${bkpath}" ] ; then
        export OWAPP_BACKUP_PATH=${bkpath}
    fi

    chmod +x ${binpath}
    ${binpath} ${params}
    echo "[$(date)] start ${binpath}, ret=$?"
}

_start
exit 0
