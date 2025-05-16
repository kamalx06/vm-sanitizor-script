#!/bin/bash

echo "If you run this code please change username of it to your username's home directory, also this code will work only in Debian based systems"

# 1. Clear shell history
echo "Clearing shell history..."
rm -f /home/debian/.bash_history /home/debian/.zsh_history /home/debian/.python_history
history -c

# 2. Clear root history
rm -f /home/debian/.bash_history /home/debian/.zsh_history /home/debian/.python_history
if [ "$(id -u)" -eq 0 ]; then
    rm -f /root/.bash_history
else
    sudo rm -f /root/.bash_history
fi

# 3. Clear logs
echo "Clearing system logs..."
sudo journalctl --rotate
sudo journalctl --vacuum-time=1s
sudo find /var/log -type f -delete
sudo rm -rf /var/tmp/*

# 4. Clean apt cache
echo "Cleaning apt cache..."
sudo apt clean
sudo apt autoclean
sudo apt autoremove --purge -y

# 5. Remove user files
echo "Removing user directories..."
rm -rf /home/debian/Downloads/* /home/debian/Documents/* /home/debian/Pictures/* /home/debian/Videos/* /home/debian/Desktop/* /home/debian/Templates/* /home/debian/Music/*
rm -rf /root/Downloads/* /root/Documents/* /root/Pictures/* /root/Videos/* /root/Desktop/* /root/Templates/* /root/Music/*

# 6. Remove browser and cache data
echo "Removing browser and cache data..."
rm -rf /home/debian/.mozilla/ /home/debian/.cache/ /home/debian/.config/google-chrome/ /home/debian/.config/chromium/
rm -rf /root/.mozilla/ /root/.cache/ /root/.config/google-chrome/ /root/.config/chromium/

# 7. Remove SSH and DHCP info
echo "Removing SSH and DHCP data..."
rm -f /home/debian/.ssh/known_hosts
rm -f /root/.ssh/known_hosts
sudo rm -f /etc/ssh/ssh_host_*
sudo rm -f /var/lib/dhcp/*

# 8. Reset machine ID
echo "Resetting machine-id..."
sudo rm -f /etc/machine-id
sudo systemd-machine-id-setup

# 9. Clear bash profile and logout traces
echo "Wiping profile scripts..."
rm -f /home/debian/.bash_logout /home/debian/.bashrc /home/debian/.profile
touch /home/debian/.bashrc /home/debian/.profile /home/debian/.bash_logout
rm -f /root/.bash_logout /root/.bashrc /root/.profile
touch /root/.bashrc /root/.profile /root/.bash_logout

# 10. Reset hostname
echo "Resetting hostname..."
sudo hostnamectl set-hostname debian

# 11. Sync disk and notify
sync
echo "Sanitization complete. It's safe to shut down the VM now."
