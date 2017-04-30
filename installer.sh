#!/bin/sh
clear

#### Root check

if [ `id -u` != 0 ]; then
	echo "Please run installation process as root!"
	exit
fi

#### Environment check

if [ "`cat /etc/issue | grep SOSBoot`" == "" ]; then
	echo "Please run installation process from SOSBoot environment!"
	exit
fi

#### Partition check

for partnum in `seq 1 7`
do
	if [ ! -b /dev/mmcblk0p${partnum} ]; then
		echo "Partition #${partnum} missing. Please remove external SD cards or flash factory partition scheme"
		exit
	fi
done

#### Files check

if [ ! -f /mnt/kernel.img ]; then
	echo "Kernel image missing (make sure kernel.img file is present)"
	exit
fi
if [ ! -f /mnt/rootfs.tgz ]; then
	echo "System image missing (make sure rootfs.tgz file is present)"
	exit
fi

#### Confirmation

echo "DO YOU REALLY WANT TO OVERWRITE CURRENT FIRMWARE?"
echo "All data will be erased and Ubuntu files will be copied."
echo "Press ENTER to start, or CTRL+C to reboot."
read

#### Main process

sleep 2

echo "  -->  Preparing swap storage..."
mkswap /dev/mmcblk0p4 > /dev/null

echo "  -->  Preparing root storage..."
mkfs.ext4 /dev/mmcblk0p7 > /dev/null
mkdir /target
mount -t ext4 /dev/mmcblk0p7 /target

echo "  -->  Copying system files..."
cd /target
gunzip < /mnt/rootfs.tgz | tar xpf -

echo "  -->  Copying kernel image..."
dd if=/mnt/kernel.img of=/dev/mmcblk0p2 > /dev/null

echo "  -->  Housekeeping..."
cd /
sync
umount /target

echo ""
echo "Done. Please remove all external media and then press Ctrl+Alt+Del to reboot."
