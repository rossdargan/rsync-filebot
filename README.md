# rsync-filebot
Allows you to configure a sync with a remote server, then execute filebot

Firstly, huge thanks to http://www.filebot.net/ for providing the base docker image: https://hub.docker.com/r/rednoah/filebot/

Secondly massive thanks to fxleblanc for solving most of the tricky rsync stuff for me wioth his base image: https://github.com/fxleblanc/rsync-vps 


# Goal
This image is mainly intended to sync a remote folder in designated volume. However, this image is somewhat flexible so feel free to experiment.

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

#### See also
https://askubuntu.com/questions/123072/ssh-automatically-accept-keys

## Building the container
This is a no-brainer. You just build the image using
```
docker build -t rsync-vps:latest .
```

## Running the container

### Volume mapping
To use this image, you need to map three folders:
- /path/to/ssh/folder:/home/fxleblanc/.ssh
- /path/to/cron/folder:/home/fxleblanc/cron
- /path/to/data/folder:/var/data

# Troubleshooting

## Bad owner or permissions on .ssh/config
Assuming you are in the cloned repository directory, run:
```
chmod 600 ssh/config
```

### See also
https://serverfault.com/questions/253313/ssh-hostname-returns-bad-owner-or-permissions-on-ssh-config
