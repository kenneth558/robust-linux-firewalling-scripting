#!/bin/bash
#  chmod this script as 7nn becasue it gets modified by another script (remakerebuildiptabesfromiptables)
# THIS SCRIPT IS LAUNCHED IN CRONTAB AT REBOOT AND OFTEN THEREAFTER FOR REAL-TIME FIREWALLING BLACKLIST MAINTENANCE
#This script will add or remove to iptables (IPv4) s_blacklist and d_blacklist chains
emaildestination='youremail@gmail.com'

if [ "x$(tail -n-1 $0|/usr/bin/awk '{printf $1}')" == "xpause" ]; then echo "$1" >> /home/homeowner/saveforlater;echo "$2" >> /home/homeowner/saveforlater;exit;fi

#This test will allow CIDR-type consolidated IPv4 address ranges
if ! [[ $1 =~ ^((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])((/[0-2]?[0-9])|(/3[0-2]))?$ ]];then
    echo "This script requires a valid IP address besides the script name: $1" >> "$0.log"
    exit
fi

if [ $(($(/sbin/iptables -wnL s_whitelist|grep --line-buffered -cwm 1 "$1"))) -eq 0 ] && [ $(($(/sbin/iptables -wnL s_blacklist|grep --line-buffered -cwm 1 "$1"))) -eq 0 ] && [ "$2x" != "-rx" ] && [ "$3x" != "-rx" ]; then
      cmdline="/sbin/iptables -wI s_blacklist 1 -i eth0 -s $1 -m comment --comment \"$2\" -j DROP;/sbin/iptables -wI d_blacklist 1 -o eth0 -d $1 -m comment --comment \"$2\" -j DROP"
      echo "$cmdline" >> /home/homeowner/buildiptables.sh
      if [ $(tail -n-15 /var/log/knockd.log| stdbuf -o0 grep -cwm 1 "$1: openAll: Stage") -eq 0 ]; then
          eval "$cmdline"
      else
          echo "if [ \$(/sbin/iptables -wL INPUT -n|grep --line-buffered -cwm 1 $1) -eq 0 ] && [ \$(/sbin/iptables -wL s_blacklist -n|grep --line-buffered -cwm 1 $1) -eq 0 ]; then /sbin/iptables -wI s_blacklist 1 -i eth0 -s $1 -m comment --comment \"$2\" -j DROP;/sbin/iptables -wI d_blacklist 1 -o eth0 -d $1 -m comment --comment \"$2\" -j DROP;if [ $(/sbin/iptables -wnvL INPUT|/usr/bin/stdbuf -o0 grep -m 1 -c ESTABLISHED) == \"1\" ];then /etc/init.d/netfilter-persistent save;fi;fi"|at now +2 minute
      fi
else
     if [ "$2x" == "-rx" ] || [ "$3x" == "-rx" ];then
         until [ $(/sbin/iptables -wnL s_blacklist|grep  -cwm 1 "$1") == "0" ] && [ $(/sbin/iptables -wnL d_blacklist|grep  -cwm 1 "$1") == "0" ];do
                 cmdline0="[[ \$(/sbin/iptables -wnL s_blacklist --line-numbers|grep -wm 1 $1|/usr/bin/awk '{print \$1}') -gt 0 ]] && /sbin/iptables -wD s_blacklist \$(/sbin/iptables -wnL s_blacklist --line-numbers|grep -wm 1 $1|/usr/bin/awk '{print \$1}');"
                 cmdline0+="[[ \$(/sbin/iptables -wnL d_blacklist --line-numbers|grep -wm 1 $1|/usr/bin/awk '{print \$1}') -gt 0 ]] && /sbin/iptables -wD d_blacklist \$(/sbin/iptables -wnL d_blacklist --line-numbers|grep -wm 1 $1|/usr/bin/awk '{print \$1}')"
                 until eval "$cmdline0";
                    do sleep 1;
                 done;
                 echo "$cmdline0" >> /home/homeowner/buildiptables.sh
                 echo "$cmdline0"|mail -s "Firewall blacklist $1" "$emaildestination"
         done
     fi
fi
#  The lines below this are for detecting the knock and launching email fetch when the email-reader triggering port is knocked
#  Notice that the email-reader triggering port is gotten from iptables INPUT chain rule with email-reader in its comment
#  That rule will look like this:  LOG        tcp  --  eth0   *       0.0.0.0/0            0.0.0.0/0            tcp dpt:1958 /* This rule ensures email-reader port knock won't get ignored */ LOG flags 0 level 4
#  The rule would be created with a command like this (change the 7 and 1958 to fit you): iptables -wI INPUT 7 -i eth0 -p tcp --dport 1958 -j LOG -m comment --comment "This rule ensures email-reader port knock won't get ignored"
[[ $(grep -c "#running" <(tail -n-1 /home/homeowner/email_fetch_parse)) -gt 0 ]] && exit
[[ -z "$2" ]] || \
  (startlen2=${#2}
   portnum=${2##*DPT=}
   if [ $((startlen2)) -gt ${#portnum} ];then
       [ "x${portnum%% *}" == "x$(/sbin/iptables -wnvL INPUT --line-numbers|grep -wm 1 "email-reader"|grep -Eo "dpt:[0-9]{1,5}"|grep -Eo "[0-9]{1,5}")" ] && nohup /home/homeowner/email_fetch_parse &
   fi)

if [ $(/sbin/iptables -wnvL INPUT|stdbuf -o0 grep -m 1 -c ESTABLISHED) == "1" ]; then /etc/init.d/netfilter-persistent save;fi
