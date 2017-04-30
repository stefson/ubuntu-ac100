#!/bin/bash

#### Prepare environment path

export PS1="(chroot)${PS1}"
export PATH=/bin:/usr/bin:/sbin:/usr/sbin
export DEBIAN_FRONTEND=noninteractive

#### Configure networking and timezone

echo '127.0.0.1 localhost' > /etc/hosts
echo '127.0.1.1 oem' >> /etc/hosts
echo 'oem' > /etc/hostname
echo 'Etc/UTC' > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

#### Install packages

apt-get update
apt-get dist-upgrade -yq
apt-get install abootimg alsa-utils cpufrequtils laptop-detect linux-firmware nano ntpdate sudo wget wireless-crda -y
apt-get install xserver-xorg xserver-xorg-input-{evdev,synaptics} xserver-xorg-video-fbdev xdg-user-dirs -y
apt-get install lightdm lightdm-gtk-greeter light-themes ttf-ubuntu-font-family ubuntu-mono -y
apt-get install gnome-session-flashback gnome-applets language-selector-gnome zenity --no-install-recommends -y
apt-get install gnome-{power-manager,system-monitor,terminal} gucharmap network-manager-gnome -y
apt-get install indicator-{applet-complete,application} python-dbus unity-control-center -y
apt-get install eog evince file-roller gedit gnome-{calculator,screenshot,screensaver} midori -y
apt-get install oem-config-gtk sessioninstaller ubiquity-frontend-gtk -y

#### Copy patched or missing files

cp -av /tmp/patch/* /
glib-compile-schemas /usr/share/glib-2.0/schemas/
alsaucm -c tegraalc5632 reset

#### Installing kernel

cd /tmp
dpkg -i linux-image-3.0.27-1-ac100_3.0.27-1.1_armhf.deb
sed -i 's/MODULES=most/MODULES=dep/g' /etc/initramfs-tools/initramfs.conf

#### Configure swap 

echo 'vm.swappiness = 25' >> /etc/sysctl.conf

#### Add user

adduser --disabled-password --gecos "" oem
echo 'oem:oem' | chpasswd
gpasswd -a oem sudo

#### Temporary indicator repos

cat <<'EOF' > /etc/apt/sources.list.d/indicators.list
deb http://ppa.launchpad.net/indicator-brightness/ppa/ubuntu trusty main
deb http://ppa.launchpad.net/yktooo/ppa/ubuntu trusty main 
EOF
apt-get update
apt-get install indicator-brightness indicator-sound-switcher -y --force-yes
rm /etc/apt/sources.list.d/indicators.list
cp /usr/share/icons/ubuntu-mono-dark/mimes/24/playlist-automatic-symbolic.svg /opt/extras.ubuntu.com/indicator-brightness/notification-display-brightness-full.svg

#### Housekeeping

oem-config-prepare
apt-get install flash-kernel -y
apt-get autoremove --purge -y
apt-get autoclean
apt-get clean
exit
