#!/bin/sh

# Local env
DOMAIN="1cepeak-shelter.ru"
NGINX_DIR="/etc/nginx"
SSL_DIR="$NGINX_DIR/ssl"
SITES_AVAILABLE_DIR="$NGINX_DIR/sites-available"
SITES_ENABLED_DIR="$NGINX_DIR/sites-enabled"
HTML_DIR="/var/www/$DOMAIN/html"

# Install dependencies
apt-get update
apt-get install -y nginx sudo

# Create config
cat > $SITES_AVAILABLE_DIR/$DOMAIN <<EOF
server {
  listen 80;

  server_name $DOMAIN s3.$DOMAIN;

  # Redirect all HTTP connections to HTTPS
  return 301 https://\$host\$request_uri;
}

server {
  listen 443 ssl;

  ssl_certificate $SSL_DIR/nginx-selfsigned.crt;
  ssl_certificate_key $SSL_DIR/nginx-selfsigned.key;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers HIGH:!aNULL:!MD5;

  server_name $DOMAIN;

  root /var/www/$DOMAIN/html;
  index index.html;

  location / {
    try_files \$uri \$uri/ =404;
  }
}

server {
  listen 443 ssl;

  ssl_certificate $SSL_DIR/nginx-selfsigned.crt;
  ssl_certificate_key $SSL_DIR/nginx-selfsigned.key;
  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_ciphers HIGH:!aNULL:!MD5;

  server_name s3.$DOMAIN;

  location / {
    proxy_pass http://192.168.3.100:9000;

    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;

    proxy_buffers 16 4k;
    proxy_buffer_size 2k;

    proxy_redirect off;
  }
}
EOF
ln -s $SITES_AVAILABLE_DIR/$DOMAIN $SITES_ENABLED_DIR/$DOMAIN

# Remove default config
rm $SITES_ENABLED_DIR/default

# Generate certificate
mkdir $SSL_DIR
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $SSL_DIR/nginx-selfsigned.key -out $SSL_DIR/nginx-selfsigned.crt --subj "/C=RU/ST=Moscow/L=Moscow/O=1cepeak's shelter/OU=IT Department/CN=$DOMAIN"

# Create domain directory
mkdir -p $HTML_DIR

# Set permissions
chmod -R 755 /var/www

# Create domain index page
echo "Welcome to 1cepeak's shelter" >> $HTML_DIR/index.html

# Enable & start service
systemctl enable nginx
systemctl start nginx
