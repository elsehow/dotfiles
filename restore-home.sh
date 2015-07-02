!/bin/sh

test -x $(which duplicity) || exit 0
. .passphrase

export PASSPHRASE
$(which duplicity) --encrypt-key C3D82B5E scp://nick@ischool.berkeley.edu/backup/elsehow/ /home/ffff/restore/
