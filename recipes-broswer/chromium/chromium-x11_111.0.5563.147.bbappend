FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "\
    file://0017-add-loong64-declare-to-avoid-assert-error.patch \
    file://0018-support-boringssl-for-loongarch.patch \
    file://0019-remove-target-for-customized-distro.patch \
    file://0020-add-for-reg-in-loongarch.patch \
    file://0021-clang-16-doesn-t-support-LOONGARCH_SHIM-anymore.patch \
    file://0022-change-libvpx-to-generic-for-loongarch.patch \
    file://0022-llvm-not-support-mlsx-yet-disable-it.patch \
    file://0023-sandbox-Add-loongarch64-architecture-support.patch \
    file://0024-Added-LoongArch-support-to-crashpad.patch;patchdir=third_party/crashpad/crashpad \
    file://0025-change-reloc_type-to-pc-relative.patch \
    file://0026-add-arch-define-for-loongarch-to-support-crashpad.patch \
    file://0027-add-ffmpeg-support-for-loongarch64.patch \
    "


GN_ARGS:remove:loongarch64 = "use_lld=true is_official_build=true "

#CPPFLAGS:append = " -mcmodel=medium "
#CFLAGS:append = " -mcmodel=medium "
#CFLAGS:append = " --target=loongarch64-poky-linux"
#LDFLAGS:append = " -mcmodel=medium"

# not support official build yet
GN_ARGS += " \
        is_official_build=true \
        fatal_linker_warnings=false \
        optimize_webui=false \
        use_lld=false \
        enable_swiftshader=false \
        angle_enable_swiftshader=false \
        enable_swiftshader_vulkan=false \
        dawn_use_swiftshader=false \
        enable_nacl = false \
"

python config_for_ffmpeg1() {
    orig_ldflags = d.getVar('LDFLAGS', True)
    new_ldflags = orig_ldflags.replace('-stdlib=libc++', '-lstdc++')
    d.setVar('LDFLAGS', new_ldflags)
}

python config_for_ffmpeg2() {
    orig_ldflags = d.getVar('LDFLAGS', True)
    new_ldflags = orig_ldflags.replace('-lstdc++', '-stdlib=libc++')
    d.setVar('LDFLAGS', new_ldflags)
}


do_configure[prefuncs] = "config_for_ffmpeg1"
do_configure[postfuncs] = "config_for_ffmpeg2"
#do_configure:append() {
#    cd third_party/ffmpeg
#    #sed -i 's|env python|env python3|g' chromium/scripts/build_ffmpeg.py
#    python3 ./chromium/scripts/build_ffmpeg.py linux loong64
#    ./chromium/scripts/generate_gn.py
#    ./chromium/scripts/copy_config.sh
#    cd -
#}
do_configure:append() {
    install -d third_party/ffmpeg/chromium/config/Chromium/linux/loong64
    cd third_party/ffmpeg/chromium/config/Chromium/linux/loong64
    ../../../../../configure --disable-everything --enable-cross-compile --disable-x86asm \
        --disable-all --disable-doc --disable-htmlpages --disable-manpages \
        --disable-podpages --disable-txtpages --disable-static --enable-avcodec \
        --enable-avformat --enable-avutil --enable-fft --enable-rdft --enable-static \
        --enable-libopus --disable-debug --disable-bzlib --disable-error-resilience \
        --arch=loongarch64 --target-os=linux --disable-network
    #  TARGET_PREFIX
    sed -i 's|^#define FFMPEG_CONFIGURATION |//|g' config.h
    sed -i 's|#define HAVE_SYSCTL 1|#define HAVE_SYSCTL 0|g' config.h
    cp ../x64/libavutil/ffversion.h libavutil/
    if grep -q "loong64" ../../../../../ffmpeg_generated.gni; then
        echo "configure right"
    else
        echo "if ((use_linux_config && current_cpu == \"loong64\")) {" >> ../../../../../ffmpeg_generated.gni
        echo "  ffmpeg_c_sources += [" >> ../../../../../ffmpeg_generated.gni
        echo "    \"libavutil/loongarch/cpu.c\"," >> ../../../../../ffmpeg_generated.gni
        echo "]}" >> ../../../../../ffmpeg_generated.gni
    fi
    cd -
}

# ld-linux-loongarch-lp64d.so search path is /lib64/
do_configure:prepend() {
    ln -sf ${S}/../recipe-sysroot/lib/ ${S}/../recipe-sysroot/lib64
}