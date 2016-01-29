# this package lets you apt-add-repository, which we need to install java
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
# install our stuff
sudo apt-get install git-core zsh vim curl make build-essential clang oracle-java8-installer unzip tree emacs24

# nodejs + npm
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

# install + configure i3
sudo apt-get install i3 dmenu
cat i3config > ~/.i3/config


# install oh-my-zsh
# set zsh as shell
# plut zshrc into place
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
cp .zshrc ~/.zshrc

# isntall vim-plug
# put .vimrc in place
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp .vimrc ~/.vimrc

# install lein
curl -fLo ~/opt/lein --create-dirs \ 
    https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein

# put emacs stuff in place
cp -r emacs.d/* ~/.emacs.d/

# add i3 config
cp i3config ~/.i3/config
