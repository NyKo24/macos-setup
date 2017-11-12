#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

## La base : Homebrew
if test ! $(which brew)
then
	echo 'Installation de Homebrew'
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Vérifier que tout est bien à jour
brew update

## Utilitaires pour les autres apps : Cask et mas (Mac App Store)
echo 'Installation de mas, pour installer les apps du Mac App Store.'
brew install mas
echo "Saisir le mail du compte iTunes :" 
read COMPTE
echo "Saisir le mot de passe du compte : $COMPTE"
read -s PASSWORD
mas signin $COMPTE "$PASSWORD"

echo 'Installation de Cask, pour installer les autres apps.'
brew tap caskroom/cask

# Installation d'apps avec mas (source : https://github.com/argon/mas/issues/41#issuecomment-245846651)
function install () {
	# Check if the App is already installed
	mas list | grep -i "$1" > /dev/null

	if [ "$?" == 0 ]; then
		echo "==> $1 est déjà installée"
	else
		echo "==> Installation de $1..."
		mas search "$1" | { read app_ident app_name ; mas install $app_ident ; }
	fi
}

## Installations des logiciels
echo 'Installation des outils en ligne de commande.'
brew install wget cmake coreutils psutils git node libssh
sudo npm install -g gulp
sudo npm install -g bower

echo 'Installation des apps : utilitaires.'
brew cask install owncloud 
install "The Unarchiver"

echo "Ouverture de OwnCloud pour commencer la synchronisation"
open -a owncloud

brew cask install appcleaner diskmaker-x filezilla mumble onyx vlc virtualbox teamviewer vagrant vagrant-manager spotify

curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
  chmod +x /usr/local/bin/docker-machine

docker-machine create \
    --driver virtualbox \
    --virtualbox-memory 3072 \
    --virtualbox-disk-size 40000 \
    docker
brew install docker-machine-nfs
docker-machine-nfs docker --shared-folder=/Users
eval $(docker-machine env docker)
echo 'Installation des apps : bureautique.'
install "Pages"
install "Keynote"
install "Numbers"
brew cask install macdown

echo 'Installation des apps : développement.'
brew cask install iterm2 sublime-text intellij-idea postman mongobooster mysqlworkbench expo-xde
install "Xcode"

echo 'Installation des apps : communication.'
install "Telegram"
install "Twitter"
install "WhatsApp"
brew cask install google-chrome transmission slack skype

echo 'Installation des apps : photo et vidéo.'
brew cask install handbrake handbrakecli 

echo "Installation de oh-my-zsh"
# Installation de oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

## ************************* CONFIGURATION ********************************
echo "Configuration de quelques paramètres par défaut…"

## FINDER

# Finder : affichage de la barre latérale / affichage par défaut en mode liste / affichage chemin accès / extensions toujours affichées
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string “Nlsv”
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Afficher le dossier maison par défaut
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Recherche dans le dossier en cours par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Pas de création de fichiers .DS_STORE
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

## RÉGLAGES DOCK
defaults write com.apple.dock tilesize -int 46
# Agrandissement actif
defaults write com.apple.dock magnification -bool true
# Taille maximale pour l'agrandissement
defaults write com.apple.dock largesize -float 128
# Minimize to application
defaults write com.apple.dock minimize-to-application -bool true

# Remove all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array

#add icon on the Dock
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Twitter.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Safari.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Spotify.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Zeplin.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Skype.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Mail.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Sublime Texte.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/IntelliJ IDEA.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Contacts.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Calendrier.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/MySQLWorkbench.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Notes.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/TeamViewer.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/FileZilla.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Telegram.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/WhatsApp.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Messages.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/FaceTime.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/App Store.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>";
killall Dock

## GENERAL
# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

    # Notebook: Battery
    sudo pmset -b         \
        sleep         10  \
        disksleep     10  \
        displaysleep   2  \
        halfdim        1

    # Notebook: Power Adapter
    sudo pmset -c         \
        sleep          4  \
        disksleep      0  \
        displaysleep   4  \
        halfdim        1  \
        autorestart    1  \
        womp           1
## MISSION CONTROL
# Mot de passe demandé immédiatement quand l'économiseur d'écran s'active
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

## Zoom
# Enable temporary zoom (Hold down ⌃⌥ to zoom when needed)
defaults write com.apple.universalaccess closeViewPressOnReleaseOff -bool false

# Zoom using scroll gesture with the Ctrl (^) modifier key
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Zoom Style
# 0 : Fullscreen
# 1 : Picture-in-picture
defaults write com.apple.universalaccess closeViewZoomMode -int 0

## APPS

# Safari : menu développeur 
defaults write com.apple.safari IncludeDevelopMenu -int 1

# Photos : pas d'affichage pour les iPhone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# TextEdit : .txt par défaut
defaults write com.apple.TextEdit RichText -int 0

# App Store
# Automatically check for updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in the background
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true

# Install app updates
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

# Install security updates
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
## ************ Fin de l'installation *********
echo "Finder et Dock relancés… redémarrage nécessaire pour terminer."
killall Dock
killall Finder

echo "Derniers nettoyages…"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*

echo "ET VOILÀ !"
echo "Après synchronisation des données cloud, lancer le script post-cloud.sh"