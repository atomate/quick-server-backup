Backup Bash Script

1. Setup the script
2. Put it on server
3. Make script executable: chmod a+x /home/user/backup.sh
4. Add job in CRON: (crontab -l ; echo "15 3 * * * /home/user/backup.sh") | sort - | uniq - | crontab -
