FROM debian:jessie
MAINTAINER David Bariod

#RUN apt-get update && apt-get install -y \
#            apache2 \
#            git \
#            graphviz \
#            ikiwiki \
#            imagemagick \
#            libxml-writer-perl \
#            libsearch-xapian-perl \
#            openssh-server \
#            supervisor \
#            xapian-omega

RUN apt-get update && apt-get install -y \
            git \
            ikiwiki \
            libsearch-xapian-perl \
            libxml-writer-perl \
            lighttpd \
            xapian-omega


RUN apt-get install -y vim

# Setup directories needed by ssh
RUN mkdir /var/run/sshd
RUN chmod 700 /var/run/sshd

RUN echo www-data:www-data | chpasswd
COPY ikiwiki.setup /etc/ikiwiki/ikiwiki.setup

# Setup the ikiwiki directories
RUN mkdir /var/www/wiki-src
RUN chown www-data: /var/www/wiki-src
RUN mkdir /var/www/wiki.git
RUN chown www-data: /var/www/wiki.git
RUN mkdir /wiki-setup
RUN chown www-data: /wiki-setup
COPY setup.pl /wiki-setup

# Setup the lighttpd configuration
#COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

VOLUME /wiki
EXPOSE 22
EXPOSE 80
CMD /wiki-setup/setup.pl
