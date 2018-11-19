# jail-opencanary-raspi
Jailing opencanary-raspi edition with firejail

- apt install bridge-utils firejail
- Remove all sudo statements within portscan.py module (grep -R sudo /home/pi/canary-env/)
- create iptables rules manually with iptables-save and put them to /etc/firejail/opencanary.net
- create opencanary.profile

create bridge interface for networking

- sudo brctl addbr br0
- sudo ifconfig br0 10.10.20.1/24 up
- ifconfig -a

as root
- echo "1" > /proc/sys/net/ipv4/ip_forward
 
# netfilter cleanup
- sudo iptables --flush
- sudo iptables -t nat -F
- sudo iptables -X
- sudo iptables -Z
- sudo iptables -P INPUT ACCEPT
- sudo iptables -P OUTPUT ACCEPT
- sudo iptables -P FORWARD ACCEPT
 
# netfilter network address translation
- (not used for server) sudo iptables -t nat -A POSTROUTING -o eth0 -s 10.10.20.0/24  -j MASQUERADE

# host port xx forwarded to sandbox port 20xx
- sudo iptables -t nat -A PREROUTING -p tcp --dport 21 -j DNAT --to 10.10.20.10:2021
- sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j DNAT --to 10.10.20.10:2022
- sudo iptables -t nat -A PREROUTING -p tcp --dport 5000 -j DNAT --to 10.10.20.10:5000

# Start jailed opencanary
- sudo firejail --name=opencanary --noexec=/tmp --profile=/etc/firejail/opencanary.profile --private-dev --net=br0 --ip=10.10.20.10 --netfilter=/etc/firejail/opencanary.net /home/pi/canary-env/bin/opencanaryd --dev

# Connect to jailed opencanary
- firejail --list
- firejail --join=opencanary

# Issues
- Routing still not working correclty
- firejail only start with sudo (permissions for twistd.pid file)
- Read of /var/log/kern.log
- Re-Work heartbeat needed (work with firejail --list)
