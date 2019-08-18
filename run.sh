#!/usr/bin/with-contenv sh

mv /etc/subversion/subversion-access-control /home/conf/subversion-access-control
ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control
