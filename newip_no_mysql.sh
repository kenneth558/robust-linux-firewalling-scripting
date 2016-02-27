#!/bin/bash
#site-specific variables:
webpageprotocol=https
emailsubjectline='New IP address for firewall'
emaildestination='youremail@gmail.com'
file_to_store_ip='/usr/oldip'

#variable to hold gotten public IP address
ip_from_resolver=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [[ $ip_from_resolver =~ ^((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$ ]];
then
    if ( [ -f $file_to_store_ip ] );
    then
        if [[ $(< $file_to_store_ip) =~ ^((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$ ]] && [[ $ip_from_resolver == $(< $file_to_store_ip) ]];
        then
            exit
        fi
    fi
else
    exit
fi

#if [ $(/sbin/iptables -w -L INPUT -nv --line-numbers|grep -m 1 -c -w $ip_from_resolver) == 0 ]; then
#    echo "$ip_from_resolver not found in INPUT chain"
#    /sbin/iptables -w -I INPUT $(/sbin/iptables -w -L INPUT -nv --line-numbers|grep -m 1 -w DROP|awk  '{print $1 }') -i eth0 -s $ip_from_resolver -j ACCEPT
#fi
echo -e "$webpageprotocol://$ip_from_resolver/zm\
\nhttp://$ip_from_resolver:9080\
\nhttp://$ip_from_resolver:8080\
\nhttp://$ip_from_resolver:7080\
\nhttp://$ip_from_resolver:6080\
\nhttp://$ip_from_resolver:5080\
\nhttp://$ip_from_resolver:4080\
\nssh homeowner@$ip_from_resolver\
\nnc -w 1 $ip_from_resolver\
\n$webpageprotocol://192.168.3.3/zm\
\nhttp://192.168.3.9:9080\
\nhttp://192.168.3.8:8080\
\nhttp://192.168.3.7:7080\
\nhttp://192.168.3.6:6080\
\nhttp://192.168.3.5:5080\
\nhttp://192.168.3.4:4080\
\nssh homeowner@192.168.3.1\
\n" | mail -s "$emailsubjectline" $emaildestination
echo $ip_from_resolver > $file_to_store_ip

#echo $webpageprotocol://$ip_from_resolver/zm | mail -s "$emailsubjectline" $emaildestination
#mysql -D zm -u root -p$mysqlpsswd -e "update Config set Value='$webpageprotocol://$ip_from_resolver/zm' where Name='ZM_URL';"
echo $ip_from_resolver > $file_to_store_ip
