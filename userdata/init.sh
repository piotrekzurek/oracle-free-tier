#!/bin/bash

# Prereqs and podman
sudo useradd -s /bin/bash -d /home/piotrzurek -m -p '$y$j9T$NGxdHvMCddcVoBuL.vvR.0$YmJI.LC06iBF1F7rUkT1yBxdoNmVVCgNKKHgEc6zC92' piotrzurek &&
sudo mkdir /home/piotrzurek/.ssh &&
sudo mv /home/ubuntu/.ssh/authorized_keys /home/piotrzurek/.ssh/ &&
sudo chown -R piotrzurek:piotrzurek /home/piotrzurek &&
sudo adduser piotrzurek sudo &&

sudo echo "APT::Install-Recommends \"false\";" >  /etc/apt/apt.conf.d/00-noreccomendations &&
sudo apt update &&
sudo apt purge -yqq\
        *headers* \
        multipath-tools \
        ubuntu-server \
        snapd \
        open-iscsi \
        telnet \
        lxd-agent-loader \
        pastebinit \
        packagekit \
        software-properties-common \
        ubuntu-pro-client* \
        ubuntu-advantage-tools &&
sudo apt autoremove -yqq &&
sudo apt full-upgrade -yqq &&
sudo apt-get install -yqq \
        unattended-upgrades \
        tmux \
        curl \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        openssh-server &&

sudo hostnamectl hostname zurek.top &&
export PUBLIC_IP=$(curl ident.me) &&
sudo sh -c "echo '$PUBLIC_IP zurek.top zurek' >> /etc/hosts" &&
sudo sh -c "mkdir /etc/systemd/system/ssh.socket.d" &&
sudo sh -c "echo '[Socket]\nListenStream=\nListenStream=818' > /etc/systemd/system/ssh.socket.d/override.conf" &&
sudo sh -c "echo 'Port 818' >> /etc/ssh/sshd_config" &&
sudo sh -c "sed -i 's/22/818/g' /etc/iptables/rules.v4" &&
sudo systemctl daemon-reload &&
sudo systemctl restart ssh.socket &&
sudo systemctl restart netfilter-persistent &&
sudo iptables-restore < /etc/iptables/rules.v4 &&

sudo userdel -f -r ubuntu &&
sudo userdel -f -r opc &&
sudo userdel -f -r snap_daemon &&
sudo userdel -f -r snapd-range-524288-root