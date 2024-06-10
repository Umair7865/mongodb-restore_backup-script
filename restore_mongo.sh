#!/bin/bash

# MongoDB connection details
DATABASE="database_name"

# Directory containing backup JSON files
BACKUP_DIR="/home/user_name/mongodb-backups"

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  echo "Backup directory $BACKUP_DIR does not exist."
  exit 1
fi

# Restore each collection
for file in "$BACKUP_DIR"/*.json; do
  if [ -f "$file" ]; then
          # Extract collection name by removing the database name and file extension (i.e: when you export collections your file name will be 
          # look like this <databaseName>.<collectionName>.json this script will remove <databaseName> and create collection with only collection name)
          filename=$(basename "$file")
          collection_name="${filename#*.}"
          collection_name="${collection_name%.json}"
    echo "Restoring collection: $collection_name from file: $file"
    mongoimport --jsonArray  --db="$DATABASE" --collection="$collection_name" --file="$file" 
    echo " "
  else
    echo "No JSON files found in $BACKUP_DIR"
  fi
done

echo "Restoration complete."
