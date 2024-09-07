#!/usr/bin/bash
pacstrap /mnt base linux-lts linux-firmware sudo git grub efibootmgr bluez bluez-utils blueman pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol nano vim neovim firefox xorg xorg-init xorg-server man-db man-pages htop wget curl openssh unzip zip tar bash-completion
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/Africa/Cairo /etc/localtime
hwclock --systohc
date
echo "arch" > /etc/hostname
cat "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarch" >> /etc/hosts
echo "Set Root Password"
passwd
systemctl enable NetworkManager
grub-install -o /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m -G wheel -s /bin/bash username
visudo
exit #exit from arch-chroo
umount -R /mnt # unount partations
rebootS