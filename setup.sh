#!/bin/bash
sudo git clone https://github.com/xgqfrms/raspberrypi.git
sudo apt-get install -y mpg123
#删除 rm
# -r 递归删除参数中列出的所有目录，子目录
# -f 忽略不存在的文件，不给提示
sudo rm -rf /var/speak_raspi_ip/
#移动 mv 
sudo mv speak_raspi_ip /var/
#管道 ？
echo "/usr/bin/python /var/speak_raspi_ip/speak_ip.py &" | sudo tee -a /etc/rc.local

echo "install finished!"
#注释 #
