bootNumber=`cat ~/arquivo`
red='\033[0;31m'
nc='\033[0m'

echo $bootNumber

case $bootNumber in
	2)
		echo "Segunda execucao"
		sed -i s/2/3/ arquivo
		printf "${red}Veja se o módulo está aparecendo snd${nc}"
		lsmod | grep snd
		sudo apt-get update
		sudo apt-get install rpi-update
		sudo rpi-update
		sudo reboot
		;;
	3)
		echo "Terceira execucao"
		sed -i s/3/4/
		sudo apt-get install git bc libncurses5-dev
		sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source
		sudo chmod +x /usr/bin/rpi-source
		/usr/bin/rpi-source -q --tag-update
		rpi-source --skip-gcc
		sudo mount -t debugfs debugs /sys/kernel/debug
		sudo cat /sys/kernel/debug/asoc/platforms
		git clone https://github.com/PaulCreaser/rpi-i2s-audio
		cd rpi-i2s-audio
		make -C /lib/modules/$(uname -r )/build M=$(pwd) modules
		sudo insmod my_loader.ko
		printf "${red}Verifique se o módulo está carregado${nc}"
		lsmod | grep my_loader
		dmesg | tail
		sudo cp my_loader.ko /lib/modules/$(uname -r)
		echo 'my_loader' | sudo tee --append /etc/modules > /dev/null
		sudo depmod -a
		sudo modprobe my_loader
		rm ~/arquivo
		sudo reboot
		;;
	4)
		echo "Já está instalado!"
		;;
	*) 
		echo "Primeira execucao"
		echo "2" >> ~/arquivo
		exit
		sudo mv /boot/config.txt /boot/config.txt.backup 
		sudo sed -i s/#dtparam=i2s=off/dtparam=i2s=on/ /boot/config.txt
		sudo mv /etc/modules /etc/modules.backup
		sudo echo "snd-bcm2835" >> /etc/modules
		sudo reboot
		;;
		
esac
