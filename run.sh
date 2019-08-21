#!/bin/bash
set -e

# return true if specified directory is empty
function directory_empty() {
[ -n "$(find "${1}"/ -prune -empty)" ]
}

echo Running: "$@"

# move file
# mv /etc/subversion/subversion-access-control /home/conf/subversion-access-control
# ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control

# start svn
/usr/bin/svnserve -d --foreground -r /home/svn --listen-port 3690

# fallthrough...
exec "$@"
