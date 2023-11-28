#!/bin/bash
clear
iptables -t nat -F
iptables -F

echo 1 > /proc/sys/net/ipv4/ip_forward

IFRO=192.168.56.0/24
GATEWAY=192.168.56.2
GATE=192.168.100.1
DNS1=192.168.100.2
WEB=192.168.100.3
REDE=192.168.100.0/24


iptables -t nat -A POSTROUTING -s $REDE -j MASQUERADE

iptables -A FORWARD -p tcp -s $IFRO -d $GATEWAY --dport 51000 -j ACCEPT
iptables -A FORWARD -p tcp -s $GATEWAY -d $IFRO --sport 51000 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $IFRO -d $GATEWAY --dport 51000 -j DNAT --to $GATE:22

iptables -A FORWARD -p tcp -s $IFRO -d $GATEWAY --dport 52000 -j ACCEPT
iptables -A FORWARD -p tcp -s $GATEWAY -d $IFRO --sport 52000 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $IFRO -d $GATEWAY --dport 52000 -j DNAT --to $DNS1:22

iptables -A FORWARD -p tcp -s $IFRO -d $GATEWAY --dport 53000 -j ACCEPT
iptables -A FORWARD -p tcp -s $GATEWAY -d $IFRO --sport 53000 -j ACCEPT
iptables -t nat -A PREROUTING -p tcp -s $IFRO -d $GATEWAY --dport 53000 -j DNAT --to $WEB:22

echo "Firewall ligado"
