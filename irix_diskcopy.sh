#!/bin/sh 
echo 
echo make sure fx -x has been ran
echo
dvhtool -v get sash /stand/sash
dvhtool -v get ide /stand/ide
dvhtool -v creat /stand/sash sash /dev/rdsk/dks0d2vh
dvhtool -v creat /stand/ide ide /dev/rdsk/dks0d2vh
dvhtool -v list /dev/rdsk/dks0d2vh
mkfs_xfs /dev/rdsk/dks0d2s0   
mkdir /disk2
mount -v /dev/dsk/dks0d2s0 /disk2
cd /disk2
sync
xfsdump -l0 - /dev/rdsk/dks0d1s0 | xfsrestore -p60 - .
sync
rmdir disk2
cd /
sync
sync
umount /disk2
