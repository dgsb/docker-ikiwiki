FROM debian:stretch-slim
MAINTAINER David Bariod <davidriod@googlemail.com>

RUN apt-get update && apt-get install -y \
            git \
            ikiwiki \
            libsearch-xapian-perl \
            libtext-csv-perl \
            libxml-writer-perl \
            lighttpd \
            openssh-server \
            supervisor \
            xapian-omega

# Setup directories needed by ssh
RUN mkdir /var/run/sshd
RUN chmod 700 /var/run/sshd

# Activate the www-data account for ssh acces to the git repository
RUN chsh -s /bin/bash www-data

# Setup cgi for lighttpd
COPY 999-ikiwiki.conf /etc/lighttpd/conf-enabled
RUN chown www-data: /etc/lighttpd/conf-enabled/999-ikiwiki.conf

COPY ikiwiki.setup /etc/ikiwiki/ikiwiki.setup
RUN chown www-data: /etc/ikiwiki/ikiwiki.setup

# Setup the ikiwiki directories
RUN install -d -o www-data -g www-data /var/www/wiki-src /var/www/wiki.git /var/www/html /wiki-setup

# Startup program configuration
COPY setup.sh /wiki-setup
RUN chown www-data: /wiki-setup/setup.sh
RUN chmod 755 /wiki-setup/setup.sh
COPY ikiwiki_supervisord.conf /etc/supervisor/conf.d

# Add the volume from which the wiki repository will be retrieved from
VOLUME /wiki

EXPOSE 22
EXPOSE 80
CMD /wiki-setup/setup.sh && supervisord -n
