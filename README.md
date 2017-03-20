# crt
A shell that does not need to enter a password for quick login to a remote linux machine

# usage
1.安装完后，拷贝配置文件到用户目录
'''
cp /etc/crt/conf/host.example ~/.host
'''
2.添加配置文件内容 格式为
name		host	        port	user	password
local		127.0.0.1	2222	root	abb
allinone	127.0.0.1	2012	root	rtB%$$%

3.查看主机列表
crt -l

4.登录远程主机
crt -s local

5.上传 文件或文件夹 到 远程主机
crt -p allinone /root/music /home/Jack/

6.下载 远程主机 文件或文件加 到 本地
crt -g allinone /home/Jack/doc /root/

# rpm build step
1.安装打包工具
''' 
yum install -y rpm-build rpmdevtools
'''
2.来生成一个 rpm 包的骨架目录 默认在 ~/rpmbuild
'''
rpmdev-setuptreer
'''
3.将源码打包拷贝到 SOURCES
4.将spec文件放到 SPECS
5.执行打包
'''
rpmbuild -ba crt.spec
'''
6.安装
'''
yum install crt.rpm
'''

# deb build step
1.安装 包转换工具
apt-get install alien
2.转换为deb包
alien crt.rpm
3.安装deb包
dpkg -i crt.deb
