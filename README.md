# bash-training-0

This is first project due to training bash skills

## AIM

A script to backup configured directories.

### Requirements 
* run once daily
* copy to a folder named for the current day of the week
* keeping 7 daily backups (including the current day) as history 
* either use rsync or tar to perform the actual backup.

### Future Enhancements:
* check for disk space before attempting the backup and pause the script, email an alert to you and then wait until sufficient disk space is available.
* write you a report showing start time, end time and quantity of data copied.
* offer a choice of tar or rsync.
