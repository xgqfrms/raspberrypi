# raspberry pi 3 manual.md

***
***
1. SD卡安装rasbian系统

2. 在没有显示器的情况下，查看raspberry pi的ip：
>1 网线直连 pi-PC ,PC 开启wlan 的共享(Ethernet与 Wireless 桥接 ？)
   cmd.exe 下 ipconfig  查看 Wireless / Ethernet 的ip( 使用 Ethernet 的ip 所在网段)
   cmd.exe 下 arp-a  找到 192.168.137.0/24 子网段内 static/dynamic 的ip（不一定，会变化）
  
>2 安装 Zenmap 7.12（nmap 的PC GUI ）
   nmap -sn 192.168.137.0/24
   或
   cmd.exe 下 nmap -sn 192.168.137.0/24
   
3. xshell/putty 使用SSH 连接到 pi
   user pwd
   pi   raspberry

4. 修改配置文件
  sudo raspi-config 
  箭头，Tab,Enter 
  > 扩充系统空间到SD 全部容量
  
  >默认启动 desktop (不需要使用SSH 命令 startx)
  
  > 修改GPU 分配的内存大小（推荐使用 cma 动态分配 ？ cma_lwn 最低，cma_hwm 最高）
  修改  cmdline.txt 启动CMA
  coherent_pool=6M smsc95xx.turbo_mode=N
  (http://elinux.org/RPiconfig)
  
  > sudo apt-get update 更新
  
  > sudo apt-get upgrade 升级
  
  > 设置静态ip ?
  sudo nano /etc/network/interfaces

  添加
  iface eth0 inet static
  address 192.168.137.111
  netmask 255.255.255.0
  gateway 192.168.137.1
  
   退出 ，保存
   Ctrl+X , Y

5. 安装远程桌面
##  VNC 
>  在线安装（可能出现，链接失败 GWF,） ?
   http://www.tightvnc.com/
   sudo apt-get install tightvncserver
   
   设置密码/使用密钥 ：
   vncpasswd (输入两次)
   
   开启 service ：
   vncserver: 1 -geometry 800x600
   
   (1号桌面，分辨率800x600)
   设置开机，自启动 
   参考：http://my.oschina.net/quanpower/blog/221920
   无显示器无路由器无键盘无鼠标，仅靠网线直连笔记本用最简单配置玩转树莓派：
   
********************************************************************************************************  
   > 设置开机启动，需要在/etc/init.d/中创建一个文件，例如tightvncserver
   sudo mkdir /etc/init.d/tightvncserver ?
   
   sudo nano /etc/init.d/tightvncserver
   输入

### BEGIN INIT INFO
# Provides: tightvnc
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start VNC Server as a service
# Description: Start VNC Server as a service.
### END INIT INFO
#!/bin/sh
# /etc/init.d/tightvncserver
# Customised by raspicndotcom
#http://www.penguintutor.com/linux/tightvnc
# Set the VNCUSER variable to the name of the user to start tightvncserver under
VNCUSER='pi'
eval cd ~$VNCUSER
case "$1" in
start)
   su $VNCUSER -c '/usr/bin/tightvncserver :1  -geometry 1024x640 -depth 16 -pixelformat rgb565'
   echo "Starting TightVNC server for $VNCUSER "
   ;;
stop)
   pkill Xtightvnc
   echo "Tightvncserver stopped"
   ;;
*)
   echo "Usage: /etc/init.d/tightvncserver {start|stop}"
   exit 1
   ;;
esac
exit 0
#

需要特别说明的一点是  这个脚本的默认用户是"pi" 
Ctrl+ O 回车 保存  Ctrl +X 退出 

输入命令 
sudo chmod 755 /etc/init.d/tightvncserver
sudo update-rc.d tightvncserver defaults

在默认账户pi下输入命令
vncserver

会提示你设定vnc 服务的访问密码
需要连续输入两次密码
密码长度最好为8位
之后还会提示你要不要输入一个只读密码
只读密码可以选Y输入也可以选n跳过
配置完毕
输入命令
   reboot
等待树莓派重新启动后就可以用刚才设定的密码登录VNC 服务重新启动pi
*********************************************************************** 
   
   
 
> 离线安装，SFTP 传输到 rasbian 推荐
     curl -L -o VNC.tar.gz https://www.realvnc.com/download/bianry/latest/debian/arm/   
     在线安装 ？ 重定向 https://www.realvnc.com/download/

     下载 （VNC-5.3.1-Linux-ARM-DEB.tar.gz） 
     (https://www.realvnc.com/download/vnc/)
     tar 解压
  tar xvf VNC-5.3.1-Linux-ARM-DEB.tar.gz  （不好使）
    或
  tar -xvzf VNC-5.3.1-Linux-ARM-DEB.tar.gz 

    {
    http://www.cnblogs.com/xgqfrms/p/5032596.html
    具有bz2扩展名的文件是使用bzip算法进行压缩的.(“j”选项用来指定bzip。)
    $ tar -xvjf archivefile.tar.bz2

    具有gz扩展名的文件是使用gzip算法进行压缩的.(“z”选项用来指定gzip)
    $ tar -xvzf archivefile.tar.gz

    tar命令具有两个压缩格式，gzip和bzip，
    该命令的“z”选项用来指定gzip，“j”选项用来指定bzip。
    }

  安装
     VNC-Server-5.3.1-Linux-ARM.deb
     VNC-Viewer-5.3.1-Linux-ARM.deb(可选)
   sudo dpkg -i VNC-Server-5.3.1-Linux-ARM.deb 
	或
   sudo dpkg -i VNC-Server-5.3.1-Linux-ARM.deb VNC-Viewer-5.3.1-Linux-ARM.deb  
  应用密钥 （不需要设置 VNC server 的密码 ：）
     Thank you for choosing VNC. Your Free license details are as follows:
     License key: M3H3H-22AGD-E2372-2HCF5-SB2JA
     Valid for: 5 desktops
  sudo vnclicense -add M3H3H-22AGD-E2372-2HCF5-SB2JA
  
  启动 8 jessie
  sudo systemctl start vncserver-x11-serviced.service
  
  设置 自动启动 8 jessie
  sudo systemctl enable vncserver-x11-serviced.service
  
  停用 8 jessie
  sudo systemctl stop vncserver-x11-serviced.service
  或
  vncserver -kill :1
  
> 没有VNC密钥,需要设置 VNC server 的密码 ：
   sudo vncpasswd -service
  
  参考：https://www.realvnc.com/products/vnc/raspberrypi/
  VNC® and the Raspberry Pi

##  xdrp 
 sudo apt-get install xrdp （不好使）
 
 5. 登陆远程桌面！
 
   
  
 
 6.使用 
  omxplayer test.mp3 播放音乐
  omxplayer test.mp4 播放视频 ？
  
  
  
 
 
 9.搭建lemp web server
 
 
 
 
 http://www.penguintutor.com/linux/tightvnc  ?
 
 
 Error:
  
 > sudo apt-get upgrade
 
 dpkg: error processing package udev (--configure):
 subprocess installed post-nstallation script returned error exit status 1
 
 E: Sub-process /usr/bin/dpkg returned an error code (1)
 
 
 
 
 

