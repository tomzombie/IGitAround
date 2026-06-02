sudo su -
timedatectl set-timezone America/New_York
hostnamectl set-hostname diabolical

dnf -y install nano pam_yubico gcc git cmake

cat <<HAIL_ERIS> /etc/issue.net
################################################################
# Authorized access only!                                      #
# Disconnect IMMEDIATELY if you are not an authorized user!!!  #
# All actions Will be monitored and recorded                   #
################################################################
HAIL_ERIS

sed -i 's/\#Banner none/Banner \/etc\/issue\.net/' /etc/ssh/sshd_config
sed -i 's/\#PermitRootLogin\ yes/PermitRootLogin\ no/' /etc/ssh/sshd_config
systemctl restart sshd

#disable selinux
sed -i 's/SELINUX\=enforcing/SELINUX\=disabled/' /etc/selinux/config
grubby --update-kernel ALL --args selinux=0

mkdir -p /root/git/ddate
git clone https://github.com/tomzombie/ddate.git /root/git/ddate
dnf install -y cmake gcc
cmake /root/git/ddate/ -DCMAKE_POLICY_VERSION_MINIMUM=3.5
make /root/git/ddate/
make install /root/git/ddate

systemctl stop bluetooth.service
systemctl disable bluetooth.service
systemctl stop gdm
systemctl disable gdm

dnf remove -y cups

#set static ip address
nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.1.23/24
nmcli connection modify "Wired connection 1" ipv4.gateway 192.168.1.1
nmcli connection modify "Wired connection 1" ipv4.dns "8.8.8.8 1.1.1.1"
nmcli connection modify "Wired connection 1" ipv4.method manual
nmcli connection down "Wired connection 1" && nmcli connection up "Wired connection 1"

#set firewall rules for dns and http
firewall-cmd --add-port=53/tcp --permanent
firewall-cmd --add-port=53/udp --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload

#you must reboot before you set up pihole. selinux can't be fully turned off without reboot and you need to make sure that the ip address is static
curl -sSL https://install.pi-hole.net | bash

#yubi key set up  stuff but you don't use it
auth sufficient pam_yubico.so debug id=1 authfile=/etc/yubikeys
reboot
