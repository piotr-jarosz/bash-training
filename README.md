# bash-training-0

This is first project to training bash skills

## AIM

Home backup script

### TODO: 
* handle parameters
* override config file throught parameters


### Done
* handle configuration sfile
* use rsync to perform the actual backup.
* offer a choice of tar or rsync.
* copy to a folder named for the current day of the week
* run once daily
* use tar to perform the actual backup.
* writing itself into the crontab if called with the correct arguments (while removing any instances of itself already in the crontab
* keeping 7 daily backups (including the current day) as history 



### Future Enhancements:
* check for disk space before attempting the backup and pause the script, email an alert to you and then wait until sufficient disk space is available.
* write you a report showing start time, end time and quantity of data copied.
* error handler.
* config check
* possibility backup to ftp
* possibility backup to sftp
* possibility backup to s3
* possibility backup to NFS volume
* Installation (create custom config file, initially add script to crontab and setup some installation directory)
* accepting different compression algorithms as arguments
* checking for the presence of different compression programs and using the "best" one it finds
* comparing the size of today's archive to yesterdays and sending the user an email if it changed significantly
