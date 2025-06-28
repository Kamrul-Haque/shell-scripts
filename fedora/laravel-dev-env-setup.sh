set -e

echo "1. Installing git and curl..."
sudo dnf update && sudo dnf install -y git curl

echo "2. Adding PHP 8.3 Remi Repo and installing PHP 8.3 with Laravel-required modules..."
sudo dnf install http://rpms.remirepo.net/fedora/remi-release-42.rpm -y
sudo dnf module enable php:remi-8.3
sudo dnf install php php-cli php-fpm
sudo dnf install openssl php-bcmath php-curl php-json php-mbstring php-mysql php-tokenizer php-xml php-zip php-posix php-mcrypt php-gd
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
php -v
php-fpm -v

echo "3. Installing Composer..."
cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
composer --version

echo "4. Installing Node.js from official source..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22
node -v
npm -v

echo "5. Installing MySQL Server..."
sudo dnf install -y mysql-server
mysql --version
sudo mysql -e"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

echo "6. Installing Nginx.."
sudo dnf install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
nginx -v

echo "7. Installing Valet Linux dependencies..."
sudo dnf install -y network-manager libnss3-tools jq xsel nginx

echo "8. Installing Valet Linux globally via Composer..."
composer global require genesisweb/valet-linux-plus

echo "9. Adding Composer's global bin to PATH..."
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
. ~/.bashrc

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
