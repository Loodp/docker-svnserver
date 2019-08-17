# Alpine Linux with s6 service management
FROM smebberson/alpine-base

	# Install Apache2 and other stuff needed to access svn via WebDav
	# Install svn
	# Installing utilities for SVNADMIN frontend
	# Create required folders
	# Create the authentication file for http access
	# Getting SVNADMIN interface
RUN apk add --no-cache apache2 apache2-ctl apache2-utils apache2-webdav mod_dav_svn apr apr-util &&\
	mkdir -p /run/apache2/ &&\

# Add services configurations
ADD apache/ /etc/services.d/apache/
ADD subversion/ /etc/services.d/subversion/
ADD sh/ /home/insetSh/

# Add SVNAuth file
ADD subversion-access-control /etc/subversion/subversion-access-control
RUN chmod -R a+w /etc/subversion/* && chmod -R a+w /home/svn

# Add WebDav configuration
ADD dav_svn.conf /etc/apache2/conf.d/dav_svn.conf

# Set HOME in non /root folder
ENV HOME /home

# Expose ports for http and custom protocol access
EXPOSE 80 443 3690

