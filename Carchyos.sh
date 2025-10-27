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
sudo pacman -S nano bash-completion ntfs-3g cosmic linux-cachyos-bore linux-cachyos-bore-headers limine-mkinitcpio-hook
sudo systemctl enable cosmic-greeter.service

echo -e "${CYAN}Creating mount directories in /run/media/veprovina/${NC}"
#Make new directories as mount points for fstab (uncomment below)
sudo mkdir -p /run/media/veprovina/Data
sudo mkdir -p /run/media/veprovina/Storage
sudo mkdir -p /run/media/veprovina/HDD

echo -e "${CYAN}Adding drive UUIDs to /etc/fstab${NC}"
#Makes new line at the end of file - for /etc/fstab - UNCOMMENT when not in VM
cat <<EOF >> /etc/fstab
#UUID=aec80632-bb29-4282-a90f-0c02c3e8e065      /run/media/veprovina/Data	    btrfs		defaults	0 2
#UUID=84450caa-b81b-4af4-96e0-e9e3e2d869a7      /run/media/veprovina/Storage	ext4		defaults	0 2
#UUID=B268988D689851C9                          /run/media/veprovina/HDD	    ntfs-3g		defaults	0 2
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

#TO DO LIST:
# Add amd-ucode to pacman install after VM testing (https://wiki.archlinux.org/title/Microcode#Limine), as well as any packages to be installed on bare metal - programs, codecs, base-devel etc.
# Add flathub repo as default after pacman package installation (flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo)
# Add yay install script (https://github.com/Jguer/yay)
# Have automatic confirmation for the script queries if possible - fully automated script - default answers for pacman (if applicable)
# Apparmor - install and configure
# Firewall configuration (check if Arch has one by default, otherwise probably ufw)
# Activate NumLock on bootup - maybe - https://wiki.archlinux.org/title/Activating_numlock_on_bootup
# Limine automatic snapshots with snapper - pacman hook
# Add kernel paramters to limine if needed (quiet splash) and configure limine (amd-ucode early loading)
# Add and configure Plymouth
# Configure automatic updates OR update notifications for important packages (kernel, mesa, systemd, etc.) - possible GUI solution for updates, or one-click .desktop file executing an update script
# Possible - add ZSH
# Possible - add bashrc aliases and configure it to show fastfetch when starting
# Configure fastfetch to show a custom logo (WIP)
# Configure TRIM (fstrim.timer)
# Make the script output a postinstall log and save it as a file in the home directory

echo -e "${CYAN}Done!${NC}"
