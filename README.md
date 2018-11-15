# jail-opencanary-raspi
Jailing opencanary-raspi edition with firejail

apt install bridge-utils firejail
Remove all sudo statements within portscan.py module
create iptables rules manually with iptables-save and put them to /etc/firejail/opencanary.net
create opencanary.profile

create bridge interface for networking

sudo brctl addbr br0
sudo ifconfig br0 10.10.20.1/24 up
ifconfig -a

as root
echo "1" > /proc/sys/net/ipv4/ip_forward
 
# netfilter cleanup
sudo iptables --flush
sudo iptables -t nat -F
sudo iptables -X
sudo iptables -Z
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
 
# netfilter network address translation
iptables -t nat -A POSTROUTING -o eth0 -s 10.10.20.0/24  -j MASQUERADE

# host port xx forwarded to sandbox port 20xx
iptables -t nat -A PREROUTING -p tcp --dport 21 -j DNAT --to 10.10.20.10:2021
iptables -t nat -A PREROUTING -p tcp --dport 22 -j DNAT --to 10.10.20.10:2022
iptables -t nat -A PREROUTING -p tcp --dport 5000 -j DNAT --to 10.10.20.10:5000

# Start jailed opencanary
firejail --profile=/etc/firejail/opencanary.profile --private-dev --net=br0 --netfilter=/etc/firejail/opencanary.net /home/pi/canary-env/bin/opencanaryd --dev

# Connect to jailed opencanary
firejail --list
firejail --join=<PID>
