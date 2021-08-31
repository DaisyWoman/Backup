#To run the codes, save this file as name.sh, go to the directory where it
#is located and run the following code from the terminal.
#sh name.sh /directory/subdirectory

#This script backup ubuntu server configuration, 
#data files and mysql database to a different device.

#!/bin/bash

#directories to back up
CONFIG=/etc
DATA="/home /var/www"
LIST="/tmp/backuplist_$$.txt"

#mount
mount -t fuse.vmhgfs-fuse .host:/backup /mnt/hgfs -o allow_other 
vmware-hgfsclient

#set date 
set $(date)
#echo $1 $6 $2 $3
#echo $1
if [$1 = 'Sun ]
     then 
              tar czf "/mnt/hgfs/congif_full_$6-$2-$3.tgz" $CONFIG
              rm -f /mnt/hgfs/config_inc*
              tar czf "/mnt/hgfs/data_full_$6-$2-$3.tgz" $DATA
              rm -f /mnt/hgfs/data_inc*
else
              find $CONFIG -depth -type f \(-ctime -1 -o -mtime -1 \) -print > $LIST
              tar czfT "/mnt/hgfs/config_inc_$6-$2-$3.tgz" "$LIST"
              rm -f "$LIST"
              find $DATA -depth -type f \(-ctime -1 -o -mtime -1 \) -print > $LIST
              tar czfT "/mnt/hgfs/data_inc_$6-$2-$3.tgz" "$LIST"
              rm -f "$LIST"
fi

#backup database with mysqldump command 
mysqldump --all-databases -u root --password=phpmyadmin > "/mnt/hgfs/phpmyadmin_$6-$2-$3.sql"
gzip -f "/mnt/hgfs/phpmyadmin_$6-$2-$3.sql"

umount /mnt/hgfs
