#!/sbin/sh

### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup

properties() { '
kernel.string=Lalap0s GKI 5.10 
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=zeus
device.name2=cupid
device.name3=diting
device.name4=mayfly
supported.versions=
supported.patchlevels=
'; }

### AnyKernel install

attributes() {
  set_perm_recursive 0 0 755 644 $RAMDISK/*
  set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin
}

## boot shell variables

BLOCK=boot
IS_SLOT_DEVICE=1
RAMDISK_COMPRESSION=auto
PATCH_VBMETA_FLAG=auto

# Import AnyKernel3 core
. tools/ak3-core.sh

attributes

##############################################################################
# AlphaCore Installer
##############################################################################

ui_print " "
cat "$AKHOME/banner"
ui_print " "

DEVICE="$(getprop ro.product.device 2>/dev/null)"
[ -z "$DEVICE" ] && DEVICE="Unknown"

SLOT_NAME="${SLOT#_}"
[ -z "$SLOT_NAME" ] && SLOT_NAME="N/A"

ui_print "Device : $DEVICE"
ui_print "Slot   : $SLOT_NAME"
ui_print " "

##############################################################################
# Device Verification
##############################################################################

ui_print "[1/5] Verifying device..."

case "$DEVICE" in
    zeus|cupid|diting|mayfly)
        ui_print "Supported device detected."
        ;;
    *)
        ui_print " "
        ui_print "ERROR: Unsupported device!"
        ui_print "Device: $DEVICE"
        abort "Installation aborted."
        ;;
esac

ui_print " "

##############################################################################
# Boot Image
##############################################################################

ui_print "[2/5] Dumping boot image..."
dump_boot

ui_print "[3/5] Patching boot image..."

# AlphaCore Image-only installer.
# No DTBO modification is performed.

ui_print "[4/5] Flashing boot image..."
write_boot

##############################################################################
# Finalize
##############################################################################

ui_print "[5/5] Finalizing..."

ui_print " "
ui_print "====================================="
ui_print "  installation completed!"
ui_print " Device : $DEVICE"
ui_print " Slot   : $SLOT_NAME"
ui_print " "
ui_print " Please reboot your device."
ui_print "====================================="
ui_print " "

## end boot install
