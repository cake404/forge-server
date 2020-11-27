#!/bin/bash

CUR_DIR=$(pwd)

# Update apt
apt-get update

# Install necessary packages
apt-get install -y \
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

# Clone/install the mscs project
git clone https://github.com/MinecraftServerControl/mscs.git /tmp/mscs
make -C /tmp/mscs install

# Install forge server
wget -P /opt/mscs/server \
    https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2854/forge-1.12.2-14.23.5.2854-installer.jar
cd /opt/mscs/server
java -jar forge-1.12.2-14.23.5.2854-installer.jar --installServer
cd $CUR_DIR

# Copy mscs worlds and settings
cp -r mscs/* /opt/mscs/

# Allow minecraft user to own mscs directory
chown -R minecraft:minecraft /opt/mscs

# Update mcsc to pick up worlds
mscs force-update

# Create cronjob for backing up worlds
echo "* */4 * * * minecraft /usr/local/bin/mscs backup" \
    > /etc/cron.d/minecraft_backup

systemctl restart cron