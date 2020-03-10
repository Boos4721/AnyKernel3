# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=PixelKernel by Boos4721 @ xda-developers
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=OnePlus5
device.name2=cheeseburger
device.name3=OnePlus5T
device.name4=dumpling
supported.versions=9,10
'; } # end properties

# shell variables
block=boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

ui_print " "; ui_print "Trimming partitions...";
$bin/busybox/fstrim -v /data

# Clean up other kernels' ramdisk overlay.d files
rm -rf $ramdisk/overlay.d

## AnyKernel file attributes

## AnyKernel install
dump_boot;

# Add our ramdisk files if Magisk is installed
rm -rf /data/adb/modules/Pixel
mkdir -p /data/adb/modules/Pixel
cp -Rf $home/magisk/* /data/adb/modules/Pixel
ui_print "Installing Pixel Kernel Magisk Module"

if [ -d $ramdisk/.backup ]; then
  patch_cmdline "skip_override" "skip_override";
else
  patch_cmdline "skip_override" "";
fi;

# end ramdisk changes

mount -o rw,remount -t auto /system;
ui_print "Installing Sqlite Files..."
cp -rf $home/system/* /system/;
mount -o ro,remount -t auto /system;

write_boot;
## end install

