# this package lets you apt-add-repository, which we need to install java
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
# install our stuff
sudo apt-get install git-core zsh vim curl make build-essential clang oracle-java8-installer

# nodejs + npm
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs

# install zsh and set that as shell?
# this won't take effect until after restart
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`

# isntall vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install lein
curl -fLo ~/opt/lein --create-dirs \ 
    https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
