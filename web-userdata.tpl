#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd
aws s3 cp s3://"${s3location}"/static.zip /var/www/static.zip
unzip -o /var/www/static.zip -d /var/www/html
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
