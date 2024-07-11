#!/bin/bash

echo "Installing Thinkpad E14/E15 Gen 4 FPC driver...\n"

if ! [ -e ./r1slm02w.zip ]
then
  curl https://download.lenovo.com/pccbbs/mobiles/r1slm02w.zip --compressed --output ./r1slm02w.zip

fi

if [ -e ./r1slm02w.zip ]
then
  unzip ./r1slm02w.zip

  sudo pacman -Sy fprintd --noconfirm

  sudo sed -i '/\[options\]/a IgnorePkg = fprintd libfprint' /etc/pacman.conf

  sudo cp -r ./FPC_driver_linux_libfprint/install_libfprint/lib/* /lib/

  sudo rm /usr/lib/libfprint-2.so.2.0.0

  sudo cp ./FPC_driver_linux_libfprint/install_libfprint/usr/lib/x86_64-linux-gnu/libfprint-2.so.2.0.0 /usr/lib/
  sudo cp ./FPC_driver_linux_27.26.23.39/install_fpc/libfpcbep.so /usr/lib/

  sudo mkdir -p /var/log/fpc

  sudo chmod 755 /usr/lib/libfprint-2.so.2.0.0 /usr/lib/libfpcbep.so

  sudo systemctl restart fprintd
  
  echo "Installation completed."

else
  echo "Driver file was not found or not downloaded!"

fi
