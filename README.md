Backup Bash Script

This is a quick bash script to backup all your websites and databases from a single serve to a remote FTP location. 

How to use

To use this script you will need ssh access to the server and access to an FTP.

It is usually best to set it up with cron, similar to this

30 3 * * * /home/user/bin/backup.sh

Make the script executable by running

chmod a+x /home/user/bin/backup.sh


