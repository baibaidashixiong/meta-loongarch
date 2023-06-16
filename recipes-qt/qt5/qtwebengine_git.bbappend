FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE:loongarch64 = "(.*)"

DEPENDS:remove:loongarch64 = " \
    nodejs-native \
"

DEPENDS += " \
    lcms \
"

SRC_URI = " \
    https://pkg.loongnix.cn/loongnix/pool/main/q/qtwebengine-opensource-src/qtwebengine-opensource-src_5.15.2+dfsg.orig.tar.xz \
    file://run-unbundling-script.patch \
    file://system-lcms2.patch \
    file://system-nspr-prtime.patch \
    file://system-icu-utf.patch \
    file://verbose-gn-bootstrap.patch \
    file://mipsel-linux-5.patch \
    file://mipsel-ptrace-include.patch \
    file://mipsel-no-dav1d.patch \
    file://mipsel-link-atomic.patch \
    file://sandbox-time64-syscalls.patch \
    file://mipsel-code-range-size.patch \
    file://0001-port-chromium_qt-to-loongarch64.patch \
    file://0002-fix-third_party-for-loongarch64.patch \
    file://0003-port-breakpad-for-loongarch64.patch \
    file://0004-port-ffmpeg-to-loongarch64-for-chromium.patch \
    file://0005-port-ffmpeg-to-loongarch64-for-chromium-add-la64-rel.patch \
    file://0006-fix-third_party-for-loongarch64-add-files-for-la64.patch \
    file://0007-port-icu-for-loongarch64.patch \
    file://0008-port-lss-for-loongarch64.patch \
    file://0009-port-pdfium-for-loongarch64.patch \
    file://0010-port-swiftshader-for-loongarch64.patch \
    file://0011-port-webrtc-for-loongarch64.patch \
    file://0012-port-v8-for-loongarch64.patch \
    file://0013-make-qtwebengine-can-be-compiled-for-loongarch64.patch \
    file://0014-fix-compile-errors-for-mips64el.patch \
    file://0015-fix-compiler-internal-error-for-loongarch64.patch \
    file://0016-fix-compile-error-for-loongarch64.patch \
    file://0017-Force-host-toolchain-configuration.patch \
    file://0018-Fix-build-with-gcc-13.patch \
    file://0019-support-loongarch-syscall.patch \
    file://0020-close-smart_merge.patch \
    file://0021-remove-__NR_newfstatat-for-loongarch.patch \
    file://0022-fix-some-compiler-error.patch \
    file://0023-add-jstemplate_compiled.js-support.patch \
    file://0024-add-support-for-USE_X11.patch \
    "

do_compile:prepend() {
    touch ${S}/src/3rdparty/chromium/third_party/devtools-frontend/src/front_end/third_party/lighthouse/lighthouse-dt-bundle.js
    touch ${S}/src/3rdparty/chromium/third_party/devtools-frontend/src/front_end/third_party/lighthouse/report-assets/report-generator.js
    touch ${S}/src/3rdparty/chromium/third_party/devtools-frontend/src/front_end/diff/diff_match_patch.js
    touch ${S}/src/3rdparty/chromium/third_party/devtools-frontend/src/front_end/formatter_worker/acorn/acorn.js
    touch ${S}/src/3rdparty/chromium/third_party/polymer/v3_0/components-chromium/polymer/polymer_bundled.min.js
    touch ${S}/src/3rdparty/chromium/third_party/web-animations-js/sources/web-animations-next-lite.min.js
}


S = "${WORKDIR}/qtwebengine-everywhere-src-5.15.2"
SRC_URI[sha256sum] = "48908755cd7a2ee865dd880b969c9abcad8d4c23b9335d4053a121f779734aaa"
PV = "5.15.13"

DISTRO_FEATURES:remove:loongarch64 = " ptest"