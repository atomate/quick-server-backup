Backup Bash Script
===================

Overview
-------------

This is a quick bash script to backup all your websites files and `mysql` databases from a single serve to a remote `FTP` location. 

Requirements
-------------

To use this script you will need `ssh` access to the server and access to an `FTP`.

- SSH access to server with ability to use cron
- FTP location to store backups


How to use
-------------

It is usually best to set it up with `cron`, similar to this

``30 3 * * * /home/user/bin/backup.sh``

Make the script executable by running

``chmod a+x /home/user/bin/backup.sh``

Configuration reference
-------------

#### GENERAL

- SERVER
- BACKDIR
- HOST
- USER=user
- PASS=password
- DBS
- DUMPALL
- FILES
- PROJECTS
- FTP=y

#### FTP
- FTPHOST="backup.server.com"
- FTPUSER="user"
- FTPPASS="pass"
- FTP_SUCCESS_MSG

#### FOLDER
directory to backup; if it doesn't exist, file will be uploaded to first logged-in directory
- FTPDIR="backups"

#### EMAIL
- MAIL=y
- EMAIL="mail@mail.com"
- SUBJECT="Backup on $SERVER ($DATE)"

- BODYFTPSCC="Your backup is completed localy! Files are uploaded to FTP server."
- BODYFTPERR="Your backup is com  spleted localy! Error uploading to FTP."

#### DELETE
- DELETE=y

- DAYS=15
- DAYSLOCAL=15
- RMDATE=$(date +"%Y-%m-%d" -d "$DAYS days ago")
- RMDATELOCAL=$(date +"%Y-%m-%d" -d "$DAYSLOCAL days ago")

## !!! Notice
_The script works properly only if it runs everyday._