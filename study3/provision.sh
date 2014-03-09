#!/usr/bin/env bash

echo "Apache provisioning start ..."
apt-get update
apt-get install -y apache2
rm -rf /var/www
ln -fs /vagrant /var/www
echo "Hello, Auto Provisioning." > /vagrant/index.html
echo "Apache provisioning end ..."

