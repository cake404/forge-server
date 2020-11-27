#!/bin/bash

# Stop all worlds running
mscs stop

# Clone mscs if not currently present
if [ ! -d /tmp/mscs ]; then \
    git clone https://github.com/MinecraftServerControl/mscs.git /tmp/mscs; \
fi

# Run mscs clean target
make -C /tmp/mscs clean

# Delete minecraft user
userdel minecraft

# Remove directories
rm -rf /opt/mscs

# Remove cronjob
rm -rf /etc/cron.d/minecraft_backup