#!/bin/bash
(
REQUIRED_PKG="wimtools"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG installed do you want to install $REQUIRED_PKG"
  sudo apt-get --yes install $REQUIRED_PKG
    
else
echo the ISO file has to be in your download folder
zenity --info --title="WITUL" --text="the ISO file has to be in your download folder"
username="USER INPUT"
winisoname="USER INPUT"
extmedname="USER INPUT"
SUDO_ASKPASS="USER INPUT"
read -p "Enter your user name: " username
username=$(zenity --entry --title="WITUL" --text="Enter your user name:")
read -p "Enter your user password: " SUDO_ASKPASS
SUDO_ASKPASS=$(zenity --entry --title="WITUL" --text="Enter your user password:")
echo -e "$SUDO_ASKPASS\n" | sudo -S $SUDO_ASKPASS apt-cache policy $REQUIRED_PKG
cd /home/$username/Downloads
echo downloading WoeUSB
wget https://github.com/WoeUSB/WoeUSB/releases/download/v5.2.4/woeusb-5.2.4.bash
echo downloading WoeUSB done
read -p "Enter name of the windows iso: " winisoname
winisoname=$(zenity --entry --title="WITUL" --text="Enter name of the windows iso:")
read -p "Enter path of the usb stick: " extmedname
extmedname=$(zenity --entry --title="WITUL" --text="Enter path of the usb stick:")
echo start formating the target drive
echo -e "$SUDO_ASKPASS\n" | sudo -S $SUDO_ASKPASS mkfs -t exfat $extmedname
echo done formating the target drive
if sudo -S bash /home/$username/Downloads/woeusb-5.2.4.bash --device /home/$username/Downloads/$winisoname $extmedname ; then
    echo "installing succeeded"
zenity --info --title="WITUL" --text="installing succeeded"
    echo -e "$SUDO_ASKPASS\n" | sudo -S bash /home/$username/Downloads/woeusb-5.2.4.bash --device /home/$username/Downloads/$winisoname $extmedname
else
    echo "installing failed"
zenity --error --title="WITUL" --text="installing failed for more information look in install.log"
tee -a install.log
fi
fi
cd /home/$username
) 2>&1 | tee -a install.log

