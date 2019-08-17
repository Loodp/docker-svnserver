#/bin/sh

mv /etc/subversion/subversion-access-control /home/conf/subversion-access-control
ln -s /home/conf/subversion-access-control /etc/subversion/subversion-access-control

mv /etc/subversion/passwd /home/conf/passwd
ln -s /home/conf/passwd /etc/subversion/passwd
