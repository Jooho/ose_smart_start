#!/bin/bash

usage() {
  echo "USAGE: "
  echo "$0 <lv name> <size of LV in GIG>"
  echo "$0 lv_ose02 1"
  echo
  exit 9
}

if [ $# -ne 2 ]; then usage; fi
LVNAME=$1
SIZE=$2
VG=vg_osenfs

lvcreate -L${SIZE}g -n${LVNAME} $VG
mkfs.xfs /dev/mapper/${VG}-${LVNAME}
echo "/dev/mapper/${VG}-${LVNAME} /exports/${LVNAME} xfs defaults 1 2 " >> /etc/fstab
mkdir /exports/${LVNAME}
chmod 777 /exports/${LVNAME}/
chown nfsnobody:nfsnobody /exports/${LVNAME}/
mount -a

echo " /exports/${LVNAME} (rw,root_squash)  " >> /etc/exports
#echo " /exports/${LVNAME}" >> /etc/exports
#for IP in `seq 11 18`; do echo -e "10.162.123.${IP}(rw,root_squash)"; done >> /etc/exports
exportfs -a

