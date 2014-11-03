irix_scripts
============

Shell Script and hints for IRIX

---

#####copycd.sh#####
Script to copy CD from optical drive to a directory and copy the blocks into a file with dd which may be able to be written back out to a burnable CD.

---

#####irix_diskcopy.sh#####
Clone a XFS volume and some files from the volumeheader. Used to copy a 'rootdrive'.

Consider a hint only. Some adjustment will be necessary for 'optiondrive' or custom layout. As is copies slice 0 from scsi id 1 on controller 0 to freshly made XFS file system on a disk which has already been laid out with a slice 0 on scsi id 2, controller 0.

This has been seen in many other places.
