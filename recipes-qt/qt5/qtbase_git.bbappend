FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://0001-Double-conversion-add-loongarch-support.patch \
    file://0002-port-qtbase-for-loongarch.patch \
"

DISTRO_FEATURES:remove:loongarch64 = " ptest"