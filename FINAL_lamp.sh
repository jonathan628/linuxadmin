#!/bin/sh

echo "WGET IS NOW INSTALLING!!!"
#This command, install wget
yum install -y wget

echo "THE TIME RANGE IS NOW UPDATING!!!"
#This command, install ntpdate to update the date and time of the VM.
yum install -y ntpdate

echo "UPDATING!!!"

#This command, update date and time.
ntpdate ntp.ubuntu.com

echo "HTTPD IS NOW INSTALLING!!!"
#This command, install httpd on your VM
yum install -y httpd

echo "APACHE IS STARTING RIGHT NOW!!!"
#This command  start apache on your VM
systemctl start httpd.service

echo "     
	*********************************
	*    "FIREWALL TRAFFIC..."      *
	********************************* "
	
#This command, tell firewalld to allow traffic to our web server
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp

echo "RELOADING!!!!....................."
#This command,  reload the firewall to apply the changes
firewall-cmd --reload

echo "ENABLING HTTPD.SERVICE.............."
#This command,  enable apache to start on boot
systemctl enable httpd.service

echo "PHP APACHE AND MODULES INSTALLING!!!.................."
#These commands,  Install and update PHP Apache lamp and WordPress.
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y yum-utils
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php56
yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo

echo "********************************************
      *    "RESTARTING THE HTTPD SERVICE!!!"     *
      ********************************************"
	  
#This command,  restart apache.
systemctl restart httpd.service

echo "MYSQL IS NOW INSTALLING!!!"
#This command  install MySQL (MariaDB)
yum install -y mariadb-server mariadb

echo "STARTING MARIADB!!!"
#This command  start MariaDB
systemctl start mariadb

echo "SECURING INSTALLATION SCRIPT!!!"

#This command, run mysql_secure_installation script
echo -e "\nY\nTHAN\nTHAN\nY\nY\nY\nY\n " | mysql_secure_installation

systemctl enable mariadb.service

mysql -u root -pTHAN -e "CREATE DATABASE wordpress;"

echo "CREATING MYSQL ACCOUNT!!!"
#This command, create a new SQL account grants privileges to database wordpress.
mysql -u root -pTHAN -e "CREATE USER wp_user@localhost IDENTIFIED BY 'wp_thanthan';"
mysql -u root -pTHAN -e "GRANT ALL PRIVILEGES ON wordpress.* TO wp_user@localhost IDENTIFIED BY 'wp_thanthan';"
mysql -u root -pTHAN -e "FLUSH PRIVILEGES;"

#This command  bring you to root directory
cd ~

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      @                                      @
	  @      DOWNLOADING WORDPRESS!!!!       @
	  @                                      @
	  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	  
#This command , download WordPress.
wget http://wordpress.org/latest.tar.gz
#This command, extract the archived file.
tar xzvf latest.tar.gz
#This command, install rsync.
yum install -y rsync
#This command, transfer the file to /var/www/html.
rsync -avP ~/wordpress/ /var/www/html/
#This command, add uploads.
mkdir /var/www/html/wp-content/uploads
#This command, assign correct permissions to the wordpress.
chown -R apache:apache /var/www/html/*
#This command, bring you to apache root.
cd /var/www/html/
#This command, create wp-config.php file by extracting wp-config-sample.php
cat wp-config-sample.php |
sed -e 's/database_name_here/wordpress/g' | 
sed -e 's/username_here/wp_user/g' | 
sed -e 's/password_here/wp_thanthan/g' > wp-config.php

echo "THANK YOU!

100001010101010101101010101010101010101010101010111
101101010101010101010101010010101010101010101010101
101010010010101010101000101011010101010101010100110
101111011010101010010101010101010101010010101010101"


