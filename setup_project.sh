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

echo "Getting files...."
# Create the python script
cat << 'EOF' > "$DIR_NAME/attendance_checker.py"
import csv
import json
import os
from datetime import datetime
def run_attendance_check():
# 1. Load Config
with open('Helpers/config.json', 'r') as f:
config = json.load(f)
# 2. Archive old reports.log if it exists
if os.path.exists('reports/reports.log'):
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
os.rename('reports/reports.log',
f'reports/reports_{timestamp}.log.archive')
# 3. Process Data
with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log',
'w') as log:
reader = csv.DictReader(f)
total_sessions = config['total_sessions']
log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
for row in reader:
name = row['Names']
email = row['Email']
attended = int(row['Attendance Count'])
# Simple Math: (Attended / Total) * 100
attendance_pct = (attended / total_sessions) * 100
message = ""
if attendance_pct < config['thresholds']['failure']:
message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}
%. You will fail this class."
elif attendance_pct < config['thresholds']['warning']:
message = f"WARNING: {name}, your attendance is
{attendance_pct:.1f}%. Please be careful."
if message:
if config['run_mode'] == "live":
log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}
\n")
print(f"Logged alert for {name}")
else:
print(f"[DRY RUN] Email to {email}: {message}")
if __name__ == "__main__":
run_attendance_check()
EOF

# create config file
cat << EOF > "$DIR_NAME/Helpers/config.json"
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF

# create the assests file
cat << EOF > "$DIR_NAME/Helpers/assests.csv"
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF

# create log file
cat << EOF > "$DIR_NAME/reports/reports.log"
--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your
attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie
Davis, your attendance is 26.7%. You will fail this class.
EOF

# Configure Settings
echo " Configuration Setup "

read -p "Update the attendance thresholds now? (y/n): " UPDATE_CONF

if [[ "$UPDATE_CONF" == "y" || "$UPDATE_CONF" == "Y" ]]; then

# get new values from the user
read -p "Please enter WARNING threshold (e.g., 85):" NEW_WARN
read -p "Please enter FAILURE threshold (e.g., 50):" NEW_FAIL

echo "Applying changes to the configuration file....."

# Update WARNING threshold
sed -i "s/\"warning\": [0-9]*/\"warning\": $NEW_WARN/" "$DIR_NAME/Helpers/config.json"

# Update FAILURE threshold
sed -i "s/\"failure\": [0-9]*/\"failure\": $NEW_FAIL/" "$DIR_NAME/Helpers/config.json"

echo "Great! Configuration updated"
else
echo "Using default configuration settings"

fi

# Health Checker
echo " System Health Check "
# check if python 3 is installed
if command -v python3 &> /dev/null; then
echo -n " Python 3 found: "
python3 --version
else
echo "WARNING!! Python 3 is NOT installed"
echo " Must have python to run this application "
fi

# confirm the directory structure exists
if [ -f "$DIR_NAME/attendance_checker.py" ] && [ -f "$DIR_NAME/Helpers/config.json" ]; then
echo "Great! Tracker '$DIR_NAME' is ready"
echo " Location: $(pwd)/$DIR_NAME "
else
echo "ERROR! setup NOT completed"
exit 1

fi
