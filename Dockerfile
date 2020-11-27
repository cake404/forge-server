# Docker image to configure a forge 1.12.2 server

FROM ubuntu:20.04

EXPOSE 25565

# Update and install packages
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
        vim \
        default-jre \
        perl \
        libjson-perl \
        libwww-perl \
        liblwp-protocol-https-perl \
        python \
        make \
        wget \
        git \
        rdiff-backup \
        rsync \
        socat \
        iptables

# Configure timezone
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# Install mscs
RUN git clone https://github.com/MinecraftServerControl/mscs.git
RUN make -C mscs install

# Install forge server
RUN wget -P /opt/mscs/server \
    https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2854/forge-1.12.2-14.23.5.2854-installer.jar
RUN cd /opt/mscs/server && java -jar forge-1.12.2-14.23.5.2854-installer.jar --installServer

# Add worlds
COPY worlds/ /opt/mscs/worlds/

# Change ownership
RUN chown -R minecraft:minecraft /opt/mscs

# Change to minecraft user
USER minecraft

# Update mscs so it picks up the added words
RUN mscs force-update

# Start the server
CMD ["/bin/bash", "-c", "mscs start forge && mscs watch forge"]

