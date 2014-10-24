#! /bin/bash

# Backup Bash Script
# for once per day backup
# v.1.0.1
# Atomate Limited
# info@atomate.net


#TODO : SERVER NAME (ANYTHING)
# your server's name
SERVER=AT_SERVER

# date format that is appended to filename
DATE=$(date +"%Y-%m-%d")

# directory to backup to
BACKDIR=~/backups

#----------------------MySQL Settings--------------------#

# your MySQL server's location (IP address is best)
HOST=127.0.0.1

#TODO : MYSQL DATA
# MySQL
USER=user
PASS=password

# List all of the MySQL databases that you want to backup in here, 
# each separated by a space
DBS="my_db"

# set to 'y' if you want to backup all your databases. this will override
# the database selection above.
DUMPALL=y

#----------------------FILE Path Settings--------------#

#TODO : SETTING UP FILES
# set to 'y' if you want to backup files (set to 'n' to skip)
FILES=y
#set projects paths, each separated by comma
PROJECTS="/var/www/project1,/var/www/project2"

#----------------------FTP Settings--------------------#

#TODO : FTP
# set "FTP=y" if you want to enable FTP backups
FTP=y

# FTP server settings; should be self-explanatory
FTPHOST="backup.server.com"
FTPUSER="user"
FTPPASS="pass"

#TODO : FOLDER
# directory to backup to. if it doesn't exist, file will be uploaded to 
# first logged-in directory
FTPDIR="backups"

#----------------------Mail Settings--------------------#

#TODO : EMAIL
# set to 'y' if you'd like to be emailed (requires mutt)
MAIL=y
EMAIL="mail@mail.com"
SUBJECT="Backup on $SERVER ($DATE)"

BODYFTPSCC="Your backup is completed localy! Files are uploaded to FTP server."
BODYFTPERR="Your backup is completed localy! Error uploading to FTP."

#-------------------Deletion Settings-------------------#

# delete old files?
DELETE=y

# how many days of backups do you want to keep?
DAYS=15
DAYSLOCAL=1
RMDATE=$(date +"%Y-%m-%d" -d "$DAYS days ago")
RMDATELOCAL=$(date +"%Y-%m-%d" -d "$DAYSLOCAL days ago")

#----------------------End of Settings------------------#


if  [ -e ${BACKDIR} ]
then
	echo Backups directory already exists
else
	mkdir ${BACKDIR}
fi


if  [ -e ${BACKDIR}/${SERVER}_${DATE} ]
then
	echo Backups for specific date directory already exists
else
	mkdir ${BACKDIR}/${SERVER}_${DATE}
fi


if  [ ${DUMPALL} = "y" ]
then
    echo " "
	echo "Creating list of all your databases..."

	mysql -h ${HOST} --user=${USER} --password=${PASS} -e "show databases;" > dbs_on_${SERVER}.txt

	# redefine list of databases to be backed up
	DBS=`sed -e ':a;N;$!ba;s/\n/ /g' -e 's/Database //g' dbs_on_${SERVER}.txt`
fi


echo " "
echo "Backing up MySQL databases..."
for database in ${DBS}
do
	mysqldump -h ${HOST} --user=${USER} --password=${PASS} ${database} > \
	${BACKDIR}/${SERVER}_${DATE}/${SERVER}-mysql-${database}-${DATE}.sql

	gzip -f -9 ${BACKDIR}/${SERVER}_${DATE}/${SERVER}-mysql-${database}-${DATE}.sql
done


cd ${BACKDIR}
mkdir logs


if [ ${FILES} = "y" ]
then
    echo " "
    echo "File backups..."
    IFS=',' read -ra ADDR <<< "$PROJECTS"
    for i in "${ADDR[@]}"; do
        echo " "
        echo Backup ${i} ...
        BASENAME=`basename ${i}`
        tar -zcvf ${BASENAME}.tar.gz ${i}
        mv ${BASENAME}.tar.gz ${SERVER}_${DATE}/${BASENAME}.tar.gz
    done
fi


tar -zcvf ${SERVER}_${DATE}.tar.gz ${SERVER}_${DATE} && rm -R ${SERVER}_${DATE}


if  [ ${FTP} = "y" ]
then
echo " "
echo "Initiating FTP connection..."
echo Uploading ${SERVER}_${DATE}.tar.gz ...
echo Deleting ${SERVER}_${RMDATE}.tar.gz ...
echo Connecting ...

    touch logs/${SERVER}_ftplog.txt
    FTPLOG=logs/${SERVER}_ftplog.txt
	FTP_SUCCESS_MSG="226 Transfer complete"

	ftp -nv <<EOF > ${FTPLOG}
	open ${FTPHOST}
	user ${FTPUSER} ${FTPPASS}
	cd ${FTPDIR}
	put "${SERVER}_${DATE}.tar.gz"
	prompt
	mdelete "${SERVER}_${RMDATE}.tar.gz"
	quit
EOF

if  [ ${MAIL} = "y" ]
then

    if fgrep "${FTP_SUCCESS_MSG}" ${FTPLOG} ;then
       echo ${BODYFTPSCC} | mail -s ${SUBJECT} ${EMAIL}
    else
       echo ${BODYFTPERR} | mail -s ${SUBJECT} ${EMAIL}
    fi

fi

echo " "
echo -e  "FTP transfer complete! \n"
fi


if  [ ${DELETE} = "y" ]
then
    rm -rf ${SERVER}_${RMDATELOCAL}.tar.gz
	if  [ ${DAYSLOCAL} = "1" ]
	then
	    echo " "
		echo "Yesterday's backup has been deleted."
	else
	    echo " "
		echo "The backup from $DAYSLOCAL days ago has been deleted."
	fi
fi


echo " "
echo Your backup is complete!
exit 0