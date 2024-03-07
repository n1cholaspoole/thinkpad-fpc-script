#!/bin/bash

echo "Downloading files"

# Create random temp directory
TEMP_DIR="tmp$RANDOM"
mkdir $TEMP_DIR
cd ./$TEMP_DIR

# Download the driver
curl https://download.lenovo.com/pccbbs/mobiles/r1slm02w.zip --compressed --output ./r1slm02w.zip
unzip r1slm02w.zip

echo "Installing Thinkpad E15 Gen 4 FPC driver"

# Install fprintd, libfprint
sudo pacman -S fprintd libfprint --noconfirm

# Copy udev rules
sudo cp -r ./FPC_driver_linux_libfprint/install_libfprint/lib/* /lib/

# Backup existing fprint library
sudo mv /usr/lib/libfprint-2.so.2.0.0 /usr/lib/libfprint-2.so.2.0.0.bak
echo "Original libfprint-2.so.2.0.0 backed up to libfprint-2.so.2.0.0.bak"

# Fix link
sudo ln -sf /usr/lib/libfprint-2.so.2.0.0 /usr/lib/libfprint-2.so

# Copy FPC fprint, helper libraries
sudo cp ./FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so.2.0.0 /usr/lib/
sudo cp ./FPC_driver_linux_27.26.23.39/install_fpc/libfpcbep.so /usr/lib

# Make directory for logs
sudo mkdir -p /var/log/fpc

# Fix permissions
sudo chmod 755 /usr/lib/libfprint-2.so.2.0.0 /usr/lib/libfpcbep.so

# Restart fprintd
sudo systemctl restart fprintd

echo "Removing temp files"

# Remove temp directory
cd ../
sudo rm -rf ./$TEMP_DIR

echo "Installation completed successfully"
