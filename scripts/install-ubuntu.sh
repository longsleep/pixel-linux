export DEBIAN_FRONTEND=noninteractive

target_disk="/dev/sda"
root_partition="${target_disk}7"
boot_partition="${target_disk}6"

apt-get update
apt-get install -y cryptsetup rsync

# Create encrypted root.
echo
echo "Please enter the password for full disc encryption."
cryptsetup luksFormat -q --cipher aes-xts-plain64 --key-size 512 --hash SHA512 --iter-time 20000 $root_partition

echo
echo "Created encrypted disk, provide the password again to open it."
cryptsetup luksOpen $root_partition root

echo "Creating file system in encrypted disk"
mkfs.ext4 /dev/mapper/root

echo "Creating boot file system"
mkfs.ext2 $boot_partition

rootfs="/tmp/rootfs"

mkdir -p $rootfs

mount /dev/mapper/root $rootfs
mkdir -p $rootfs/boot
mount $boot_partition $rootfs/boot

echo "Syncing minimal system to encrypted disc ..."
rsync -rax --exclude="/proc" --exclude="/dev" --exclude="/sys" --exclude="/tmp" --exclude="/install-ubuntu.sh" / $rootfs/

mkdir $rootfs/proc
mkdir $rootfs/dev
mkdir $rootfs/sys
mkdir $rootfs/tmp

mount -o bind /proc $rootfs/proc
mount -o bind /dev $rootfs/dev
mount -o bind /dev/pts $rootfs/dev/pts
mount -o bind /sys $rootfs/sys

bootuuid=`blkid -s UUID -o value ${boot_partition}`
echo "Boot UUID $bootuuid"

rootuuid=`blkid -s UUID -o value ${root_partition}`
echo "Root UUID $rootuuid"

cd $rootfs

echo "Creating crypttab ..."
cat > etc/crypttab << EOF
root UUID=$rootuuid none  luks,discard
EOF

echo "Creating fstab ..."
cat > etc/fstab << EOF
/dev/mapper/root  /       ext4  errors=remount-ro       0 1
UUID=$bootuuid    /boot   ext2  defaults                0 2
tmpfs             /tmp    tmpfs nodev,nosuid,mode=1777  0 0
EOF

echo "ubuntu" > etc/hostname

echo -e "export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y dist-upgrade
apt-get -y install ubuntu-minimal
apt-get -y install wget
apt-get -y install software-properties-common
add-apt-repository main
add-apt-repository universe
add-apt-repository restricted
add-apt-repository multiverse
apt-get update
apt-get -y install linux-generic
apt-get -y install grub-pc
grub-mkconfig -o /boot/grub/grub.cfg
grub-install ${target_disk} --force
useradd -m user -s /bin/bash
echo user | echo user:user | chpasswd
adduser user adm
adduser user sudo
" > third_stage
chmod a+x third_stage

chroot $rootfs /bin/bash -c /third_stage

echo "Check the created system now."
bash

echo "Cleaning up ..."
rm -f usr/sbin/policy-rc.d
umount -l $boot_partition
umount -l $rootfs/proc
umount -l $rootfs/dev/pts
umount -l $rootfs/dev
umount -l $rootfs/sys

sleep 2

umount -l $rootfs

sleep 2

cryptsetup luksClose root

echo "Installation complete."
