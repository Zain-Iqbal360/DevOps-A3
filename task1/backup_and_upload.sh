#!/bin/bash




# Timestamp for the backup file name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Backup file name (includes timestamp and database name)
BACKUP_FILE="/home/zain/Desktop/DevOps-A3/task1/DevOps_assignment3_${TIMESTAMP}.sql"

# Backup the database
sudo /usr/bin/mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "DevOps_assignment3" > "$BACKUP_FILE"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Database backup completed successfully."

  # Upload the backup to Google Drive using gdrive
 /home/zain/Desktop/DevOps-A3/task1/gdrive files upload --parent "1rmIKbmb94yTcSs3i3qRw1EjJ4mOwaxiQ" "$BACKUP_FILE"
 
  # Clean up the local backup file
  rm "$BACKUP_FILE"

  echo "Backup file uploaded to Google Drive."
else
  echo "Database backup failed."
fi

