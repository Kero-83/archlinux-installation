# Arch Linux Installation Guide

## 1- Wifi Connection

- Using `iwctl`

``` bash
iwctl
device list
station wlan0 get-networks
station wlan0 connect wifiName
ping www.google.com
```

## 2- Check if your computer have UEFI or BIOS

- If you have BIOS, Output will look like this

```bash
ls /sys/firmware/efi/efivars
file or directory does not exist
```

## 3- Partationing

### UEFI

- Run to enter the partition manager (if a menu shows up, choose GPT option)

```bash
cfdisk
```

- Basic partitions

| Partition | Size              | Id Type          |
| --------- | ----------------- | ---------------- |
| BOOT      | 512M              | EFI System       |
| SWAP      | Double RAM        | Linux swap       |
| SYSTEM    | Rest of your GB   | Linux filesystem |

#### Format (UEFI)

```bash
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon
```

#### Mount (UEFI)

```bash
mount /dev/sda3 /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
```

### BIOS

- Run to enter the partition manager (if a menu shows up, choose DOS option)

```bash
cfdisk
```

- Basic partitions

| Partition | Type     | Size              | Id Type          |
| --------- | -------- | ----------------- | ---------------- |
| BOOTEABLE | Primary  | 512M              | 83 Linux         |
| SWAP      | Primary  | Double RAM        | 82 Linux swap    |
| SYSTEM    | Primary  | Rest of your GB   | 83 Linux         |

#### Format (BIOS)

```bash
mkfs.ext2 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2
```

#### Mount (BIOS)

```bash
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

## 4- Packages Installation

- First install archlinux-keyring
### Archlinux-Keyring
```bash
pacman -Syy archlinux-keyring
```
- In All installation we will use `pacstrap /mnt pkgs` to install packages in our partations

### Basic Packages

- In My Case, I will install Linux-LTS Kernal you can replace `linux-lts` with Kernal do you like

```bash
pacstrap /mnt base linux-lts linux-lts-headers linux-firmware sudo git
```

### Boot Stuff

- In My Case, I will install GRUB

```bash
pacstrap /mnt grub 
```

- Install this Package if your computer have UEFI

```bash
pacstrap /mnt efibootmgr
```

### Blutooth Stuff

```bash
pacstrap /mnt bluez bluez-utils blueman
```

### Audio Stuff

```bash
pacstrap /mnt pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol
```

### Networking Stuff

```bash
pacstrap /mnt networkmanager openssh dhcpcd wpa_supplicant curl wget netctl
```

### Editors

```bash
pacstrap /mnt nano vim neovim
```

### Browsers

```bash
pacstrap /mnt firefox
```

### Additional (But Recommended)

```bash
pacstrap /mnt man-db man-pages htop unzip zip tar bash-completion xdg-user-dirs
```

### All in One Command

```bash
pacstrap /mnt base linux-lts linux-firmware sudo git grub efibootmgr bluez bluez-utils blueman pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol networkmanager openssh dhcpcd wpa_supplicant curl wget netctl nano vim neovim firefox man-db man-pages htop unzip zip tar bash-completion xdg-user-dirs 
```

## 5- Configuring the System

### Fstab

- Generate an `fstab` file to define how disk partitions, block devices, or remote filesystems should be mounted into the filesystem.

```bash
genfstab -U -p /mnt >> /mnt/etc/fstab
```

### Chroot

Change root into the new system that we just installed.

``` bash
arch-chroot /mnt
```

### Locale

Uncomment the `en_US.UTF-8 UTF-8` line in `/etc/locale.gen` and generate the locale.

```bash
locale-gen
```

Create the `locale.conf` file and set the `LANG` variable accordingly.

```bash
echo "LANG=en_US.UTF-8" > /etc/locale.conf
```

### Time Zone

Set the time zone.

```bash
ln -sf /usr/share/zoneinfo/Africa/City /etc/localtime
```

### Set Local Time

To set the time for the system, run this command:

```bash
hwclock --systohc
```

And check the time:

```bash
date
```

### Hostname

Create the `hostname` file and set the hostname.

```bash
echo "arch" > /etc/hostname
```

You also need to add this name to the `/etc/hosts` file.

```bash
vim /etc/hosts
```

and add the following lines:

```txt
127.0.0.1        localhost
::1              localhost
127.0.1.1        arch
```

### Set the Root Password

```bash
passwd
```

### Enable Network Manager

```bash
systemctl enable NetworkManager
```

#### Install the bootloader

- UEFI

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

- BIOS

```bash
grub-install /dev/sda
```

Generate the `grub` configuration file.

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### Add a New User

- Create a new user.

```bash
useradd -m -G wheel -s /bin/bash username
```

- Set the password for the new user.

```bash
passwd username
```

Give the new user sudo privileges.

Open the `/etc/sudoers` file using the `visudo` command.

```bash
visudo
```

and uncomment the following line:

```txt
%wheel ALL=(ALL) ALL
```

## Reboot

```bash
exit #exit from arch-chroo
umount -R /mnt # unount partations
reboot
```
