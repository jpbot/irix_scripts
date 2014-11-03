* working path should be source
* destination path specified on cpio command
* -p for passthrough

  find . -depth -print|cpio -pdmv /share/share/others/disk2
