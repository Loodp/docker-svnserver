#!/bin/bash
set -e

echo Running: "$@"

# move file
# mv /etc/subversion/subversion-access-control /home/conf/subversion-access-control
# ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control

# start svn
/usr/bin/svnserve -d --foreground -r /home/svn --listen-port 3690

###
### Start apache...
###

if [[ `basename ${1}` == "httpd" ]]; then # prod
# The tail approach...

exec "$@" </dev/null #>/dev/null 2>&1
else # dev
rm -f /var/log/apache2/error.log
rm -f /var/log/apache2/access.log
rm -f /var/log/apache2/subversion.log

httpd -k start
fi

# fallthrough...
exec "$@"
