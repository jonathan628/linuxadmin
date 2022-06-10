#!/bin/sh

#THIS WILL BE THE BACKUP.

echo "
  
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$	
$										   $
$               BACKUP!!!!                 $
$                                          $
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
"
yum install -y ntpdate
ntpdate ntp.ubuntu.com
date=$(date '+%m-%d-%Y')
mkdir /opt/backups
cd /opt/backups
mysqldump -u root -pthan wordpress > wordpress${date}.sql
gzip -cv wordpress${date}.sql > wordpress${date}.gz 
