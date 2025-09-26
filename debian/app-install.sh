set -e

echo "Installing Brave Browser..."
curl -fsS https://dl.brave.com/install.sh | sh

echo "Installing Snap Store..."
sudo apt update
sudo apt install -y snapd
source ~/.bashrc
sudo snap install snap-store

echo "Installing Transmission..."
sudo apt install -y transmission

echo "Installing VS Code from Snap..."
sudo snap install code --classic

echo "Installing PHP Storm from Snap..."
sudo snap install phpstorm --classic

echo "Installing Postman from Snap..."
sudo snap install postman

echo "Installing MPV Player from Snap..."
sudo snap install vlc

echo "Installing Steam..."
sudo apt install -y steam

echo "Done! ✅"
