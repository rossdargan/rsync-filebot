FROM rednoah/filebot
MAINTAINER Ross Dargan

# Add the fxleblanc user
#RUN useradd -ms /bin/bash fxleblanc

RUN apt-get update \
    && apt-get install -y rsync openssh-client sudo cron

# Add fxleblanc as sudo
#RUN echo 'fxleblanc ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Transfer entrypoint script
ADD entry.sh /usr/bin/entry

# Change ownership make it executable
#RUN chown fxleblanc:fxleblanc /usr/bin/entry

# Switch to user fxleblanc
#USER fxleblanc

#RUN touch /home/fxleblanc/rsync.log
#RUN touch /home/fxleblanc/filebot.log


# Change working directory
WORKDIR /var/

# Entrypoint script
ENTRYPOINT ["/usr/bin/entry"]
