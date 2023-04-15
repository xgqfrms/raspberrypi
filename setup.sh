#!/bin/bash
sudo git clone https://github.com/xgqfrms/raspberrypi.git
sudo apt-get install -y mpg123
#删除 rm
# -r 递归删除参数中列出的所有目录，子目录
# -f 忽略不存在的文件，不给提示
sudo rm -rf /var/raspberrypi/
#移动 mv 
sudo mv raspberrypi /var/
# | 管道
# $ man tee
# The tee utility copies standard input to standard output, making a copy in zero or more files.  The output is unbuffered.
#  -a      Append the output to the files rather than overwriting them.
echo "/usr/bin/python /var/raspberrypi/speak_ip.py &" | sudo tee -a /etc/rc.local

echo "install finished!"
#注释 #
