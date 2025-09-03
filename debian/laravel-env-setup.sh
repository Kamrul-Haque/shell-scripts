set -e

echo "1. Installing git and curl..."
sudo apt update && sudo apt install -y git curl

echo "2. Adding PHP 8.3 PPA and installing PHP 8.3 with Laravel-required modules..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.3 php8.3-cli php8.3-fpm php8.3-mbstring php8.3-xml php8.3-bcmath php8.3-curl php8.3-mysql php8.3-zip php8.3-common php8.3-mcrypt
php -v

echo "3. Installing Composer..."
cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
composer

echo "4. Installing Node.js from official source..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22
node -v
npm -v

echo "5. Installing MySQL Server..."
sudo apt install -y mysql-server
mysql --version

echo "6. Securing MySQL root User..."
sudo mysql -e"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

echo "7. Installing Valet Linux dependencies..."
sudo apt install -y network-manager libnss3-tools jq xsel nginx \
php8.3-cli php8.3-curl php8.3-mbstring php8.3-mcrypt php8.3-xml php8.3-zip

echo "8. Installing Valet Linux globally via Composer..."
composer global require genesisweb/valet-linux-plus

echo "9. Adding Composer's global bin to PATH..."
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
source ~/.bashrc

echo "10. Running valet install..."
~/.config/composer/vendor/bin/valet install

echo "All done! ✅"
