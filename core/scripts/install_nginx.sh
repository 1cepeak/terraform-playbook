#!/bin/sh

# Local env
USER=nginx
GROUP=nginx
DOMAIN="1cepeak-shelter.ru"

# Install dependencies
apt-get update
apt-get install -y nginx sudo

# Remove default config
rm /etc/nginx/sites-enabled/default

# Generate certificate
mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt --subj "/C=RU/ST=Moscow/L=Moscow/O=1cepeak's shelter/OU=IT Department/CN=1cepeak-shelter.ru"

# Create domain directory
mkdir -p /var/www/$DOMAIN/html

# Set permissions
chown -R $USER:$GROUP /var/www/$DOMAIN/html
chmod -R 755 /var/www

# Create domain index page
echo "Welcome to 1cepeak's shelter" >> /var/www/$DOMAIN/html/index.html

# Enable & start service
systemctl enable nginx
systemctl start nginx
