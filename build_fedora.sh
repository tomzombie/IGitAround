sudo su -
timedatectl set-timezone America/New_York
hostnamectl set-hostname diabolical

dnf -y install nano
dnf -y install pam_yubico

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

mkdir -p /root/git/ddate
git clone https://github.com/tomzombie/ddate.git /root/git/ddate
dnf install -y cmake gcc
cmake /root/git/ddate/
make /root/git/ddate/
make install /root/git/ddate

systemctl stop bluetooth.service
systemctl disable bluetooth.service
systemctl stop gdm
systemctl disable gdm

dnf remove -y cups

curl -sSL https://install.pi-hole.net | bash

#yubi key set up  stuff
auth sufficient pam_yubico.so debug id=1 authfile=/etc/yubikeys
reboot
