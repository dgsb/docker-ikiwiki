FROM debian:jessie
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
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Activate the www-data account for ssh acces to the git repository
RUN echo www-data:www-data | chpasswd
RUN chsh -s /bin/bash www-data

# Setup cgi for lighttpd
COPY 999-ikiwiki.conf /etc/lighttpd/conf-enabled
RUN chown www-data: /etc/lighttpd/conf-enabled/999-ikiwiki.conf

COPY ikiwiki.setup /etc/ikiwiki/ikiwiki.setup
RUN chown www-data: /etc/ikiwiki/ikiwiki.setup

# Setup the ikiwiki directories
RUN mkdir /var/www/wiki-src
RUN chown www-data: /var/www/wiki-src
RUN mkdir /var/www/wiki.git
RUN chown www-data: /var/www/wiki.git
RUN mkdir -p /var/www/html
RUN chown www-data: /var/www/html
RUN mkdir /wiki-setup
RUN chown www-data: /wiki-setup

# Startup program configuration
COPY setup.sh /wiki-setup
RUN chown www-data: /wiki-setup/setup.sh
RUN chmod 755 /wiki-setup/setup.sh
COPY ikiwiki_supervisord.conf /etc/supervisor/conf.d

# Setup the lighttpd configuration
#COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

VOLUME /wiki
EXPOSE 22
EXPOSE 80
CMD /wiki-setup/setup.sh && supervisord -n
