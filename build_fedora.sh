sudo su -
timedatectl set-timezone America/New_York
hostnamectl set-hostname diabolical
dnf -y update
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

#removing stupid ipv6: <- which turns out to work so long as you use syscnf also but doesn't fix my pihole issue so fuck me I guess
#cat GRUB_CMDLINE_LINUX_DEFAULT="IPv6.disable=1 quiet splash" >> /etc/default/grub
#grub2-mkconfig -o /boot/grub2/grub.cfg

mkdir -p /root/git/ddate
git clone https://github.com/tomzombie/ddate.git /root/git/ddate
dnf install -y cmake gcc
cmake /root/git/ddate/
make /root/git/ddate/
make install /root/git/ddate

systemctl stop httpd.service
systemctl disable httpd.service
systemctl stop bluetooth.service
systemctl disable bluetooth.service
systemctl stop gdm
systemctl disable gdm

dnf remove -y cups systemd-resolved httpd

#yubi key set up  stuff
auth sufficient pam_yubico.so debug id=1 authfile=/etc/yubikeys
reboot
