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
git clone https://github.com/MinecraftServerControl/mscs.git
make -C mscs install

# Copy worlds to mscs directory
mv worlds/ /opt/mscs/worlds/

# Install forge server
wget -P /opt/mscs/server \
    https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.12.2-14.23.5.2854/forge-1.12.2-14.23.5.2854-installer.jar
cd /opt/mscs/server
java -jar forge-1.12.2-14.23.5.2854-installer.jar --installServer
cd $CUR_DIR

# Update mscs so it picks up the added words
mscs force-update
