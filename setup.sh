#!/bin/bash

# Source os-release for ID, ID_LIKE, etc.
. /etc/os-release

echo "Detected OS: $ID"
echo "OS family: $ID_LIKE"

# check if notify-send is already installed
if command -v notify-send &> /dev/null; then
    echo "✅ notify-send is already installed."
else
    echo "📦 notify-send not found. Attempting to install libnotify..."

    # install libnotify based on OS family
    if [[ "$ID_LIKE" == *"debian"* || "$ID" == "debian" ]]; then
        echo "Using apt (Debian family)"
        sudo apt update && sudo apt install -y libnotify-bin
    elif [[ "$ID_LIKE" == *"rhel"* || "$ID_LIKE" == *"fedora"* || "$ID" == "centos" || "$ID" == "fedora" ]]; then
        echo "Using dnf (RHEL/Fedora family)"
        sudo dnf install -y libnotify
    elif [[ "$ID_LIKE" == *"arch"* || "$ID" == "arch" ]]; then
        echo "Using pacman (Arch family)"
        sudo pacman -Sy --noconfirm libnotify
    else
        echo "❌ Unsupported OS family: $ID or $ID_LIKE"
        exit 1
    fi

    # check again after installation
    if command -v notify-send &> /dev/null; then
        echo "✅ notify-send installed successfully."
        notify-send "✅ notify-send installed successfully."
    else
        echo "❌ Failed to install notify-send."
        exit 1
    fi
fi

#send notification to tell that script is being installed
notify-send "🔧 Installing" "\nSetting up auto start"

#make battery_notify.sh executable
echo "Making battery.sh executable"
chmod +x battery_notify.sh

#copy battery_notify.sh to ~/.local/bin
echo "copying battery_notify.sh to ~/.local/bin"
mkdir -p ~/.local/bin
cp -f battery_notify.sh ~/.local/bin/

#create directory for systemd in user home if not already exists
mkdir -p ~/.config/systemd/user

#copy batter_nofity.service to relevent directory
echo "copy battery_nofity.service to ~/.config/systemd/user/ directory"
cp -f battery_notify.service ~/.config/systemd/user/

#enable systemd service we just copied
systemctl --user daemon-reload
systemctl --user enable battery_notify.service
systemctl --user start battery_notify.service

echo "✅ Succesfully installed"
notify-send "✅ Installed" "\nLow battery notification has been successfully installed"
