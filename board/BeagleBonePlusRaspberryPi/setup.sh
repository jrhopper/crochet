MYBOARDDIR=${BOARDDIR}
BEAGLEBONE_BOARDDIR=${BOARDDIR}/../BeagleBone
RASPBERRY_PI_BOARDDIR=${BOARDDIR}/../RaspberryPi

. ${BEAGLEBONE_BOARDDIR}/BeagleBone/setup.sh
. ${RASPBERRY_PI_BOARDDIR}/RaspberryPi/setup.sh

# TODO: KERNCONF=GENERIC
KERNCONF=BEAGLEBONE

board_check_prerequisites ( ) (
    BOARDDIR=${BEAGLEBONE_BOARDDIR}
    beaglebone_check_prerequisites
    BOARDDIR=${RASPBERRY_PI_BOARDDIR}
    raspberry_pi_check_prerequisites
)

board_build_bootloader ( ) (
    BOARDDIR=${BEAGLEBONE_BOARDDIR}
    beaglebone_build_bootloader
    BOARDDIR=${RASPBERRY_PI_BOARDDIR}
    raspberry_pi_build_bootloader
)

board_construct_boot_partition ( ) (
    FAT_MOUNT=${WORKDIR}/_.mounted_fat
    disk_fat_create 20m
    disk_fat_mount ${FAT_MOUNT}

    BOARDDIR=${BEAGLEBONE_BOARDDIR}
    beaglebone_populate_boot_partition ${FAT_MOUNT}

    BOARDDIR=${RASPBERRY_PI_BOARDDIR}
    raspberry_pi_populate_boot_partition ${FAT_MOUNT}

    cd ${FAT_MOUNT}
    customize_boot_partition ${FAT_MOUNT}
    disk_fat_unmount ${FAT_MOUNT}
    unset FAT_MOUNT
)

board_customize_freebsd_partition ( ) {
    mkdir $1/boot/msdos
    freebsd_ubldr_copy_ubldr_help $1/boot
}