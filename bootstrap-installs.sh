sudo apt-get install git-core zsh vim curl make # python2.7 git-all pkg-config libncurses5-dev libssl-dev libnss3-dev libexpat-dev

# install zsh and set that as shell?
# this won't take effect until after restart
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
