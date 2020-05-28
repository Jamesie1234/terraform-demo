#!/bin/bash
yum install httpd -y
echo "Subnet for Firewall: " >> /var/www/html/index.html
service httpd start
chkconfig httpd on
