# bash-training-0

This is first project due to training bash skills

## AIM

A script to backup configured directories.

### Requirements 
* keeping 7 daily backups (including the current day) as history 
* handle configuration file
* handle parameters
* override config file throught parameters

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

### Done
* use rsync to perform the actual backup.
* offer a choice of tar or rsync.
* copy to a folder named for the current day of the week
* run once daily
* use tar to perform the actual backup.
