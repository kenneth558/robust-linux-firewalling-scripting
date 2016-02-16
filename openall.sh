#!/bin/bash

#This script will add or remove to iptables (IPv4) s_whitelist and d_whitelist chains

#This test will allow CIDR-type consolidated IPv4 address ranges
if ! [[ $1 =~ ^((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])((/[0-2]?[0-9])|(/3[0-2]))?$ ]]; then
    echo "This script requires a valid IP address besides the script name" >> $0.log;
    exit;
fi

if [ $(/sbin/iptables -wnL s_whitelist|grep  -cwm 1 "$1") == "0" ];then # || [ "$2x" != "-rx" ]; then
       if [ "$2x" != "-rx" ];then
             cmdline0="/sbin/iptables -wI s_whitelist 1 -i eth0 -s $1  -m comment --comment \"$2 $(date)\" -j ACCEPT;/sbin/iptables -wI d_whitelist 1 -o eth0 -d $1 -m comment --comment \"$2 $(date)\" -j ACCEPT"
             echo "$cmdline0" >> /home/homeowner/buildiptables.sh
             [ ! -z "$cmdline0" ] && (until eval "$cmdline0"; do sleep 1; done)
             echo "$cmdline0"|mail -s "Firewall whitelist $1" "youremail@gmail.com"
       fi
else
    if [ "$2x" == "-rx" ];then
        until [ $(/sbin/iptables -wnL s_whitelist|grep  -cwm 1 "$1") == "0" ] && [ $(/sbin/iptables -wnL d_whitelist|grep  -cwm 1 "$1") == "0" ];do
              cmdline0="[[ \$(/sbin/iptables -wnL s_whitelist --line-numbers|grep -wm 1 $1|/usr/bin/awk '{print \$1}') -gt 0 ]] && /sbin/iptables -wD s_whitelist \$(/sbin/iptables -wnL s_whitelist --line-numbers|grep -wm 1 $1|/usr/bin/aw$
              cmdline0+="[[ \$(/sbin/iptables -wnL d_whitelist --line-numbers|grep -wm 1 $1|/usr/bin/awk '{print \$1}') -gt 0 ]] && /sbin/iptables -wD d_whitelist \$(/sbin/iptables -wnL d_whitelist --line-numbers|grep -wm 1 $1|/usr/bin/a$
              echo "$cmdline0" >> /home/homeowner/buildiptables.sh
              until eval "$cmdline0"; do sleep 1; done
        done
    fi
fi
if [ $(/sbin/iptables -wnvL INPUT|stdbuf -o0 grep -m 1 -c ESTABLISHED) == "1" ]; then /etc/init.d/netfilter-persistent save; fi
exit
