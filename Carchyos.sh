#!/bin/bash
echo "Creating mount directories in /run/media/veprovina/"
#Make new directories as mount points for fstab (uncomment below)
mkdir -p /run/media/veprovina/Data
mkdir -p /run/media/veprovina/Storage
mkdir -p /run/media/veprovina/HDD

echo "Adding drive UUIDs to /etc/fstab"
#Makes new line at the end of file - for /etc/fstab
cat <<EOF >> /etc/fstab
#UUID=aec80632-bb29-4282-a90f-0c02c3e8e065 /run/media/veprovina/Data	btrfs		defaults	0 2
#UUID=84450caa-b81b-4af4-96e0-e9e3e2d869a7 /run/media/veprovina/Storage	ext4		defaults	0 2
#UUID=B268988D689851C9			  /run/media/veprovina/HDD	ntfs-3g		defaults	0 2
EOF

echo "Mounting drives and reloading systemctl"
sudo mount -a
sudo systemctl daemon-reload

echo "Creating dualsense udev rule to disable touchpad acting as a mouse"
#Makes new file with exact lines - for /etc/udev/rules.d/72-dualsense.rules
cat <<EOF > /etc/udev/rules.d/72-dualsense.rules
# Disable DS4 touchpad acting as mouse
# USB
ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
# Bluetooth
ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

echo "Updating pacman before package installation"
sudo pacman -Syu

echo "Executing cachyos-repo.sh script to add CachyOS repositories to Arch Linux"
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd ..

echo "Updating pacman and installing packages"
#Package manager, install software (replace with distro specific package manager syntax)
sudo pacman -S cosmic

echo "Done!"
