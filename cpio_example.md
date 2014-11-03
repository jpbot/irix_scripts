* working path should be source
* destination path specified on cpio command
* the -p is for passthrough

```
find . -depth -print|cpio -pdmv /share/share/others/disk2
```
