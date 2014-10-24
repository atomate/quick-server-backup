Backup Bash Script
===================

Overview
-------------

This is a quick bash script to backup all your websites and databases from a single serve to a remote FTP location. 

Requirements
-------------

To use this script you will need ssh access to the server and access to an FTP.

- SSH access to server with ability to use cron
- FTP location to store backups


How to use
-------------

It is usually best to set it up with cron, similar to this

``30 3 * * * /home/user/bin/backup.sh``

Make the script executable by running

``chmod a+x /home/user/bin/backup.sh``

Configuration reference
-------------

SERVER
BACKDIR
HOST
USER=user
PASS=password
DBS
DUMPALL
FILES
PROJECTS
FTP=y

# FTP server settings; should be self-explanatory
FTPHOST="backup.server.com"
FTPUSER="user"
FTPPASS="pass"

#TODO : FOLDER
# directory to backup to. if it doesn't exist, file will be uploaded to 
# first logged-in directory
FTPDIR="backups"

#TODO : EMAIL
MAIL=y
EMAIL="mail@mail.com"
SUBJECT="Backup on $SERVER ($DATE)"

BODYFTPSCC="Your backup is completed localy! Files are uploaded to FTP server."
BODYFTPERR="Your backup is completed localy! Error uploading to FTP."

# delete old files?
DELETE=y

# how many days of backups do you want to keep?
DAYS=15
DAYSLOCAL=1
RMDATE=$(date +"%Y-%m-%d" -d "$DAYS days ago")
RMDATELOCAL=$(date +"%Y-%m-%d" -d "$DAYSLOCAL days ago")
