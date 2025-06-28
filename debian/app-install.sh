set -e
: '
echo "Installing Brave Browser..."
curl -fsS https://dl.brave.com/install.sh | sh

echo "Installing Snap Store..."
sudo apt update
sudo apt install -y snapd
source ~/.bashrc
sudo snap install snap-store
'
echo "Installing VS Code from Snap..."
sudo snap install code --classic

echo "Installing PHP Storm from Snap..."
sudo snap install phpstorm --classic

echo "Installing Postman from Snap..."
sudo snap install postman

echo "Installing MPV Player from Flathub..."
sudo flatpak install io.mpv.Mpv

echo "Intalling Steam..."
sudo apt install -y steam

echo "Done! ✅"
