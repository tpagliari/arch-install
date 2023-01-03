#!/bin/bash

# set local time
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen

# set your language and keymap
# replace "totoro" with the name for your machine
# replace "password" with your root password
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=it" >> /etc/vconsole.conf
echo "totoro" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 totoro.localdomain totoro" >> /etc/hosts
echo root:password | chpasswd

# NOTE:
# previously (before the chroot) I have installed these base packages into /mnt :
# # pacstrap /mnt base linux linux-firmware git vim intel-ucode (or amd-ucode)

# base installation
pacman -S \
	grub networkmanager dialog wpa_supplicant mtools dosfstools \
	base-devel linux-headers avahi xdg-utils xdg-user-dirs gvfs gvfs-smb   \
	nfs-utils inetutils dnsutils bluez bluez-utils alsa-utils pipewire pipewire-alsa \
	pipewire-pulse pipewire-jack bash-completion openssh rsync reflector acpi \
	acpi_call tlp bridge-utils dnsmasq openbsd-netcat iptables-nft ipset firewalld \
	sof-firmware nss-mdns acpid ntfs-3g exfat-utils man-db unzip htop

# choose your gpu
# pacman -S --noconfirm xf86-video-intel
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# replace sda with your disk name, not the partition
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# enable installed services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

# replace "tommipi" with your username
# and "password" with your user password
useradd -m tommipi
echo tommipi:password | chpasswd
echo "tommipi ALL=(ALL) ALL" >> /etc/sudoers.d/tommipi


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
