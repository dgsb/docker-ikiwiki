#!/bin/bash

die() {
    echo $0
    exit 1
}

cd /wiki
git status 2>&1 > /dev/null
if [[ $? -ne 0 ]] ; then
    die "Can not find a git repository at /wiki"
fi
cd -

set -e
git clone --bare /wiki /var/www/wiki.git
chown -R www-data: /var/www/wiki.git
tmpfile=$(mktemp)
cat > $tmpfile <<EOF
#!/bin/bash
git clone /var/www/wiki.git /var/www/wiki-src
ikiwiki --setup /etc/ikiwiki/ikiwiki.setup --rebuild --wrappers
EOF
chmod 755 $tmpfile
su www-data -c $tmpfile

echo "The setup script has been run"
