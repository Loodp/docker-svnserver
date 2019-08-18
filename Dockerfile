# Alpine Linux with s6 service management
FROM alpine:3.7

# Alpine cyrus-sasl doesn't support LDAP
#   https://pkgs.alpinelinux.org/package/edge/main/x86_64/cyrus-sasl
# Using building block from
#   https://github.com/dweomer/dockerfiles-saslauthd
#
ENV CYRUS_SASL_VERSION=2.1.26
RUN set -x && \
    mkdir -p /srv/saslauthd.d /tmp/cyrus-sasl /var/run/saslauthd && \
    export BUILD_DEPS="\
        autoconf automake make \
        curl \
        db-dev \
        g++ gcc \
        gzip \
        heimdal-dev \
        libtool \
        openldap-dev \
        tar" && \
    apk add --update ${BUILD_DEPS} cyrus-sasl libldap && \
    curl -fL ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-${CYRUS_SASL_VERSION}.tar.gz -o /tmp/cyrus-sasl.tgz && \
    curl -fL http://git.alpinelinux.org/cgit/aports/plain/main/cyrus-sasl/cyrus-sasl-2.1.25-avoid_pic_overwrite.patch?h=3.2-stable -o /tmp/cyrus-sasl-2.1.25-avoid_pic_overwrite.patch && \
    curl -fL http://git.alpinelinux.org/cgit/aports/plain/main/cyrus-sasl/cyrus-sasl-2.1.26-size_t.patch?h=3.2-stable -o /tmp/cyrus-sasl-2.1.26-size_t.patch && \
    curl -fL http://git.alpinelinux.org/cgit/aports/plain/main/cyrus-sasl/CVE-2013-4122.patch?h=3.2-stable -o /tmp/CVE-2013-4122.patch && \
    tar -xzf /tmp/cyrus-sasl.tgz --strip=1 -C /tmp/cyrus-sasl && \
    cd /tmp/cyrus-sasl && \
    patch -p1 -i /tmp/cyrus-sasl-2.1.25-avoid_pic_overwrite.patch || true && \
    patch -p1 -i /tmp/cyrus-sasl-2.1.26-size_t.patch || true && \
    patch -p1 -i /tmp/CVE-2013-4122.patch || true && \
    ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --disable-anon \
        --enable-cram \
        --enable-digest \
        --enable-ldapdb \
        --enable-login \
        --enable-ntlm \
        --disable-otp \
        --enable-plain \
        --with-gss_impl=heimdal \
        --with-devrandom=/dev/urandom \
        --with-ldap=/usr \
        --with-saslauthd=/var/run/saslauthd \
        --mandir=/usr/share/man && \
    make -j1 && \
    make -j1 install && \
    apk del --purge ${BUILD_DEPS} && \
    rm -fr /src /tmp/* /var/tmp/* /var/cache/apk/*

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
	mkdir /home/conf &&\
	mkdir /home/tools

# Add services configurations
ADD apache/ /etc/services.d/apache/
ADD subversion/ /etc/services.d/subversion/

# Add SVNAuth file
ADD subversion-access-control /etc/subversion/subversion-access-control
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
VOLUME /home/tools
