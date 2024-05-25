#!/system/bin/sh

# If you're implementing this in a custom kernel/firmware,
# I suggest you use a different script name, and add a service
# to launch it from init.rc
# By hxzbaka
# Type 64
echo 'Start running shell'

echo 'Start install Magisk'
# Detecting files
if [[ ! -f /data/adb/magisk/magisk64 ]] ; then
    echo 'Magisk file does not exist!'
    exit 0
fi

#Mount read-write
echo 'Mount read-write...'
mount -o rw,remount /
mount -o rw,remount /system

# Preparation environment
echo 'Copying files'
cp -r /data/adb/magisk/* /sbin

#Set up the linked file
echo 'Set up file'
mv /sbin/magisk64 /sbin/magisk
ln -s /sbin/magisk /sbin/resetprop
ln -s /sbin/magisk /sbin/su
mkdir /sbin/.magisk/
mkdir /sbin/.magisk/block
mkdir /sbin/.magisk/mirror
mkdir /sbin/.magisk/worker
touch /sbin/.magisk/config
ln -s /system /sbin/.magisk/mirror/system

#Set permissions
echo 'Set permissions'
chmod 777 /sbin
chmod 777 /sbin/*

#Start Magisk
echo 'Start the Magisk daemon'
/sbin/magisk --post-fs-data
/sbin/magisk --service
/sbin/magisk --boot-complete
/sbin/magisk -v

#Install Magisk End
echo 'Installation completed'
