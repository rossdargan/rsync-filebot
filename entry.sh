#!/bin/sh
#
# Entrypoint script
#


# Start the ssh agent
eval `ssh-agent -s`

#Copy the ssh files into .ssh
mkdir -p /root/.ssh
cp /var/ssh/* /root/.ssh/
chmod 600 /root/.ssh/id_rsa

# Add the keypair
ssh-add /root/.ssh/id_rsa

# Add the cronfile to fxleblanc's cron
crontab cron/sync

#copy cron/sync /etc/cron.d/sync 

# Launch the script once if ONE_SHOT is defined
echo "Starting cron"
cron 
#echo "Following these logs:"
#ls /var/logs/*
#echo "A restart might be needed to follow new logs"
touch /var/log/cron.log
tail /var/log/cron.log -f

