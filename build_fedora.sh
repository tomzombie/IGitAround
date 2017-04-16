sudo su -
timedatectl set-timezone America/Phoenix
hostnamectl set-hostname demonica
yum -y update
yum -y install nano
yum -y install pam_yubico

cat <<HAIL_ERIS> /etc/issue.net
###################################################################################
# Authorized access only!                                                         #
# Disconnect IMMEDIATELY if you are not an authorized user!!!                     #
# All actions Will be monitored and recorded                                      #
###################################################################################
HAIL_ERIS

sed -i 's/\#Banner none/Banner \/etc\/issue\.net/' /etc/ssh/sshd_config
sed -i 's/\#PermitRootLogin\ yes/PermitRootLogin\ no/' /etc/ssh/sshd_config
systemctl restart sshd

mkdir -p /root/git/ddate
git clone https://github.com/tomzombie/ddate.git /root/git/ddate
yum install -y cmake
yum install -y gcc
cmake /root/git/ddate/
make /root/git/ddate/
make install /root/git/ddate

systemctl stop httpd.service
systemctl disable httpd.service
systemctl stop bluetooth.service
systemctl disable bluetooth.service

#yubi key set up  stuff
auth sufficient pam_yubico.so debug id=1 authfile=/etc/yubikeys
