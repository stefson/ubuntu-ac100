# Porting Ubuntu 14.04 to Toshiba AC100

Ubuntu 14.04, designed and optimized for Toshiba AC100.

These scripts allows you to build up-to-date Ubuntu filesystem and install it to target device. Shipped with minimal GNOME Flashback, but you can build minimal text-mode OS if you want to.

![Overview](https://github.com/nthchild/ubuntu-ac100/raw/master/screen.png)

This OS is stable enough for daily work. Battery should last for up to 8 hours, and suspend is fully supported. Sound works all the time, music is loud and not malformed. 

For web browsing, text processing and other simple tasks, this OS should work better than preinstalled Android.

## Changes I've applied

Compared to official Ubuntu 12.04 port

- Minimal, up-to-date operating system, without bloatware
- (Optional) GNOME Flashback instead of Unity 
- Windows XP-like panel (main menu, quick launch, disk mounter, notifications)
- Enhanced power management (up to 8h battery life!)
- Brightness and output switch indicators
- Working volume hotkeys (use with HOME key)
- Swap (cache partition, reduced swappiness)
- Disabled animations and sound effects
- Disabled tap-to-click feature (makes touchpad more responsive)
- Suspend if power button pressed
- Many little tweaks

## Known issues

- No proprietary graphics drivers - therefore no HDMI output or HW acceleration
- Random kernel panics

## How to build

1. Make sure you're running Ubuntu 14.04
2. Install `debootstrap` and `qemu-user-static` packages
3. Download this repository to your PC
4. As root, execute `./build.sh`

Tip: You can use `time` utility to display how much time the process took (less than 1 hour in most cases), or append `2>&1 | tee log.txt` to save logs. Output file is called `rootfs.tgz`.

## Prepare device

1. Install nvflash DEB package provided here. **Proprietary utility will be downloaded!**
2. If your device is using GPT, please revert to tegrapart.
3. Connect AC100 to PC, press and hold Ctrl+Esc+Power.
4. Execute `nvflash --bl /usr/lib/nvflash/fastboot.bin --download 5 recovery.img --go`

## Install Ubuntu

1. Copy three files to FAT32-formatted flash memory
   - `installer.sh`
   - `kernel.img`
   - `rootfs.tgz`
2. Boot device with HOME key pressed. If prompted, press 1.
3. Mount USB device: `mount -t vfat /dev/sda1 /mnt`
4. Start installer and follow instructions: `sh /mnt/installer.sh`
5. Reboot device, wait 1-2 minutes to see setup wizard and finish installation.

## Additional resources

Without them, I wouldn't be able to create this project

- https://wiki.ubuntu.com/ARM/TEGRA/AC100 (Ubuntu 12.04 port)
- https://help.ubuntu.com/community/Installation/FromLinux (Debootstrap guide)
- https://launchpad.net/~indicator-brightness/+archive/ubuntu/ppa (Brightness indicator)
- https://launchpad.net/~yktooo/+archive/ubuntu/ppa (Sound switcher indicator)
- https://ac100.grandou.net (Manuals, SOSBoot recovery environment)
- http://packages.ubuntu.com/trusty/ubuntu-gnome-default-settings (Example configuration files)
- http://askubuntu.com/questions/65900/how-can-i-change-default-settings-for-new-users (DConf tutorial)
- http://packages.trisquel.info/belenos/gnome-panel-data (Example panel config)
- https://trisquel.info/en/wiki/oem-installation (oem-config tutorial)
- and many others

## Changelog

### 2017-02-07

- Graphical setup wizard during first boot

### 2016-09-20

- GNOME MPlayer and GNOME Disks won't be installed

### 2016-05-14

- Now `mplayer` will be used instead of `mplayer2`, for better multimedia support
- Now swappiness should be set up correctly. I've just forgotten 14.04 may not support `sysctl.d` yet.

### 2016-05-10

- Removed LibreOffice, because you may want to try AbiWord and Gnumeric instead. This can greatly reduce filesystem usage if you don't use office suites at all.

### 2016-05-08

- First release
