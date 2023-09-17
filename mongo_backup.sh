#!/bin/bash

# Create a new folder to store the backup files
mkdir -p /backup/
echo "Creating backup folder ..."

# change the current directory to usr/bin folder of the container
cd /usr/bin 
echo "💿 Backup started at $(date)"

# if mongodump command is successful echo success message else echo failure message
if mongodump --forceTableScan --uri $MONGODB_URI --username $MONGODB_USERNAME --password $MONGODB_PASSWORD --authenticationDatabase=admin --gzip --archive > /backup/dump_`date "+%Y-%m-%d-%T"`.gz 
then
    echo "Mongo Backup completed successfully at $(date)"
    if s3cmd --access_key=$S3_ACCESS_KEY_ID --secret_key=$S3_SECRET_ACCESS_KEY --host=$S3_HOST --host-bucket=$S3_BUCKET --region=$S3_REGION sync /backup/ s3://$S3_BUCKET --recursive
    then 
        echo "Uploaded to s3 bucket"
    else 
        echo "Upload to s3 bucket failed at $(date)"
    fi 
else
    echo "Backup failed at $(date)"
fi

echo "Cleaning up..."
# Clean up by removing the backup folder
rm -rf /backup/ 

echo "Done"