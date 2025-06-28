set -e

echo "9. Adding Composer's global bin to PATH..."
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
source ~/.bashrc

echo "10. Running valet install..."
valet install

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
