#!/bin/bash

# Config keys you can change "es" for "en"
loadkeys es

# Rev and creating partition
fdisk -l
#cfdisk /dev/sda

# Variables (adjust as needed)
DISK="/dev/sda"  # Change this to your disk name (e.g., /dev/nvme0n1)
BOOT_SIZE="512"
ROOT_SIZE="20480"   # You can adjust this size between 25G and 40G
RAM_SIZE=$(free -m | awk '/^Mem:/ {print $2}')  # Get RAM size in GB
SWAP_SIZE=$((RAM_SIZE / 2))  # Half of the RAM size
END_DISK="100%"  # The rest of the disk for /home

# Create partitions with parted using MBR (DOS)
parted --script "$DISK" mklabel msdos

# boot partition
parted --script "$DISK" mkpart primary ext2 1MiB ${BOOT_SIZE}MiB
parted --script "$DISK" set 1 boot on

# Swap partition
parted --script "$DISK" mkpart primary linux-swap ${BOOT_SIZE}MiB $((BOOT_SIZE + SWAP_SIZE))MiB

# Root partition
parted --script "$DISK" mkpart primary ext4 $((BOOT_SIZE + SWAP_SIZE))MiB ${ROOT_SIZE}MiB

# Home partition
parted --script "$DISK" mkpart primary ext4 ${ROOT_SIZE}MiB ${END_DISK}MiB

# Format partitions
mkfs.ext2 -F32 "${DISK}1"  # Format /boot as FAT32
mkswap "${DISK}2"         # Setup swap
swapon "${DISK}2"         # Enable swap
mkfs.ext4 "${DISK}3"      # Format / as ext4
mkfs.ext4 "${DISK}4"      # Format /home as ext4

# Mount partitions
mount "${DISK}3" /mnt          # Mount root
mkdir -p /mnt/boot                 # Create boot directory
mount "${DISK}1" /mnt/boot      # Mount boot
mkdir -p /mnt/home                 # Create home directory
mount "${DISK}4" /mnt/home      # Mount home

echo "Partitions created and mounted successfully."
sleep 5

fdisk -l

# Keys
pacman -S archlinux-keyring
pacman-key --init
pacman-key --populate archlinux
#dirmngr (create /root/.gnupg/dirmngr_ldapservers.conf)
dirmngr
pacman-key --refresh-keys

# Programs installation
pacstrap -K /mnt linux linux-firmware sof-firmware base networkmanager dhcpcd nano grub sudo neovim netctl wpa_supplicant dialog man-db man-pages texinfo

# gen partitions tab
genfstab /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# Enter to base system installed
# Copy script into chroot
cp chroot_commands.sh /mnt/root/chroot_commands.sh
chmod +x /mnt/root/chroot_commands.sh
arch-chroot /mnt /root/chroot_commands.sh
