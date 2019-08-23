# Alpine Linux with s6 service management
FROM alpine:3.7

# 
RUN rm -fr /src /tmp/* /var/tmp/* /var/cache/apk/*

# Install Apache2 and other stuff needed to access svn via WebDav
# Install svn
# Installing utilities for SVNADMIN frontend
# Create required folders
# Create the authentication file for http access
# Getting SVNADMIN interface
RUN apk add --no-cache apache2 apache2-ctl apache2-utils apache2-webdav mod_dav_svn &&\
	apk add --no-cache subversion &&\
	apk add --no-cache wget unzip php7 php7-apache2 php7-session php7-json php7-ldap &&\
	apk add --no-cache php7-xml &&\	
	mkdir -p /run/apache2/ &&\
	mkdir /home/svn/ &&\
	mkdir /etc/subversion &&\
	touch /etc/subversion/passwd &&\
	mkdir /home/conf

#ServerName
RUN echo "ServerName localhost" >> /etc/apache2/httpd.conf

# Add services configurations
COPY run.sh /

# Add SVNAuth file
ADD subversion-access-control /etc/subversion/subversion-access-control-temp
RUN chmod a+w /etc/subversion/* && chmod a+w /home/svn

# Add WebDav configuration
ADD dav_svn.conf /etc/apache2/conf.d/dav_svn.conf

# Set HOME in non /root folder
ENV HOME /home

# Expose ports for http and custom protocol access
EXPOSE 80 443 3690

#
VOLUME /home/svn
VOLUME /home/conf

ENTRYPOINT ["sh", "/run.sh"]
CMD ["httpd", "-D", "FOREGROUND"]