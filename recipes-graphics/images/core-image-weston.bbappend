QB_MEM:qemuloongarch64 = "-m 2048"

DISTRO_FEATURES:append = " opengl x11 systemd"
DISTRO_FEATURES:remove = "pulseaudio"
VIRTUAL-RUNTIME_init_manager = "systemd"
IMAGE_INSTALL:append = " chromium-x11"
IMAGE_FEATURES:append = " x11-base hwcodecs"