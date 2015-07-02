

# nodejs + npm
sudo add-apt-repository ppa:chris-lea/node.js  
sudo apt-get update  
sudo apt-get install nodejs
# yes, npm is installed in this package!

sudo apt-get install rxvt-unicode git make i3

# install zsh and set that as shell?
# this won't take effect until after restart
sudo apt-get install zsh
sudo apt-get install git-core
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`


# syncing stuff
apt-get install ncftp python-paramiko python-pycryptopp lftp python-boto python-dev librsync-dev
wget http://code.launchpad.net/duplicity/0.6-series/0.6.22/+download/duplicity-0.6.22.tar.gz
tar xzvf duplicity*
cd duplicity*
python setup.py install
echo Let's add an RSA key for your backup server.
ssh-keygen -t rsa
ssh-copy-id nick@ischool.berkeley.edu
# add sync script to crontab


# finishing messages
echo REMEMBER! YOU NEED TO IMPORT YOUR GPG KEY!
echo gpg --import MY PRIVATE KEY and gpg --import-ownerturst MY PRIVATE KEY OWNERTRUST!
echo then, restore from a backup, and automate backups:
echo https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-securely-automate-backups-on-ubuntu
