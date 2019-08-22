#!/bin/bash
set -e

echo Running: "$@"

# move file
ln -s /etc/subversion/subversion-access-control /home/conf/subversion-access-control
# ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control

# start svn
count=`ps -ef |grep svnserve |grep -v "grep" |wc -l`
echo $count
#echo $count
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
