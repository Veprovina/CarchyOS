#!/bin/bash

CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}Updating pacman and installing CachyOS repositories${NC}"
sudo pacman -Syu

echo -e "${CYAN}Executing cachyos-repo.sh script to add CachyOS repositories to Arch Linux${NC}"
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd /home/veprovina/

echo -e "${CYAN}Installing packages${NC}"
#Package manager, install software (replace with distro specific package manager syntax)
sudo pacman -S ntfs-3g cosmic linux-cachyos-bore linux-cachyos-bore-headers limine-mkinitcpio-hook
sudo systemctl enable cosmic-greeter.service

echo -e "${CYAN}Creating mount directories in /run/media/veprovina/${NC}"
#Make new directories as mount points for fstab (uncomment below)
sudo mkdir -p /run/media/veprovina/Data
sudo mkdir -p /run/media/veprovina/Storage
sudo mkdir -p /run/media/veprovina/HDD

echo -e "${CYAN}Adding drive UUIDs to /etc/fstab${NC}"
#Makes new line at the end of file - for /etc/fstab
cat <<EOF >> /etc/fstab
#UUID=aec80632-bb29-4282-a90f-0c02c3e8e065 /run/media/veprovina/Data	btrfs		defaults	0 2
#UUID=84450caa-b81b-4af4-96e0-e9e3e2d869a7 /run/media/veprovina/Storage	ext4		defaults	0 2
#UUID=B268988D689851C9			  /run/media/veprovina/HDD	ntfs-3g		defaults	0 2
EOF

echo -e "${CYAN}Mounting drives and reloading systemctl${NC}"
sudo mount -a
sudo systemctl daemon-reload

echo -e "${CYAN}Creating dualsense udev rule to disable touchpad acting as a mouse${NC}"
#Makes new file with exact lines - for /etc/udev/rules.d/72-dualsense.rules
cat <<EOF > /etc/udev/rules.d/72-dualsense.rules
# Disable DS4 touchpad acting as mouse
# USB
ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
# Bluetooth
ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

#Adding user to groups
#sudo usermod -aG additional_groups username

echo -e "${CYAN}Done!${NC}"
