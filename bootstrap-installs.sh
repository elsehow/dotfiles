

# nodejs + npm
sudo add-apt-repository ppa:chris-lea/node.js  
sudo apt-get update  
sudo apt-get install nodejs
# yes, npm is installed in this package!

sudo apt-get install vim git make i3

# install zsh and set that as shell?
# this won't take effect until after restart
sudo apt-get install zsh
sudo apt-get install git-core
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
