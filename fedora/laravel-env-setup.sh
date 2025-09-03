set -e

sudo systemctl start nginx
sudo systemctl enable nginx
nginx -v

echo "7. Installing Valet Linux dependencies..."
sudo dnf install curl nss-tools jq xsel openssl ca-certificates

echo "8. Installing Valet Linux globally via Composer..."
composer global require genesisweb/valet-linux-plus

echo "9. Adding Composer's global bin to PATH..."
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
source ~/.bashrc

echo "10. Running valet install..."
/home/mkhaque/.config/composer/vendor/valet install

echo "11. Installing PHPMyAdmin..."
npm install --global yarn
cd ~
mkdir projects
npm install --global yarn
git clone https://github.com/phpmyadmin/phpmyadmin.git
cd phpmyadmin
composer update --no-dev
yarn install --production

echo "All done! ✅"
