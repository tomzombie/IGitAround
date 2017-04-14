passwd
timedatectl set-timezone America/Phoenix
hostnamectl set-hostname pignuckle
yum -y update
yum -y install nano
yum -y groupinstall "Server with GUI"
yum -y groupinstall "Development Tools"
adduser tomzombie
passwd tomzombie
gpasswd -a tomzombie wheel

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

mkdir /root/git/ddate
git clone https://github.com/tomzombie/ddate.git /root/git/ddate
yum install -y cmake
cmake /root/git/ddate/
make /root/git/ddate/
make install /root/git/ddate

sed -i 's/BOOTPROTO\=\"dhcp\"/BOOTPROTO\=\"static\"/' /etc/sysconfig/network-scripts/ifcfg-eth0
echo "IPADDR=192.168.1.6" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "NETMASK=255.255.255.0" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "GATEWAY=192.168.1.1" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "DNS1=192.168.1.1" >> /etc/sysconfig/network-scripts/ifcfg-eth0
systemctl restart network
