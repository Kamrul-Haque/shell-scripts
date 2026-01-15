set -e

VERSION="5.2.3"
FILENAME="phpMyAdmin-${VERSION}-english.zip"
DIRECT_URL="https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/${FILENAME}"

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
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
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
mysql -u"root" -p"" -e"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';"
mysql -u"root" -p"" -e"FLUSH PRIVILEGES;"

echo "6. Installing Nginx.."
sudo dnf install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
nginx -v

echo "7. Installing Valet Linux dependencies..."
sudo dnf install curl nss-tools jq xsel openssl ca-certificates

echo "8. Installing Valet Linux globally via Composer..."
composer global require genesisweb/valet-linux-plus:dev-master

echo "9. Adding Composer's global bin to PATH..."
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc

echo "10. Running valet install..."
$HOME/.config/composer/vendor/bin/valet install

echo "11. Installing PHPMyAdmin..."
mkdir -p ~/projects && cd ~/projects
valet park
curl -O "${DIRECT_URL}"
unzip ${FILENAME}
mv phpMyAdmin-${VERSION}-english phpMyAdmin
cd phpMyAdmin
cp config.sample.inc.php config.inc.php
sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg\['blowfish_secret'\] = '$(openssl rand -base64 32 | tr -d /=+ | cut -c1-32)';/" config.inc.php

echo "All done! ✅"
