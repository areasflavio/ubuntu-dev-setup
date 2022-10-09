echo "Welcome! Let's start setting up your system. It could take more than 10 minutes, be patient"

echo "What name do you want to use in GIT user.name?"
echo "For example, mine will be \"Flávio Arêas\""
read git_config_user_name

echo "What email do you want to use in GIT user.email?"
echo "For example, mine will be \"areasflavio@outlook.com\""
read git_config_user_email

echo "What is your github username?"
echo "For example, mine will be \"areasflavio\""
read username

cd ~ && sudo apt-get update

echo 'Installing curl' 
sudo apt-get install curl -y

echo 'Installing neofetch' 
sudo apt-get install neofetch -y

echo 'Installing latest git' 
sudo apt-get install git -y

echo 'Installing python3-pip'
sudo apt-get install python3-pip -y; sudo apt install python-is-python3 -y; sudo apt-get update &&

echo 'Installing getgist to download dot files from gist'
sudo pip3 install getgist
export GETGIST_USER=$username

if [$XDG_CURRENT_DESKTOP == 'KDE'] ; then
    echo 'Cloning your Konsole configs from gist'
    cd ~/.local/share/konsole && getmy OmniKonsole.profile && getmy OmniTheme.colorscheme

    echo 'Installing Latte Dock'
    sudo add-apt-repository ppa:kubuntu-ppa/backports -y
    sudo apt-get update && sudo apt-get dist-upgrade -y
    sudo apt-get install cmake extra-cmake-modules qtdeclarative5-dev libqt5x11extras5-dev libkf5iconthemes-dev libkf5plasma-dev libkf5windowsystem-dev libkf5declarative-dev libkf5xmlgui-dev libkf5activities-dev build-essential libxcb-util-dev libkf5wayland-dev git gettext libkf5archive-dev libkf5notifications-dev libxcb-util0-dev libsm-dev libkf5crash-dev libkf5newstuff-dev libxcb-shape0-dev libxcb-randr0-dev libx11-dev libx11-xcb-dev -y
    sudo git clone https://github.com/KDE/latte-dock.git /usr/local/latte-dock
    cd /usr/local/latte-dock && sudo sh install.sh

    echo 'Installing Kvantum Manager'
    sudo add-apt-repository ppa:papirus/papirus -y
    sudo apt-get update && sudo apt install qt5-style-kvantum -y
fi

echo "Setting up your git global user name and email"
git config --global user.name "$git_config_user_name"
git config --global user.email $git_config_user_email

echo 'Cloning your .gitconfig from gist'
getmy .gitconfig

echo 'Generating a SSH Key'
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

echo 'Installing NVM' 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
sudo apt-get update &&
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo 'Installing NodeJS LTS'
nvm --version
nvm install --lts
nvm current

echo 'Installing Yarn'
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn
echo '"--emoji" true' >> ~/.yarnrc

echo 'Installing Typescript'
yarn global add typescript

echo 'Installing VSCode'
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https -y
sudo apt update && sudo apt install code -y

sudo apt install gnome-keyring -y

echo 'Installing Vivaldi' 
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main' -y
sudo apt update && sudo apt install vivaldi-stable -y

echo 'Launching Vivaldi on Github so you can paste your keys'
vivaldi https://github.com/settings/keys </dev/null >/dev/null 2>&1 & disown

echo 'Installing Docker'
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y
apt-cache policy docker-ce
sudo apt install docker-ce -y

sudo systemctl status docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

echo 'Installing Insomnia Core'
echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" \
    | sudo tee -a /etc/apt/sources.list.d/insomnia.list
sudo apt-get update
sudo apt-get install insomnia -y

echo 'Installing VLC'
sudo apt-get install vlc -y
sudo apt-get install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

echo 'Installing Discord'
sudo apt --fix-broken install -y
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt-get install -f -y && rm discord.deb

echo 'Installing Spotify' 
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client -y

echo 'Installing tool to handle clipboard via CLI'
sudo apt-get install xclip -y

echo 'Installing CopyQ' 
sudo add-apt-repository ppa:hluk/copyq -y
sudo apt update
sudo apt install copyq -y

echo 'Updating and Cleaning Unnecessary Packages'
sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get full-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
clear

echo 'Installing postgres container'
docker run --name postgres -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres

echo 'Installing mongodb container'
docker run --name mongodb -p 27017:27017 -d -t mongo

echo 'Bumping the max file watchers'
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'Installing Stacer'
sudo add-apt-repository ppa:oguzhaninan/stacer -y
sudo apt-get update
sudo apt-get install stacer -y

echo 'Installing Dropbox Client'
sudo rm -Rf /opt/dropbox*;sudo rm -Rf /usr/bin/dropbox;sudo rm -Rf /usr/share/applications/dropbox.desktop
wget "http://www.dropbox.com/download/?plat=lnx.x86_64" -O dropbox.tar.gz
sudo tar -xvf dropbox.tar.gz -C /opt/
sudo mv /opt/.dropbox-dist/ /opt/dropbox
sudo ln -sf /opt/dropbox/dropboxd /usr/bin/dropbox
echo -e '[Desktop Entry]\n Version=1.0\n Name=Dropbox\n Exec=/opt/dropbox/dropboxd\n Icon=dropbox\n Type=Application\n Categories=Application' | sudo tee /usr/share/applications/Dropbox.desktop
sudo chmod +x /usr/share/applications/Dropbox.desktop

echo 'Installing ZSH'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

echo 'Indexing snap to ZSH'
sudo chmod 777 /etc/zsh/zprofile
echo "emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'" >> /etc/zsh/zprofile

echo 'Installing Spaceship ZSH Theme'
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
source ~/.zshrc

echo 'Installing ZSH plugins'
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

echo 'Installing EXA'
sudo apt install exa -y

echo 'Installing bat'
sudo apt install exa -y
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat

clear
echo 'All setup, enjoy!'
