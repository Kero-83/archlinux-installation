#!/usr/bin/bash
pacstrap /mnt base linux-lts linux-firmware sudo git grub efibootmgr bluez bluez-utils blueman pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol networkmanager openssh dhcpcd wpa_supplicant curl wget netctl nano vim neovim firefox man-db man-pages htop unzip zip tar bash-completion xdg-user-dirs
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt <<EOF
sed -i '/"en_US.UTF-8"/s/^#//' filename
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
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
username=""
password1=""
password2=""
while true; do
    read -p "Enter Your Username: " username
    read -s -p "Enter Your Password: " password1
    echo
    read -s -p "Confirm Your Password: " password2
    echo

    if [ "$password1" == "$password2" ]; then
        echo "User Added"
        break
    else
        echo "Passwords do not match, please try again"
    fi 
done
useradd -m -G wheel -s /bin/bash $username
echo "$username:$password1" | chpasswd
visudo
EOF #exit from arch-chroot
umount -R /mnt # unount partations
rebootS