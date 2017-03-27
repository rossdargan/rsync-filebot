# rsync-filebot

# Goal
This allows you to combine an rsync script with a filebot extraction. Very useful to sync data from a VPS then extract and place it in the correct place

# Thanks
## Filebot
Thanks to @rednoah for filebot, and the base image I use: [Filebot](https://hub.docker.com/r/rednoah/filebot/). Also for being really patient with my silly questions!

Remember to donate to his project here if you find it useful: [Donate here](https://www.filebot.net/forums/viewtopic.php?t=2079)

## Rsync-vps
Secondly massive thanks to @fxleblanc for solving most of the tricky rsync stuff for me wioth his base image: https://github.com/fxleblanc/rsync-vps 

I've also "borrowed" most of his config stuff from below since the majority of my image is based on his.

# Usage

## Prerequisites
In order for the image to build, you will need a few files that you need to put in the apptly named secret folder. This folder is not tracked by git as it will contain sensitive information

### An ssh keypair
The user will access the remote location using these keys. So, you need to have the remote already setup to accept the public key. Here is the structure:
```
ssh/id_rsa
ssh/id_rsa.pub
```

### An ssh config
This is mainly to avoid being bothered by the yes/no question when accessing a remote location for the first time. The file will named like config and must be in the secret directory
```
ssh/config
```
As for the contents of the file, it could look like this:
```
Host remote
     StrictHostKeyChecking no
     IdentityFile ~/.ssh/id_rsa
```

### A cron file
This file is, you guessed it, used by the cron daemon to execute your task. Here is the structure
```
cron/sync
```
And for the contents, here is an example
```
* * * * * /usr/bin/rsync remote://path/to/folder /var/data
```

#### Note
- The cron file must be named sync(see entry.sh).
- You can change the path of your data folder(here /var/data) but make sure you map your volumes correctly afterwards(See Volume mapping)
- As a tip you might want to surround your code with a lock file to prevent schedule jobs bumping into each other:
`*/15 * * * *   LOCKFILE=whatever; [ ! -f $LOCKFILE ] && (touch $LOCKFILE && /var/scripts/script.sh ; rm $LOCKFILE)`

#### See also
https://askubuntu.com/questions/123072/ssh-automatically-accept-keys

## Building the container
This is a no-brainer. You just build the image using
```
docker build -t rsync-vps:latest .
```

### Filebot
Place your filebot script in the scripts folder, and get your cron job to call it. Filebot is a beast, but you can call it from a script as it's fully installed. See here https://www.filebot.net/forums/viewtopic.php?t=215 to see how to configure it.

## Running the container

### Volume mapping
To use this image, you need to map four folders:
  - "/mnt/rsync-vps/ssh:/var/ssh" 
  - "/mnt/rsync-vps/cron:/var/cron" 
  - "/mnt/rsync-vps/scripts:/var/scripts" 
  - "/mnt/rsync-vps/logs:/var/logs" 
  
  You will also want to mount the volumes for the filebot outputs.
  
  The container will output all the logs from the /var/logs folder. 

