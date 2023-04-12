树莓派设置静态IP记录（整理）

树莓派默认使用的是dhcp自动分配ip

而且默认打开SSH服务

当没有显示器的时候

我们可以启动树莓派，并用软件扫描局域网找到Raspberry pi的ip地址

然后用putty登录

当有些情况下我们不想扫描ip那么可以考虑将树莓派的ip设为固定ip这样我们每次就能准确访问

而不需要扫描ip

设置树莓派为静态ip的方法和debian linux修改是一样的

只需要修改文件sudo vi /etc/network/interfaces文件即可

我的pi操作系统是2013-02-09-wheezy-raspbian.img

/etc/network/interfaces原文件为dhcp获取ip，内容为

auto lo


iface lo inet loopback
iface eth0 inet dhcp


allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
iface default inet dhcp



修改此文件的办法：

1，树莓派接显示器，用键盘鼠标打开终端 修改文件

2，用ssh/VNC登录树莓派修改此文件

3，在linux下直接用读卡器读取SD卡 修改/etc/network/interfaces文件

（你可以先备份这个文件sudo cp /etc/network/interfaces /etc/network/interfaces.bk）

想设置为静态ip需要这么做

直接将iface eth0 inet dhcp

替换为

iface eth0 inet static

address 192.168.1.88
netmask 255.255.255.0
gateway 192.168.1.1

然后删除这一行
 iface default inet dhcp(否则 ip是固定的但是无法连外网)



修改后的文件为

auto lo

iface lo inet loopback

iface eth0 inet static

address 192.168.1.88
netmask 255.255.255.0
gateway 192.168.1.1

allow-hotplug wlan0
iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

然后重启服务或系统

sudo reboot

root@raspberrypi:~# sudo service networking restart

树莓派为静态ip而且可以连接外网




测试是否能联网：
pi@raspberrypi ~ $ sudo apt-get update
命中 http://archive.raspberrypi.org wheezy InRelease
获取：1 http://mirrordirector.raspbian.org wheezy InRelease [12.5 kB]
命中 http://archive.raspberrypi.org wheezy/main armhf Packages
忽略 http://archive.raspberrypi.org wheezy/main Translation-zh_CN

如果你想修改DNS那么你需要修改此文件

root@raspberrypi:~# sudo cat /etc/resolv.conf
改成类似的即可

nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 208.67.220.220
nameserver 208.67.222.222
nameserver 10.10.10.10

root@raspberrypi:~# sudo service networking restart

