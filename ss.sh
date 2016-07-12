#!/bin/bash

dbaddress=localhost
dbname=sspanel
dbusername=sspanel
dbpassword=199406288
ip=104.200.131.75
nodeid=0
version=3
nic=venet0

wget https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/repo/epel-6/librehat-shadowsocks-epel-6.repo -O /etc/yum.repos.d/librehat-shadowsocks-epel-6.repo
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm --quiet    
yum install shadowsocks-libev -y
yum install libpcap-devel -y
wget https://github.com/glzjin/ssshell-jar/raw/master/libjnetpcap.so -O /usr/lib64/libjnetpcap.so
wget https://github.com/glzjin/ssshell-jar/raw/master/libjnetpcap-pcap100.so -O /usr/lib64/libjnetpcap-pcap100.so
chkconfig shadowsocks-libev off
yum install java-1.8.0-openjdk -y
yum install supervisor python-pip -y
yum install trickle -y
pip install supervisor==3.1
chkconfig supervisord on
wget https://github.com/glzjin/ssshell-jar/raw/master/supervisord.conf -O /etc/supervisord.conf
wget https://github.com/glzjin/ssshell-jar/raw/master/supervisord -O /etc/init.d/supervisord
mkdir /root/ssshell
wget https://github.com/glzjin/ssshell-jar/raw/master/ssshell_f.jar -O /root/ssshell/ssshell.jar 
wget https://github.com/glzjin/ssshell-jar/raw/master/ssshell.conf -O /root/ssshell/ssshell.conf
sed -i  "s/addresshere/${dbaddress}/" /root/ssshell/ssshell.conf 
sed -i "s/addressnamehere/${dbname}/" /root/ssshell/ssshell.conf 
sed -i "s/addressusernamehere/${dbusername}/" /root/ssshell/ssshell.conf 
sed -i "s/addressuserpassword/${dbpassword}/" /root/ssshell/ssshell.conf 
sed -i "s/iphere/${ip}/" /root/ssshell/ssshell.conf 
sed -i "s/nodeidhere/${nodeid}/" /root/ssshell/ssshell.conf 
sed -i "s/versionhere/${version}/" /root/ssshell/ssshell.conf 
sed -i "s/nichere/${nic}/" /root/ssshell/ssshell.conf 
yum -y groupinstall "Development Tools"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig

cd /root/ssshell
git clone -b manyuser https://github.com/breakwa11/shadowsocks.git
wget https://github.com/glzjin/ssshell-jar/raw/master/ssshell_f.jar -O /root/ssshell/ssshell.jar

pip install speedtest-cli



chmod 600 /root/ssshell/ssshell.conf
service supervisord start