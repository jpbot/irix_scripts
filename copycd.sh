#!/bin/sh
# DEBUGVERBOSE=YES
# DEBUGTESTONLY=YES
VERBOSE=YES

ERROR=0

# Need to have a destination provided
if [ "$1" = "" ]
then
  echo "No destination provided."
  exit 1
fi

# check for mounted CDROM
CDDEV=`mount | grep 'on /CDROM type ' | awk  '{print $1 ; }'`

if [ "$CDDEV" = "" ]
then
  echo "No CD mounted."
  exit 1
fi

# Build the device path/names
RCDDEV=`echo $CDDEV|sed 's/dev\/dsk/dev\/rdsk/'`
SLICE=`echo $CDDEV|awk '{print substr($0,length($0)-1,2)}'`
if [ "$SLICE" = "ol" ]
then
  # mounted the vol instead of s7 device, no slice on this disc
  # Some CDs don't have a Slice 7, at least the IRIX 6.5 Base Documentation CD
  VOL=$CDDEV
  SLICE=
  VH=`echo $RCDDEV|awk '{print substr($0,1,length($0)-3)}'`vh
else
  VOL=`echo $CDDEV|awk '{print substr($0,1,length($0)-2)}'`vol
  SLICE=$CDDEV
  VH=`echo $RCDDEV|awk '{print substr($0,1,length($0)-2)}'`vh
fi

# Build the output files
CPDIR=$1
DDVOL=$1_vol.dd
DDVH=$1_rvh.dd
if [ "$SLICE" != "" ]
then
  DDSL=$1_`echo $SLICE|awk '{print substr($0,length($0)-1,2)}'`.dd
else
  DDSL=
fi

# DEBUG INFORMATION
if [ "$DEBUGVERBOSE" = "YES" ]
then
  echo "=BEGIN=========== DEBUG INFORMATION ================="
  if [ "$SLICE" != "" ]
  then
    echo "SLICE: $SLICE"
  fi
  echo "  VOL: $VOL"
  echo "   VH: $VH"
  echo -n "\n"
  echo "CPDIR: $CPDIR"
  echo "DDVOL: $DDVOL"
  echo " DDVH: $DDVH"
  if [ "$SLICE" != "" ]
  then
    echo " DDSL: $DDSL"
  fi
  echo "=END============= DEBUG INFORMATION ================="
fi

for file in $DDVH $DDSL $DDVOL $CPDIR
do
  if [ -e $file ]
  then
    echo "Destination '$file' exists."
    ERROR=`expr $ERROR + 1`
  fi
done

if [ $ERROR -gt 0 ]
then
  exit $ERROR
fi

# DEBUG INFORMATION
if [ "$DEBUGVERBOSE" = "YES" ]
then
  echo -n "\n"
  echo "=================== DEBUG WORK LIST ================="
  echo "mkdir $CPDIR"
  echo "cp -R /CDROM/* $CPDIR"
  echo "umount /CDROM"
  echo "dd if=$VOL of=$DDVOL bs=512"
  if [ "$SLICE" != "" ]
  then
    echo "dd if=$SLICE of=$DDSL bs=512"
  fi
  echo "dd if=$VH of=$DDVH bs=512"
  echo "=====================================================\n"
fi

# DEBUG TEST ONLY
if [ "$DEBUGTESTONLY" = "YES" ]
then
  exit 0
fi

if [ "$VERBOSE" = "YES" ]; then echo "mkdir $CPDIR"; fi
mkdir $CPDIR

if [ "$VERBOSE" = "YES" ]; then echo "cp -R /CDROM/* $CPDIR"; fi
cp -R /CDROM/* $CPDIR

if [ "$VERBOSE" = "YES" ]; then echo "umount /CDROM"; fi
umount /CDROM

if [ "$VERBOSE" = "YES" ]; then echo "dd if=$VOL of=$DDVOL bs=512"; fi
dd if=$VOL of=$DDVOL bs=512

if [ "$SLICE" != "" ]
then
  if [ "$VERBOSE" = "YES" ]; then echo "dd if=$SLICE of=$DDSL bs=512"; fi
  dd if=$SLICE of=$DDSL bs=512
fi

if [ "$VERBOSE" = "YES" ]; then echo "dd if=$VH of=$DDVH bs=512"; fi
dd if=$VH of=$DDVH bs=512
