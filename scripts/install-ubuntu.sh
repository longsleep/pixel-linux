export DEBIAN_FRONTEND=noninteractive

root_partition="/dev/sda7"
boot_partition="/dev/sda6"

apt-get update
apt-get install -y cryptsetup rsync

# Create encrypted root.
echo "Please enter the password for full disc encryption."
cryptsetup luksFormat -q --cipher aes-xts-plain64 --key-size 512 --hash SHA512 --iter-time 20000 $root_partition

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

echo "Manual step ..."
bash

#rsync -ravx --exclude="/proc" --exclude="/dev" --exclude="/sys" --exclude="/tmp" / $rootfs/