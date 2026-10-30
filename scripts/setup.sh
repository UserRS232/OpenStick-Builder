#!/bin/sh -e

DEBIAN_FRONTEND=noninteractive
DEBCONF_NONINTERACTIVE_SEEN=true

echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections
echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections
echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections
rm -f "/etc/locale.gen"

apt update -qqy
apt upgrade -qqy
apt autoremove -qqy
apt install -qqy --no-install-recommends \
    bridge-utils \
    dnsmasq \
    hostapd \
    iptables \
    iproute2 \
    libconfig11 \
    libqmi-utils \
    libmbim-utils \
    locales \
    modemmanager \
    netcat-traditional \
    net-tools \
    network-manager \
    openssh-server \
    qrtr-tools \
    rmtfs \
    sudo \
    systemd-timesyncd \
    tzdata \
    usb-modeswitch \
    wireguard-tools \
    wpasupplicant
apt clean
rm -rf /var/lib/apt/lists/*

# dnsmasq vorerst deaktivieren, um Konflikte mit NetworkManager zu vermeiden
systemctl disable dnsmasq || true

passwd -d root

echo user:1::::/home/user:/bin/bash | newusers
mkhomedir_helper user || mkdir -p /home/user && chown -R 1000:1000 /home/user || true
echo 'user ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/user
chmod 0440 /etc/sudoers.d/user
