#!/usr/bin/env perl
use strict;
use warnings;

chdir "/wiki";
system("git status");
if (0 != $?) {
    die "Can not find a git repository at /wiki";
}

system("git clone --bare /wiki /var/www/wiki.git");
if (0 != $?) {
    die "Can not clone the repository";
}
system("git clone /var/www/wiki.git /var/www/wiki-src");

system("ikiwiki --setup /etc/ikiwiki/ikiwiki.setup --rebuild --wrappers");

print "The setup script has been run\n";
exec("/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf")
