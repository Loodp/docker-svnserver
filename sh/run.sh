#/bin/sh

mv /etc/subversion/subversion-access-control /home/conf/subversion-access-control.conf
ln -s /home/conf/subversion-access-control.conf /etc/subversion/subversion-access-control.conf

mv /etc/subversion/passwd /home/conf/passwd.conf
ln -s /home/conf/passwd.conf /etc/subversion/passwd.conf
