#!/usr/bin/env bash

# The script below executes the safety net function automatically if you press Ctrl+C
clean_once_canceled() {
echo -e "User has cancelled operation!"

# check if directory variable is set and if it exists
if [ -n "$DIR_NAME" ] && [ -d "$DIR_NAME" ]; then
echo "Running progress as an archive..."
# create a zip/tar of the folder
tar -czf "${DIR_NAME}_archive.tar.gz" "$DIR_NAME"
echo "Clearing incomplete drectory..."

rm -rf "$DIR_NAME"
echo "Cleanup has been completed. Archive saved."

fi

# exits the script 
exit 1
}

# command to activate safety net
trap clean_once_canceled SIGINT

# This builds the input and directory structure
echo "================================================"
echo " Hello, Welcome to Student attendance tracker "
echo "==================================================="

# get the user input for attendance tracker suffix
read -p "Please enter name for attendance_tracker:" USER_INPUT

#create variable for the directory name
DIR_NAME="attendance_tracker_${USER_INPUT}"

# creating the directories
echo "Hang on! creating the directory structure for $DIR_NAME"

if mkdir -p "$DIR_NAME/Helpers" "$DIR_NAME/reports"; then
echo "Great! Directories has been created successfully."
else
echo "Error! something went wrong."
exit 1

fi
