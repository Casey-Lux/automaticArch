#!/bin/bash

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