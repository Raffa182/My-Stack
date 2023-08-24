# New Volume Group - Logical Group (Linux)

# Check the current scenario

lsblk

# Initialize disk

for disk in `ls /dev/sde` ; do sgdisk -o $disk; sgdisk -n 1::0 -t 1:8e00 $disk; pvcreate "$disk""1" ; done

# VG Creation

vgcreate sapimportvg /dev/sde1

# LV Creation with 90% Free

lvcreate -l 90%FREE -n sapimportlv sapimportvg

# XFS Filesystem

mkfs.xfs /dev/mapper/sapimportvg-sapimportlv

# Creation of Directory

mkdir -p /sapimport

#lvdisplay -m /dev/mapper/sapimportvg-sapimportlv

# Adding to FSTAB information related new vg lg

cat << EOF >> /etc/fstab
/dev/mapper/sapimportvg-sapimportlv /sapexport xfs defaults,relatime 0 0
EOF

# Mount Partition

mount -a

# Check

df -h