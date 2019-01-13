#!/bin/bash

# Linux下安装Git服务器
# 1. 首先登陆root用户
if [ `whoami` == "root" ] ; then
    echo "root has login"
else
    echo "login root user, please input password"
    su root
fi

# 2. 新建 git 用户
    # 判断 git 用户是否存在
result=`cut -d: -f1 /etc/passwd | grep -w "git" -c`
if [ $result -le 0 ]; then
    echo "User git does not exist, create user git"
    useradd git
    echo git:dqgq1234 | chpasswd
else
    echo "I think git server has installed"
    exit
fi

# 3. 安装git
result=`command -v git | grep -w "git" -c`
# result 等于0 表示没有找到git 命令，需要安装git，不同系统安装命令不一样
if [ $result -le 0 ]; then
    echo "Install git"
    apt-get update
    apt install git
else
    echo "Git installed"
fi


# 4. 修改 /etc/ssh/sshd_config 配置文件
file="/etc/ssh/sshd_config"
line1=`grep -n "^.*AuthorizedKeysFile.*authorized_keys.*" $file | cut -d ":" -f 1`
echo $line1
    # 如果不匹配，就在文件最后加一行，如果匹配，直接替换
if [ -z "$line1" ]; then
    echo "AuthorizedKeysFile .ssh/authorized_keys" | sudo tee -a $file
else
    sed -i ''$line1'c\AuthorizedKeysFile .ssh/authorized_keys' $file
fi
line1=`grep -n "^.*AuthorizedKeysFile.*authorized_keys.*" $file | cut -d ":" -f 1`

    # 如果不匹配，就在上面的那行前边插入
line2=`grep -n "^.*PubkeyAuthentication.*yes.*" $file | cut -d ":" -f 1`
echo $line2
if [ -z "$line2" ]; then
    sed -i ''$line1'i\PubkeyAuthentication yes' $file
else
    sed -i ''$line2'c\PubkeyAuthentication yes' $file
fi
line2=`grep -n "^.*PubkeyAuthentication.*yes.*" $file | cut -d ":" -f 1`


    # 如果不匹配，就在上面的那行前边插入
line3=`grep -n "^.*RSAAuthentication.*yes.*" $file | cut -d ":" -f 1`
echo $line3
if [ -z "$line3" ]; then
    sed -i ''$line2'i\RSAAuthentication yes' $file
else
    sed -i ''$line3'c\RSAAuthentication yes' $file
fi
    # 重启sshd服务
sudo service sshd restart

# 5. 创建 /home/git/repository 目录, /home/git/.ssh目录，authorized_keys文件
mkdir -p /home/git/repository
mkdir -p /home/git/.ssh
# 把 respository的 owner 修改为 git
chown -R git:git /home/git/repository
chown -R git:git /home/git/.ssh
# echo 
curl https://raw.githubusercontent.com/bpzj/linux.conf/master/ssh/id_rsa.pub > /home/git/.ssh/authorized_keys
chmod 700 /home/git/.ssh
chmod 600 /home/git/.ssh/authorized_keys

# 6. 取消git用户ssh登陆，而只能使用git，有问题，暂时不弄了
# sed -E "s/^git(.*)git:\/bin.*/git\1git:\/bin\/git-shell/" /etc/passwd
