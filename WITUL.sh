REQUIRED_PKG="wimtools"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG installed do you want to install $REQUIRED_PKG"
  read -r -p "Are you sure? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            sudo apt-get --yes install $REQUIRED_PKG
            ;;
        *)
            echo programm stopped
            ;;
    esac
else
echo the ISO file has to be in your download folder
username="USER INPUT"
winisoname="USER INPUT"
extmedname="USER INPUT"
sudo apt-cache policy $REQUIRED_PKG
read -p "Enter your user name: " username
cd /home/$username/Downloads
echo downloading WoeUSB
wget https://github.com/WoeUSB/WoeUSB/releases/download/v5.2.4/woeusb-5.2.4.bash
echo downloading WoeUSB done
read -p "Enter name of the windows iso: " winisoname
read -p "Enter path of the usb stick: " extmedname
echo start formating the target drive
sudo mkfs -t exfat $extmedname
echo done formating the target drive
sudo bash /home/$username/Downloads/woeusb-5.2.4.bash --device /home/$username/Downloads/$winisoname $extmedname
fi


