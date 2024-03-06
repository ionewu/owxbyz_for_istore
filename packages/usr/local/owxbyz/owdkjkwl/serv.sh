#!/bin/sh

cd "${0%/*}"
cd $(dirname $0)
CURPATH="$(pwd)"

SNAME=owdkjkwl
SPATH="${CURPATH}/${SNAME}man"

_start() {
    chmod +x "${SPATH}"

    find ${APPPATH} -mtime +10 -name "*.log" -exec rm -f {} \;
    ${SPATH} -d
}
_stop() {
    chmod +x "${SPATH}"
    ${SPATH} --kill=yes
    ${SPATH} --kill=yes
}

case "${1}" in
    start) _start ;;
    stop) _stop ;;
esac

echo "CMD-OK"
exit 0
