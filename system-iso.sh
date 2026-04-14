#!/usr/bin/env bash
set -euo pipefail

ISO_NAME="system-linux"
ISO_VERSION="2026.04"
WORK_DIR="$(pwd)/archiso_work"
OUTPUT_DIR="$(pwd)"
FINAL_ISO="${OUTPUT_DIR}/${ISO_NAME}-${ISO_VERSION}.iso"
LOG_FILE="${WORK_DIR}/build.log"
WALLPAPER=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

error_exit() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*"
}

force_cleanup() {
    if [[ -d "${WORK_DIR}" ]]; then
        local pids
        pids=$(lsof -t "${WORK_DIR}" 2>/dev/null | sort -u || true)
        if [[ -n "${pids}" ]]; then
            log "Killing processes using work directory: ${pids}"
            echo "${pids}" | xargs -r kill -9 2>/dev/null || true
        fi
    fi

    while IFS= read -r mount_point; do
        log "Force unmounting: ${mount_point}"
        umount -f -l "${mount_point}" 2>/dev/null || true
    done < <(mount | grep "${WORK_DIR}" | cut -d' ' -f3 | sort -r)

    sleep 5

    if [[ -d "${WORK_DIR}" ]]; then
        log "Removing ${WORK_DIR}"
        rm -rf "${WORK_DIR}" 2>/dev/null || {
            log_warning "Normal removal failed, trying with sudo..."
            sudo rm -rf "${WORK_DIR}" 2>/dev/null || {
                log_warning "Could not remove ${WORK_DIR}, will continue anyway"
            }
        }
    fi
}

force_cleanup
mkdir -p "${WORK_DIR}"
touch "${LOG_FILE}"

log "============================================"
log "Starting System Linux Live ISO build process"
log "============================================"

if [[ $EUID -ne 0 ]]; then
    error_exit "This script must be run as root"
fi
log " :: Running as root"

for cmd in mkarchiso pacman; do
    if ! command -v "$cmd" &> /dev/null; then
        error_exit "Required command not found: $cmd"
    fi
done

TOTAL_CPUS=$(nproc)
MAX_CPUS=$((TOTAL_CPUS * 75 / 100))
[[ ${MAX_CPUS} -lt 1 ]] && MAX_CPUS=1
log " :: Total CPUs: ${TOTAL_CPUS}, Will limit to ${MAX_CPUS} CPUs (75%) using cgroups"

if ! command -v mkarchiso &> /dev/null; then
    log "Installing archiso..."
    pacman -S --noconfirm archiso || error_exit "Failed to install archiso"
fi

log " :: Copying archiso releng profile..."
cp -r /usr/share/archiso/configs/releng/* "${WORK_DIR}/"

log "    - Configuring pacman.conf..."
if ! grep -q "^Architecture" "${WORK_DIR}/pacman.conf"; then
    sed -i '/^\[options\]/a Architecture = auto' "${WORK_DIR}/pacman.conf"
fi

if ! grep -q "^\[multilib\]" "${WORK_DIR}/pacman.conf"; then
    cat >> "${WORK_DIR}/pacman.conf" << 'EOF'

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
fi

cat >> "${WORK_DIR}/pacman.conf" << 'EOF'

[system-linux]
Server = https://system-linux.org/system-linux/os/x86_64
SigLevel = Optional TrustAll
EOF

log "    - Adding packages..."
cat >> "${WORK_DIR}/packages.x86_64" << 'EOF'
# System Linux
system-linux-keyring
trizen

# Base
base-devel
git

# KDE Plasma (minimal)
plasma-desktop
plasma-workspace
plasma-pa
plasma-nm
breeze-gtk
breeze-icons
sddm
sddm-kcm
kwin
kwin-x11
dolphin
konsole
kate

# Wayland & X11
wayland
xdg-desktop-portal
xdg-desktop-portal-kde
xorg-server
xorg-xinit

# Graphics drivers
xf86-video-intel
vulkan-intel
xf86-video-amdgpu
mesa
vulkan-radeon
xf86-video-nouveau
nvidia-utils
xf86-video-vesa
xf86-video-fbdev
xf86-video-qxl
spice-vdagent

# Audio
pipewire
pipewire-pulse
wireplumber
alsa-utils

# Network
networkmanager
network-manager-applet
bluez
bluez-utils

# Printing
cups
system-config-printer

# Filesystems
ntfs-3g
exfatprogs
fuse2
fuse3
btrfs-progs

# System tools
sudo
plymouth
terminus-font
ttf-dejavu
ufw

# Utilities
htop
btop
fastfetch
curl
wget
openssh
EOF

log "    - Configuring SDDM autologin..."
mkdir -p "${WORK_DIR}/airootfs/etc/sddm.conf.d"
cat > "${WORK_DIR}/airootfs/etc/sddm.conf.d/autologin.conf" << 'EOF'
[Autologin]
User=user
Session=plasma

[Theme]
Current=breeze

[General]
DisplayServer=wayland
EOF

if [[ -n "${WALLPAPER}" ]]; then
    log "    - Configuring wallpaper: ${WALLPAPER}"
    mkdir -p "${WORK_DIR}/airootfs/usr/share/wallpapers"
    
    if [[ "${WALLPAPER}" =~ ^https?:// ]]; then
        curl -s -o "${WORK_DIR}/airootfs/usr/share/wallpapers/default.jpg" "${WALLPAPER}"
    elif [[ -f "${WALLPAPER}" ]]; then
        cp "${WALLPAPER}" "${WORK_DIR}/airootfs/usr/share/wallpapers/default.jpg"
    fi
fi

log "    - Creating mirrorlist..."
mkdir -p "${WORK_DIR}/airootfs/etc/pacman.d"
cat > "${WORK_DIR}/airootfs/etc/pacman.d/mirrorlist" << 'EOF'
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://arch.mirror.constant.com/$repo/os/$arch
EOF

cat > "${WORK_DIR}/airootfs/etc/pacman.conf" << 'EOF'
[options]
Architecture = auto
ParallelDownloads = 5
SigLevel = Never

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

[system-linux]
Server = https://system-linux.org/system-linux/os/x86_64
SigLevel = Optional TrustAll
EOF

log "    - Creating user customization..."
cat >> "${WORK_DIR}/airootfs/root/customize_airootfs.sh" << 'EOF'

echo "Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinux
pacman-key --populate system-linux

# Update package database
pacman -Sy --noconfirm 2>/dev/null || true

# Remove plasma-welcome package
pacman -Rdd --noconfirm plasma-welcome 2>/dev/null || true

# Create live user
rm -f /etc/passwd.lock /etc/shadow.lock /etc/group.lock 2>/dev/null || true
useradd -m -G wheel,audio,video,storage,optical,network,power -s /bin/bash user 2>/dev/null || true
echo "user:pass" | chpasswd 2>/dev/null || true

# Setup sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-wheel
chmod 440 /etc/sudoers.d/10-wheel

# Create .bash_profile
cat > /home/user/.bash_profile << 'PROFILE'
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session startplasma-wayland
fi
PROFILE
chown user:user /home/user/.bash_profile 2>/dev/null || true
chmod 644 /home/user/.bash_profile

# Set wallpaper if configured
WALLPAPER_FILE="/usr/share/wallpapers/default.jpg"
if [ -f "$WALLPAPER_FILE" ]; then
    mkdir -p /home/user/.config
    cat > /home/user/.config/plasmarc << 'PLASMARC'
[Wallpapers]
Image=/usr/share/wallpapers/default.jpg
PLASMARC
    chown -R user:user /home/user/.config 2>/dev/null || true
fi

# Enable services
systemctl enable sddm
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable systemd-ldconfig.service
systemctl enable systemd-vconsole-setup.service

# Pre-generate ldconfig cache
/sbin/ldconfig 2>/dev/null || true

# Minimal MOTD
cat > /etc/motd << 'MOTD'
System Linux Live
Login: user / pass
MOTD

# Autologin on console
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'TTYEOF'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin user --noclear %I $TERM
TTYEOF

# Set locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "system-live" > /etc/hostname

systemctl daemon-reload
EOF

echo "SYSTEM_LINUX" > "${WORK_DIR}/iso_label"

log "    - Adding kernel parameters..."
mkdir -p "${WORK_DIR}/syslinux"
cat > "${WORK_DIR}/syslinux/archiso_sys.cfg" << 'EOF'
PROMPT 0
TIMEOUT 50
DEFAULT arch

LABEL arch
    MENU LABEL System Linux
    LINUX /boot/vmlinuz-linux
    INITRD /boot/initramfs-linux.img
    APPEND archisobasedir=arch archisolabel=SYSTEM_LINUX quiet splash

LABEL arch-nomodeset
    MENU LABEL System Linux (Safe Mode)
    LINUX /boot/vmlinuz-linux
    INITRD /boot/initramfs-linux.img
    APPEND archisobasedir=arch archisolabel=SYSTEM_LINUX quiet nomodeset

LABEL reboot
    MENU LABEL Reboot
    COM32 reboot.c32

LABEL poweroff
    MENU LABEL Power Off
    COM32 poweroff.c32
EOF

log "    - Setting up cgroups v2 CPU limiting..."

CGROUP_PATH="/sys/fs/cgroup/archiso_build"
mkdir -p "${CGROUP_PATH}" 2>/dev/null || true

CPU_MAX="${MAX_CPUS}00000"

USE_CGROUPS=false
if [ -d "${CGROUP_PATH}" ]; then
    if echo "$CPU_MAX 100000" > "${CGROUP_PATH}/cpu.max" 2>/dev/null; then
        log " :: CPU limit configured: ${MAX_CPUS}/${TOTAL_CPUS} cores (75%)"
        USE_CGROUPS=true
    fi
fi

log "=========================================="
log "Starting ISO build"
log "CPU Limit: ${MAX_CPUS}/${TOTAL_CPUS} cores (75%)"
log "=========================================="
echo ""

run_mkarchiso() {
    mkarchiso -v -w "${WORK_DIR}/work" -o "${OUTPUT_DIR}" "${WORK_DIR}" 2>&1 | \
        grep -v "Invalid argument" | \
        grep -v "No such file or directory" | \
        grep -v "Operation not permitted" | \
        grep -v "Permission denied" | \
        grep -v "cannot remove.*Operation not permitted" | \
        tee -a "${LOG_FILE}"
    return ${PIPESTATUS[0]}
}

BUILD_SUCCESS=false
if [[ "${USE_CGROUPS}" == "true" ]]; then
    echo $$ > "${CGROUP_PATH}/cgroup.procs" 2>/dev/null || true
    if run_mkarchiso; then
        BUILD_SUCCESS=true
    fi
    rmdir "${CGROUP_PATH}" 2>/dev/null || true
else
    if run_mkarchiso; then
        BUILD_SUCCESS=true
    fi
fi

force_cleanup

if [[ "${BUILD_SUCCESS}" != "true" ]]; then
    error_exit "mkarchiso failed. Check log: ${LOG_FILE}"
fi

log " :: ISO build completed successfully"

BUILT_ISO=$(ls -t "${OUTPUT_DIR}"/archlinux-*.iso 2>/dev/null | head -1)

if [[ -z "${BUILT_ISO}" ]]; then
    BUILT_ISO=$(ls -t "${OUTPUT_DIR}"/*.iso 2>/dev/null | head -1)
fi

if [[ -z "${BUILT_ISO}" ]]; then
    error_exit "Built ISO not found"
fi

log "    - Moving ISO to ${FINAL_ISO}..."
rm -f "${FINAL_ISO}" 2>/dev/null || true
mv "${BUILT_ISO}" "${FINAL_ISO}"

if [[ ! -f "${FINAL_ISO}" ]]; then
    error_exit "Failed to rename ISO"
fi

md5sum "${FINAL_ISO}" > "${FINAL_ISO}.md5"

ISO_SIZE=$(du -h "${FINAL_ISO}" | cut -f1)

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  BUILD COMPLETED SUCCESSFULLY!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}ISO Details:${NC}"
echo -e "  ${GREEN}Location:${NC} ${FINAL_ISO}"
echo -e "  ${GREEN}Size:${NC}     ${ISO_SIZE}"
echo -e "  ${GREEN}MD5:${NC}      $(cat "${FINAL_ISO}.md5")"
echo ""
echo -e "${YELLOW}Features:${NC}"
echo -e "  • Minimal System Linux"
echo -e "  • Full graphics driver support"
echo ""
echo -e "${YELLOW}To write to USB:${NC}"
echo -e "  ${BLUE}sudo dd if=${FINAL_ISO} of=/dev/sdX bs=4M status=progress${NC}"
echo ""
echo -e "${YELLOW}To test in QEMU:${NC}"
echo -e "  ${BLUE}qemu-system-x86_64 -enable-kvm -m 4G -vga virtio -cdrom ${FINAL_ISO}${NC}"
echo ""
echo -e "${YELLOW}Login:${NC} ${GREEN}user${NC} / ${GREEN}pass${NC}"
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
