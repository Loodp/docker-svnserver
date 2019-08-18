#!/bin/bash

mv /etc/subversion/subversion-access-control /home/conf/subversion-access-control
ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control

/usr/sbin/apachectl -DFOREGROUND
/usr/bin/svnserve -d --foreground -r /home/svn --listen-port 3690
