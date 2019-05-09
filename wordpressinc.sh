#!/bin/bash -e

#Creating Wordpress DB User and passwords with privileges.
echo "Creating Wordpress DB Users and grating privileges with already collected information...\n"

sudo mysqladmin -u root -pPassword@123 create blog

echo "Installing additional PHP plugins as a default set which might be required by Wordpress... \n
NOTE: Each WordPress plugin has its own set of requirements. Some may require additional PHP packages to be installed. Check your plugin documentation to discover its PHP requirements \n"

sudo apt-get install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc -y

#Restarting Apache to take new additions into effect

echo "Restarting Apache to get the new additions into effect..\n"

sudo systemctl restart apache2

#Enabling mod_rewrite and .htaccess overwrites in Apache2

echo "Enabling mod_rewrite and .htaccess overwrites in Apache2...\n"

sudo cat >> /etc/apache2/apache2.conf <<EOF
<Directory /var/www/html/>
    AllowOverride All
</Directory>
EOF

sudo a2enmod rewrite

sudo systemctl restart apache2


#Downloading latest Wordpress tarall and extraction

if [ ! -d /tmp ];then
sudo mkdir /tmp
fi

cd /tmp

echo "Dowloading latest wordpress to tmp directory \n"

sudo curl -O  https://wordpress.org/latest.tar.gz

sudo tar xzvf /tmp/latest.tar.gz

sudo touch /tmp/wordpress/.htaccess

sudo chmod 660 /tmp/wordpress/.htaccess

sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

sudo mkdir /tmp/wordpress/wp-content/upgrade

sudo cp -a /tmp/wordpress/. /var/www/html

cd -

sudo rm -f /var/www/html/index.html

echo "Setting reasonable file and directory permissions..\n"

sudo chown -R www-data:www-data /var/www/html

sudo find /var/www/html -type d -exec chmod g+s {} \;

sudo chmod g+w /var/www/html/wp-content

sudo chmod -R g+w /var/www/html/wp-content/themes

sudo chmod -R g+w /var/www/html/wp-content/plugins


# Writing Wordpress config file with proper config data

echo "Writing Wordpress config file with proper config data...\n"

cd /var/www/html

sudo sed -i 's/database_name_here/blog/g' /var/www/html/wp-config.php

sudo sed -i 's/username_here/root/g' /var/www/html/wp-config.php

sudo sed -i 's/password_here/Password@123/g' /var/www/html/wp-config.php

sudo sed -i 's/localhost/50.0.4.34/g' /var/www/html/wp-config.php

echo "----------------------------------------------
Wordpress Installation has been completed successfully
Log file is at $LOGFILE
You may need to add the ServerName directive as required in the sites-enabled and sites-available conf files with DNS working properly for that servername.
Please browse to http://$IP to complete the installation through web interface
The information you'll need are as follows:
1) Wordpress Database Name: $WPDBNAME
2) Wordpress Database User: $WPUSER
3) Wordpress Database User Password: $WPPWD
Keep this handy with you............
Thank you!!
--------------------------------------------\n"
