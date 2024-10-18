#!/bin/bash

# Config keys you can change "es" for "en"
loadkeys es

# Rev and creating partition
fdisk -l
#cfdisk /dev/sda

#!/bin/bash

# Variables (adjust as needed)
DISK="/dev/sda"  # Change this to your disk name (e.g., /dev/nvme0n1)
BOOT_SIZE="512"
ROOT_SIZE="20G"   # You can adjust this size between 25G and 40G
RAM_SIZE="$(free -h | awk '/^Mem:/ {print $2}')"  # Get RAM size in GB
SWAP_SIZE=$(echo "$RAM_SIZE / 2" | bc)  # Half of the RAM size
END_DISK="100%"  # The rest of the disk for /home

# Create partitions with parted
parted --script "$DISK" mklabel gpt  # GPT label

# /boot partition
parted --script "$DISK" mkpart primary fat32 1MiB "$BOOT_SIZE"
parted --script "$DISK" set 1 boot on

# Swap partition
parted --script "$DISK" mkpart primary linux-swap "$BOOT_SIZE" "$((BOOT_SIZE + SWAP_SIZE))"

# Root partition
parted --script "$DISK" mkpart primary ext4 "$((BOOT_SIZE + SWAP_SIZE))" "$ROOT_SIZE"

# Home partition
parted --script "$DISK" mkpart primary ext4 "$ROOT_SIZE" "$END_DISK"

# Format partitions
mkfs.fat -F32 "${DISK}1"  # Format /boot as FAT32
mkswap "${DISK}2"         # Setup swap
swapon "${DISK}2"         # Enable swap
mkfs.ext4 "${DISK}3"      # Format / as ext4
mkfs.ext4 "${DISK}4"      # Format /home as ext4

# Mount partitions
mount "${DISK}3" /mnt          # Mount root
mkdir /mnt/boot                 # Create boot directory
mount "${DISK}1" /mnt/boot      # Mount boot
mkdir /mnt/home                 # Create home directory
mount "${DISK}4" /mnt/home      # Mount home

echo "Partitions created and mounted successfully."

fdisk -l

# Keys
pacman -S archlinux-keyring
pacman-key --init
pacman-key --populate archlinux
#dirmngr (create /root/.gnupg/dirmngr_ldapservers.conf)
nohup dirmngr --daemon > /dev/null 2>&1 &
nohup pacman-key --refresh-keys > /dev/null 2>&1 &


# Programs installation
pacstrap -K /mnt linux linux-firmware sof-firmware base networkmanager dhcpcd nano grub neovim netctl wpa_supplicant dialog man-db man-pages texinfo

# gen partitions tab
genfstab /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# Enter to base system installed
arch-chroot /mnt

# Variables (adjust as needed)
HOSTNAME="yourhostname"  # Change this to your desired hostname
TIMEZONE="America/Bogota"  # Change this to your desired timezone
KEYMAP="es"  # Set your keyboard layout
LOCALE="en_US.UTF-8"  # Set the system language locale

# Set hostname
echo "$HOSTNAME" > /etc/hostname
echo "Hostname set to $HOSTNAME."

# Set timezone
ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime
echo "Timezone set to $TIMEZONE."

# Synchronize hardware clock to system time
hwclock -w
echo "Hardware clock synchronized."

# Configure locale (uncomment en_US.UTF-8 UTF-8 in /etc/locale.gen)
sed -i 's/#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo "Locale set to $LOCALE."

# Set system language
echo "LANG=$LOCALE" > /etc/locale.conf
echo "System language set to $LOCALE."

# Configure keymap
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
echo "Keymap set to $KEYMAP."

# Display the current date and time
date
echo "Date and time configuration complete."

# Final message
echo "System configuration for hostname, timezone, locale, and keymap completed."

# install grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# Variables (adjust as needed)
NEW_USER="yourusername"  # Replace with the desired username

# Set the root password
echo "Setting root password..."
passwd root

# Add new user
echo "Creating new user: $NEW_USER"
useradd -m "$NEW_USER"

# Set the new user's password
echo "Setting password for $NEW_USER..."
passwd "$NEW_USER"

# Confirmation message
echo "Password configuration for root and $NEW_USER completed."

# exit from chroot
exit

# umount partitions
umount -R /mnt
reboot