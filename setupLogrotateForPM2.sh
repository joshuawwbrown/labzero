#!/bin/bash

pm2 logrotate -u zero

# Define the path of the target file
TARGET_FILE="/etc/logrotate.d/pm2-zero"

# Use a heredoc to write the content into the file
cat << 'EOF' > $TARGET_FILE
/home/zero/.pm2/pm2.log /home/zero/.pm2/logs/*.log {
  su zero zero
  rotate -1
  size 10M
  maxage 400
  missingok
  notifempty
  nocompress
  copytruncate
  dateext
  create 0640 zero zero
  olddir /home/zero/.pm2/logs/old
  createolddir 0750 zero zero
}
EOF

logrotate /etc/logrotate.d/pm2-zero --debug

echo "to rotate now: logrotate /etc/logrotate.d/pm2-zero"
