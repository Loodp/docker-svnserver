#!/bin/bash
set -e

echo Running: "$@"

# move file
authFile=/home/conf/subversion-access-control
tempAuthFile=/etc/subversion/subversion-access-control-temp

# ln auth file
if [ -f "/home/conf/subversion-access-control" ];then
echo "auth file in conf exits"
ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control
else
echo "auth file in conf not exits"
cp /etc/subversion/subversion-access-control-temp /home/conf/subversion-access-control
ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control
fi

# start svn
count=`ps -ef |grep svnserve |grep -v "grep" |wc -l`
if [ 0 == $count ];then
/usr/bin/svnserve -d -r /home/svn --listen-port 3690
fi

###
### Start apache...
###
rm -f /var/log/apache2/error.log
rm -f /var/log/apache2/access.log
rm -f /var/log/apache2/subversion.log

#httpd -k start

# fallthrough...
exec httpd -D FOREGROUND
