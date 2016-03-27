#! /bin/bash
########### echo "Sorry, still under development ... press a key to continue"
########### read -n1 -s
usrdir="";localdir="";sharedir="";bindir="";sbindir="";binaryflag="-b";dirsign="";counter=0
D2b=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
until whereispath="$usrdir$localdir$sharedir$bindir$sbindir$dirsign""whereis";[[ ++counter -eq 64 ]] || [[ "$($whereispath $binaryflag whereis &> /dev/null;echo $?)" == "0" ]];do
    ! [[ -z "$binaryflag" ]] && binaryflag="" && continue
    binaryflag="-b"
    dirsign="/"
    usrdir="";localdir="";sharedir="";bindir="";sbindir=""
    cntr="${D2b[counter]}"
    [[ "${cntr:0:1}" == "1" ]] && usrdir="/usr"
    [[ "${cntr:1:1}" == "1" ]] && localdir="/local"
    [[ "${cntr:2:1}" == "1" ]] && sharedir="/share"
    [[ "${cntr:3:1}" == "1" ]] && bindir="/bin"
    [[ "${cntr:4:1}" == "1" ]] && sbindir="/sbin"
done
if [[ counter -eq 64 ]];then echo "Unable to locate executable files on your system";exit;fi
whereispath="${whereispath#*:}";whereispath="${whereispath# }";whereispath="${whereispath%% *}"
unamepath="$($whereispath $binaryflag uname)"
unamepath="${unamepath#*:}";unamepath="${unamepath# }";unamepath="${unamepath%% *}"
sortpath="$($whereispath $binaryflag sort)"
sortpath="${sortpath#*:}";sortpath="${sortpath# }";sortpath="${sortpath%% *}"
headpath="$($whereispath $binaryflag head)"
headpath="${headpath#*:}";headpath="${headpath# }";headpath="${headpath%% *}"
tailpath="$($whereispath $binaryflag tail)"
tailpath="${tailpath#*:}";tailpath="${tailpath# }";tailpath="${tailpath%% *}"
sedpath="$($whereispath $binaryflag sed)"
sedpath="${sedpath#*:}";sedpath="${sedpath# }";sedpath="${sedpath%% *}"
wcpath=$($whereispath $binaryflag wc);wcpath="${wcpath#*:}";wcpath="${wcpath# }";wcpath="${wcpath%% *}"
min_bash_version_tested="4.3.11";! [[ "$($sortpath <<<"$(echo -e "$BASH_VERSION\n$min_bash_version_tested")"|$headpath -n 1)" == "$min_bash_version_tested" ]] && trap "echo If you had run-time errors, your version of bash might be too old" EXIT
#    Yes, I know awk would be better, but I wanted this menu portion compatible with Mac...
#   some effort was given to making the menu aspect of this helper script compatible with Mac running 3.2.57 bash
if [[ "$($unamepath)" =~ BSD ]] || [[ "$($unamepath)" =~ Darwin ]];then echo -e "This firewalling solution does not accommodate Mac nor BSD due to"\
"\niptables and crontab dysfunction.";exit;fi
if ! [ "$(whoami)" == "root" ];then echo -e "\nWithout being launched by su, this script\
 won't be able to do anything except\
\ndisplay menus.  No control of this computer can be made by this script unless\
\nre-launched by root.  Press a key to acknowledge, Ctrl-c to abort\n";read -n1 -s;fi
#  Beginning of copyright message
echo -e "\nCopyright 2016 - Kenneth L. Anderson MCSE, RDH, BGS, BT"\
     "\n\nThis work of authorship is made available to you under only one out of the"\
     "\nfollowing two arrangements.  In both arrangements, this copyright message must"\
     "\nremain with this work of authorship and any and all of its derivatives."\
     "\n\n1.  Arrangement for your freedom from monetary obligation to the author:"\
     "\n - This copyright message must continue to be displayed at launch time"\
     "\n - This copyright message includes the statement"\
     "\n\n\"       Jesus Christ is Lord of all  ... press a key to acknowledge\""\
     "\n\ndisplayed on its own line with blank lines adjacently both above and below"\
     "\nsaid nstatement and rendered statically without attempt made to render said"\
     "\nstatement transiently."\
     "\n\n2.  Arrangement for your freedom from copyright display obligation, or to"\
     "\ncontribute, see the comments within the source code of this script"
######## echo -e "\n\n       Jesus Christ is Lord of all  ... press a key to acknowledge\n"
######## read -n1 -r
#    Arrangement for your freedom from copyright display obligation: Prior to
#  distribution, email me the author: kenlovesjesus at gmail dot com to arrange USD payment.
#  You'll insert name and details of party responsible for making the payment to the
#  author into comments in the script's sourcecode.  I, the author, will only give
#  you permission to free yourself from copyright display obligation in writing addressed
#  directly to the party making payment to me after you have made contact with me.
#  End of copyright message
#
#
# firewall install helper script layout
#
# Options:
# Email parser on/off
#  --- email address, password
#  --- command set (suggest default set, allow deletes, adds and mods)
#
# firewall on/off
#   --- check if dual interface, allow select of dual from display of suggested
#   --- determine private IP range, allow for changing
#   --- track first time probers (forms dynamic blacklist or file)
#   ---  build  iptables rules reconstructer shell script
#   ---  suggest starter iptables ruleset scenario, allowing for blacklist or whitelist to have higher pwr
#   ---- get list of alert email destinations with authenticating email addr and pw
#  --- allow option for always-on ports like 80
#  --- don't forget persistence
#
# dhcp notifier on/off
#   ---- get list of alert email destinations with authenticating email addr and pw
#
# test emailing while setting up
#
# remind about ssh keys
#
# set up port knocking
#  ---- normal port knocking
#   ---- port knocking with lookup table
#   ---- port knock to fetch remote controlling email
#
#  accommodate reconfiguration of already installed system
#
awkpath="$($whereispath $binaryflag awk)" # some occurances removed due to inconsistencies with macs
awkpath="${awkpath#*:}";awkpath="${awkpath# }";awkpath="${awkpath%% *}"
pythonpath="$($whereispath $binaryflag python)"
pythonpath="${pythonpath#*:}";pythonpath="${pythonpath# }";pythonpath="${pythonpath%% *}"
greppath="$($whereispath $binaryflag grep)"
greppath="${greppath#*:}";greppath="${greppath# }";greppath="${greppath%% *}"
ifconfigpath="$($whereispath $binaryflag ifconfig)"
ifconfigpath="${ifconfigpath#*:}";ifconfigpath="${ifconfigpath# }";ifconfigpath="${ifconfigpath%% *}"
uniqpath="$($whereispath $binaryflag uniq)"
uniqpath="${uniqpath#*:}";uniqpath="${uniqpath# }";uniqpath="${uniqpath%% *}"
findpath="$($whereispath $binaryflag find)"
findpath="${findpath#*:}";findpath="${findpath# }";findpath="${findpath%% *}";
rhel="$($whereispath $binaryflag chkconfig)"
rhel="${rhel#*:}";rhel="${rhel# }";rhel="${rhel%% *}"
eval "$pythonpath -c \"import platform;print(platform.linux_distribution()[0])\" &> /dev/null > \"distributionby.${0#*/}\"" || eval "echo -e \"Functionality may be limited due to inability to determine distribution type\n...press a key to continue...\";read -n1 -s" || eval "echo $OSTYPE > \"distributionby.${0#*/}\""
eval "$ifconfigpath -a|$awkpath -F'^ ' '{print \$1}'|$awkpath '{print \$1}'|$greppath -vw lo|xargs" > "interfacesby.${0#*/}"
# echo "Script-required items: whereis path=$whereispath, awk path=$awkpath, python path=$pythonpath, grep path=$greppath, ifconfig path=$ifconfigpath, uniq path=$uniqpath, sort path=$sortpath, head path=$headpath";exit
#
# Introduction and what we'll do

startscreen="\n\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Main Configuration Screen\
\n                SELECT DESIRED OPTIONS FOR THIS INSTALLATION\
\n\n\n                            (f) firewalling\
\n\n                            (r) email remote control\
\n\n                            (d) dynamic IP address change notifier\
\n\n                            (p) port knocking\
\n\n                            (?) context helpful information\
\n\n
\nTyping the letters f, r, d, p, optionally followed by a question mark, or just\
\nplain ? with no letters, select all of the five services listed above that you\
\nwant, then press ENTER: (or Ctrl-c at any time to terminate installer)"
ghscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\n                              HELPER SCRIPT OVERVIEW\
\nThis set of Linux scripts can install several capabilities useful for\
\nhomeowners up to large enterprises that are Internet-connected with Linux.\
\nAdvantages to using scripting vs. a compiled program include\
\n\n - you, the owner, don't need to learn new software and config files\
\n - easier adaptation and expansion by you, the owner\
\n - less disk and memory space used\
\n - less internal complexity means less risk of programming bugs and\
\n     insurmountable limitations\
\n - less need to restart processes means fewer operating interruptions\
\n - no obsolescence"
fwscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\n                        FIREWALLING WITH THIS SCRIPT SET\
\n( As you read, please realize the difference between this installation \"helper\
\nscript\" that you are running now and the \"script set\" it helps you install )\
\n\nTo configure firewalling, port-knocking, or email remote control, iptables &\
\nnetfilter-persistent are required if not already present.  These are standard\
\nfor any Linux firewalling.  As far as manual control of iptables during run\
\ntime, this script set is friendly.  It will simply configure iptables - an\
\ninitial configuration by the helper script, then periodic configurations of\
\niptables throughout the course of normal operations by the installed script set.\
\nUnlike what exists with ufw, shorewall, and fail2ban, no ongoing integration\
\nwith iptables will exist to interfere at any time with direct user adjustment of\
\nthe iptables ruleset.\
\nFirewalling options this install script can alter from the script set defaults:\
\n  -- Stop probe logging/blacklisting to save space or if you're just not curious\
\n  -- Open specific ports to offer public services\
\n  -- Allow swap interfaces (default=public:eth0, private:eth1)\
\n  -- Force single-interface firewalling even though two interfaces exist\
\n  -- Alter the IP address of the private-side interface from 192.168.3.1\
\n\n* No testing has been done using DHCP client nor server on the private interface"
rcscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\n                  REMOTE CONTROL VIA EMAIL WITH THIS SCRIPT SET\
\n( As you read, please realize the difference between this installation \"helper\
\nscript\" that you are running now and the \"script set\" it helps you install )\
\n\nWhat we mean by Remote Control Via Email:  You find yourself travelling far away\
\nfrom home, and thus, far away from this computer you are configuring.  You\
\ndecide you need this computer to do a few things for you now before you return.\
\nOne is to turn on and off one of the electrical outlets that it controls through\
\na USB-connected Arduino board.  You also remember that there is an old iptables\
\nrule whitelisting an IP address that belongs no longer belongs to you, so you\
\nneed your home system to remove it from the iptables whitelist.  This and more\
\nis possible if you just connect that Arduino you've built and run this script.\
\nThis helper script will need from you name and password of the email account\
\nthat this computer will retrieve the emails from that you send to it.  This\
\nhelper script will test its functionality and give you a choice of which port\
\nnumber you want to use (knock) to trigger your system to read and parse emails.\
\nIdeally, you would want to choose a port number that never gets probed by\
\nthe hackers of the world.  Logging probed ports (configured in the firewall\
\nsection of this helper script) would be a handy reference here.\
\n\n* No testing has been done using DHCP client nor server on the private interface"
dascreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\n          EMAIL NOTIFY OF DYNAMIC IP ADDRESS CHANGE WITH THIS SCRIPT SET\
\n( As you read, please realize the difference between this installation \"helper\
\nscript\" that you are running now and the \"script set\" it helps you install )\
\n\nTo configure firewalling, port-knocking, or email remote control, iptables &\
\nnetfilter-persistent are required if not already present.  These are standard\
\nfor any Linux firewalling.  As far as manual control of iptables during run\
\ntime, this script set is friendly.  It will simply configure iptables - an\
\ninitial configuration by the helper script, then periodic configurations of\
\niptables throughout the course of normal operations by the installed script set.\
\nUnlike what exists with ufw, shorewall, and fail2ban, no ongoing integration\
\nwith iptables will exist to interfere at any time with direct user adjustment of\
\nthe iptables ruleset.\
\nFirewalling options this install script can alter from the script set defaults:\
\n  -- Stop probe logging/blacklisting to save space or if you're just not curious\
\n  -- Open specific ports to offer public services\
\n  -- Allow swap interfaces (default=public:eth0, private:eth1)\
\n  -- Force single-interface firewalling even though two interfaces exist\
\n  -- Alter the IP address of the private-side interface from 192.168.3.1\
\n\n* No testing has been done using DHCP client nor server on the private interface"
pkscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\n                        PORT KNOCKING WITH THIS SCRIPT SET\
\n( As you read, please realize the difference between this installation \"helper\
\nscript\" that you are running now and the \"script set\" it helps you install )\
\n\nTo configure firewalling, port-knocking, or email remote control, iptables &\
\nnetfilter-persistent are required if not already present.  These are standard\
\nfor any Linux firewalling.  As far as manual control of iptables during run\
\ntime, this script set is friendly.  It will simply configure iptables - an\
\ninitial configuration by the helper script, then periodic configurations of\
\niptables throughout the course of normal operations by the installed script set.\
\nUnlike what exists with ufw, shorewall, and fail2ban, no ongoing integration\
\nwith iptables will exist to interfere at any time with direct user adjustment of\
\nthe iptables ruleset.\
\nFirewalling options this install script can alter from the script set defaults:\
\n  -- Stop probe logging/blacklisting to save space or if you're just not curious\
\n  -- Open specific ports to offer public services\
\n  -- Allow swap interfaces (default=public:eth0, private:eth1)\
\n  -- Force single-interface firewalling even though two interfaces exist\
\n  -- Alter the IP address of the private-side interface from 192.168.3.1\
\n\n* No testing has been done using DHCP client nor server on the private interface"
answer=""
singinterf="\nBased on finding only one pluggable network interface, your intentions seem\
\nto be to have this firewalling computer be a terminal (end) device rather than\
\nan inline (passthrough) device.  That would result in any protective\
\nfirewalling you'll set up next to apply only to this computer.  If instead you\
\nwant this firewalling computer to protect other devices with its firewalling\
\nservices, select"

until ! [ -z "$answer" ];do
    clear
    echo -e "$startscreen"
########### remove answer and char set line below and uncomment out next line
    while true;do answer="fdrp";char="";[[ -z "$char" ]] && break
#     while IFS= read  -s -n1 char;do [[ -z "$char" ]] && break
        [[ "$answer$char" == "?" ]] && break
        if [[ "$(printf "%d" "'$char")" == "27" ]];then # escape or extended key has been detected
            read -r -s -t 1 -n2 # read & discard 2nd extended key field, timeout if real escape
        elif [ "${answer%$char*}" == "$answer" ] && [[ "$char" =~ [frdpFRDP] ]];then
            [[ "$char" =~ [FRDP] ]] && char="${char,}"
            printf "$char"
            answer="$answer$char"
        elif [ "$char" == "?" ] && ! [ "${answer: -1}" == " " ];then
            printf "$char "
            answer="$answer$char "
        else
            [[ "$(printf "%d" "'$char")" == "127" ]] && ! [[ -z "$answer" ]] && answer="${answer:0: -1}" # handles the backspace character
            printf "\r$answer    \r$answer" # needed b/c when several keys are pressed simultaneously only first gets silented
        fi
    done
    if [ -z "$answer$char" ];then
        exit
    elif ! [[ "${answer##*\?}" == "$answer" ]] || [[ "$answer$char" == "?" ]];then
        clear;printf "Selections: $answer$char";echo -e "  Since info is selected, no changes are to be made"
        [[ "$answer$char" == "?" ]] && (echo -e "$ghscreen";read -n1 -s -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%f*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$fwscreen";read -n1 -s -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%r*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$rcscreen";read -n1 -s -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%d*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$dascreen";read -n1 -s -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%p*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$pkscreen";read -n1 -s -p "                         Press a key to continue...";echo "")
        answer=""
    else
        until false;do  # this loop is to set path vars after pkgs get installed, every last pkg so paths populate even after new installs
      until [ "$goahead" == "true" ];do
        rhel=$(chkconfig --list 2> /dev/null | grep iptables)
        installers=(apt-get "install --fix-missing" dnf install yum install zypper install emerge "" pacman -S pkg install pkg_add "" xbps-install -Sy brew install port install)
        for installer in {0..10};do
              installerpath=$($whereispath $binaryflag ${installers[$(($installer * 2))]});installerpath="${installerpath#*:}";installerpath="${installerpath# }";installerpath="${installerpath%% *}"
              [[ -z "$installerpath" ]] && continue
              installerpath+="  ${installers[$(($installer * 2 + 1))]}"
              break
        done
#  packages required to install everything
             inotifywaitpath=$($whereispath $binaryflag inotifywait);inotifywaitpath="${inotifywaitpath#*:}";inotifywaitpath="${inotifywaitpath# }";inotifywaitpath="${inotifywaitpath%% *}"
             iptablespath=$($whereispath $binaryflag iptables);iptablespath="${iptablespath#*:}";iptablespath="${iptablespath# }";iptablespath="${iptablespath%% *}"
             iptabperspath=$($findpath / -maxdepth 3 -name *persistent|$greppath -vw doc|$greppath -vw src|$greppath -vw sys|$greppath -e iptables -e netfilter|$greppath -m 1 -e init.d 2> /dev/null)
             dhcp_lease_path=$($findpath / -maxdepth 5 -name dhclient*.lease* 2> /dev/null)
             stdbufpath=$($whereispath $binaryflag stdbuf);stdbufpath="${stdbufpath#*:}";stdbufpath="${stdbufpath# }";stdbufpath="${stdbufpath%% *}"
             crontabpath=$($whereispath $binaryflag crontab);crontabpath="${crontabpath#*:}";crontabpath="${crontabpath# }";crontabpath="${crontabpath%% *}"
             sleeppath=$($whereispath $binaryflag sleep);sleeppath="${sleeppath#*:}";sleeppath="${sleeppath# }";sleeppath="${sleeppath%% *}"
             ifdownpath=$($whereispath $binaryflag ifdown);ifdownpath="${ifdownpath#*:}";ifdownpath="${ifdownpath# }";ifdownpath="${ifdownpath%% *}"
             ifuppath=$($whereispath $binaryflag ifup);ifuppath="${ifuppath#*:}";ifuppath="${ifuppath# }";ifuppath="${ifuppath%% *}"
             pspath=$($whereispath $binaryflag ps);pspath="${pspath#*:}";pspath="${pspath# }";pspath="${pspath%% *}"
             datepath=$($whereispath $binaryflag date);datepath="${datepath#*:}";datepath="${datepath# }";datepath="${datepath%% *}"
             bcpath=$($whereispath $binaryflag bc);bcpath="${bcpath#*:}";bcpath="${bcpath# }";bcpath="${bcpath%% *}"
             atpath=$($whereispath $binaryflag at);atpath="${atpath#*:}";atpath="${atpath# }";atpath="${atpath%% *}";! [[ "${atpath: -2:2}" == "at" ]] && atpath=""
             nicepath=$($whereispath $binaryflag nice);nicepath="${nicepath#*:}";nicepath="${nicepath# }";nicepath="${nicepath%% *}"
             mailpath=$($whereispath $binaryflag mail);mailpath="${mailpath#*:}";if [ -z "$mailpath" ];then
             mailpath=" $($whereispath $binaryflag mailx)";mailpath="${mailpath#*:}";fi;mailpath="${mailpath# }";mailpath="${mailpath%% *}"
             postmappath=$($whereispath $binaryflag postmap);postmappath="${postmappath#*:}";postmappath="${postmappath# }";postmappath="${postmappath%% *}"
             notinstalled=""
             if ! [[ "${answer%f*}" == "$answer" ]];then
                 [[ -z "$inotifywaitpath" ]] && notinstalled+="inotify-tools\n"
                 [[ -z "$iptablespath" ]] && notinstalled+="iptables\n"
                 [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\n"
                 [[ -z "$stdbufpath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$mailpath" ]] && notinstalled+="mailutils\n"
                 [[ -z "$crontabpath" ]] && notinstalled+="cronie\nbcron\n"
                 [[ -z "$datepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$bcpath" ]] && notinstalled+="bc\n"
                 [[ -z "$atpath" ]] && notinstalled+="at\n"
                 [[ -z "$nicepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$postmappath" ]] && notinstalled+="postmap\n"
                 [[ -z "$notinstalled" ]] && break 2
             fi
             if ! [[ "${answer%r*}" == "$answer" ]];then
                 [[ -z "$inotifywaitpath" ]] && notinstalled+="inotify-tools\n"
                 [[ -z "$iptablespath" ]] && notinstalled+="iptables\n"
                 [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\n"
                 [[ -z "$stdbufpath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$mailpath" ]] && notinstalled+="mailutils\n"
                 [[ -z "$crontabpath" ]] && notinstalled+="cronie\nbcron\n"
                 [[ -z "$datepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$bcpath" ]] && notinstalled+="bc\n"
                 [[ -z "$atpath" ]] && notinstalled+="at\n"
                 [[ -z "$nicepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$postmappath" ]] && notinstalled+="postmap\n"
                 [[ -z "$notinstalled" ]] && break 2
             fi
             if ! [[ "${answer%d*}" == "$answer" ]];then
                 [[ -z "$inotifywaitpath" ]] && notinstalled+="inotify-tools\n"
                 [[ -z "$iptablespath" ]] && notinstalled+="iptables\n"
                 [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\n"
                 [[ -z "$stdbufpath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$mailpath" ]] && notinstalled+="mailutils\n"
                 [[ -z "$crontabpath" ]] && notinstalled+="cronie\nbcron\n"
                 [[ -z "$datepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$bcpath" ]] && notinstalled+="bc\n"
                 [[ -z "$atpath" ]] && notinstalled+="at\n"
                 [[ -z "$nicepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$postmappath" ]] && notinstalled+="postmap\n"
                 [[ -z "$notinstalled" ]] && break 2
             fi
             if ! [[ "${answer%p*}" == "$answer" ]];then
                 [[ -z "$inotifywaitpath" ]] && notinstalled+="inotify-tools\n"
                 [[ -z "$iptablespath" ]] && notinstalled+="iptables\n"
                 [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\n"
                 [[ -z "$stdbufpath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$mailpath" ]] && notinstalled+="mailutils\n"
                 [[ -z "$crontabpath" ]] && notinstalled+="cronie\nbcron\n"
                 [[ -z "$datepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$bcpath" ]] && notinstalled+="bc\n"
                 [[ -z "$atpath" ]] && notinstalled+="at\n"
                 [[ -z "$nicepath" ]] && notinstalled+="coreutils\n"
                 [[ -z "$postmappath" ]] && notinstalled+="postmap\n"
                 [[ -z "$notinstalled" ]] && break 2
             fi
             notinstalled="$(echo -e "$notinstalled"|$sortpath|$uniqpath)"
             if ! [[ -z "$notinstalled" ]] && [[ -z "$installerpath" ]] && ! [[ "$ackd" == "true" ]];then
                  echo -e "\n\n                  UNABLE TO INSTALL ANY PROGRAMS ON YOUR SYSTEM\
\n\nThis helper script version is not advanced enough to install needed programs on\
\nsystems such as yours that don't use a common installer to install programs.\
\nFor this install script to serve its purpose for you, you'll need to install all\
\nnecessary programs yourself before anything referenced hereafter can succeed.\
\nConsider yourself lucky if this script does anything at all for you beyond this\
\npoint, but do understand that the programs most certainly won't get installed.\
\n\nThe necessary programs that won't get installed until you install them are:\
\n$notinstalled\
\n\nYou may install them in another terminal and resume here, or press Ctrl-c to\
\nterminate here, or press any other key to proceed as-is\
\n\n     Acknowledge by keypress..."
                  read -n1 -s;ackd="true"
             else
                  goahead="true"
             fi
        done # this loops here once when installer pgm not found
        clear
        if ! [ -z "$installerpath" ] && ! [ -z "$notinstalled" ];then # install what is needed
                  echo -e "Installation of\n$notinstalled\n\nwill begin after your keypress...";read -n1 -s
echo "Executing $installerpath $notinstalled"|$sedpath -e ':a' -e 'N' -e '$!ba' -e 's/\\n/ /g'
                  echo -e "$notinstalled"|$sedpath -e ':a' -e 'N' -e '$!ba' -e 's/\\n/ /g'|sudo xargs sh -c 'exec "$installerpath $@" < /dev/tty' sh
      fi
done  # this loop is to set path vars after pkgs get installed, every last pkg so paths populate even after new installs
######### remove commands after the do
       until false;do   directoryforscripts="/home/homeowner";break
            read -p "Specify the directory in which to install these scripts: " directoryforscripts
            ! [[ -d "$directoryforscripts" ]] && echo -e "\nHold up there, Speedy.  That directory doesn't exist.  Try again.\n" || break
       done
       echo "$directoryforscripts" > directoryforscripts
       install_buildiptablessh () {
            (cat <<BUILDIPTABLES.SH_END
echo 1 > /proc/sys/net/ipv4/ip_forward
$iptablespath -wF
$iptablespath -wX
$iptablespath -wt nat -F
$iptablespath -wt nat -X
$iptablespath -wt mangle -F
$iptablespath -wt mangle -X
$iptablespath -wt nat -P PREROUTING ACCEPT
$iptablespath -wt nat -P INPUT ACCEPT
$iptablespath -wt nat -P OUTPUT ACCEPT
$iptablespath -wt nat -P POSTROUTING ACCEPT
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 192.168.3.3
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp --dport 1026 -m comment --comment "remote router management" -j DNAT --to-destination 192.168.3.2:8081
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 4554,4080,8004 -j DNAT --to-destination 192.168.3.4
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 5554,5080,8005 -j DNAT --to-destination 192.168.3.5
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 6554,6080,8006 -j DNAT --to-destination 192.168.3.6
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 7554,7080,8007 -j DNAT --to-destination 192.168.3.7
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 8554,8080,8008 -j DNAT --to-destination 192.168.3.8
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 9554,9080,8009 -j DNAT --to-destination 192.168.3.9
$iptablespath -wt nat -I PREROUTING 1  -i eth0  -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 192.168.3.3
$iptablespath -wt nat -I POSTROUTING 1  -o eth0  -p all -j MASQUERADE
$iptablespath -wP INPUT ACCEPT
$iptablespath -wP FORWARD ACCEPT
$iptablespath -wP OUTPUT ACCEPT
$iptablespath -wN 3dot2not8081
$iptablespath -wN GATE1
$iptablespath -wN GATE2
$iptablespath -wN GATE3
$iptablespath -wN KNOCKED
$iptablespath -wN KNOCKING
$iptablespath -wN d_blacklist
$iptablespath -wN d_privateIPs
$iptablespath -wN d_static_trusted
$iptablespath -wN d_whitelist
$iptablespath -wN s_blacklist
$iptablespath -wN s_privateIPs
$iptablespath -wN s_static_trusted
$iptablespath -wN s_whitelist
$iptablespath -wI INPUT 1  -p all -m comment --comment "this is a comment" -m recent --rcheck --seconds 10 --name AUTH2 -j LOG --log-level 4
$iptablespath -wI INPUT 1  -p all -m comment --comment "this is a comment" -m recent --rcheck --seconds 10 --name AUTH2 -j GATE3
$iptablespath -wI INPUT 1  -p all -j KNOCKING
$iptablespath -wI INPUT 1  -i eth0  -d 127.0.0.0/8  -p all -m recent --set --name Knock1 -j DROP
$iptablespath -wI INPUT 1  -p all -m recent --update --seconds 60 --name DEFAULT -j DROP
$iptablespath -wI INPUT 1  -p all -j DROP
$iptablespath -wI INPUT 1  -p all -j LOG --log-level 4
$iptablespath -wI INPUT 1  -p all -j s_blacklist
$iptablespath -wI INPUT 1  -i eth0  -p all -j s_privateIPs
$iptablespath -wI INPUT 1  -p all -j s_whitelist
$iptablespath -wI INPUT 1  -i eth0  -p tcp --dport 1958 -m comment --comment "This rule ensures email-reader port knock won't get ignored" -j LOG --log-level 4
$iptablespath -wI INPUT 1  -p all -j s_static_trusted
$iptablespath -wI INPUT 1  -i eth1  -p all -j ACCEPT
$iptablespath -wI INPUT 1  -d 192.168.3.2  -p all -j ACCEPT
$iptablespath -wI INPUT 1  -p all -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$iptablespath -wI FORWARD 1  ! -s 192.133.1.2  -p all -j ACCEPT
$iptablespath -wI FORWARD 1  -p all -j DROP
$iptablespath -wI FORWARD 1  -p all -j LOG --log-level 4
$iptablespath -wI FORWARD 1  -p all -j s_blacklist
$iptablespath -wI FORWARD 1  -p all -j d_privateIPs
$iptablespath -wI FORWARD 1  -p all -j s_privateIPs
$iptablespath -wI FORWARD 1  -p all -j d_blacklist
$iptablespath -wI FORWARD 1  -d 167.142.232.0/24  -p all -j ACCEPT
$iptablespath -wI FORWARD 1  -d 74.125.0.0/16  -p all -j ACCEPT
$iptablespath -wI FORWARD 1  -d 173.194.0.0/16  -p all -j ACCEPT
$iptablespath -wI FORWARD 1  -s 173.194.0.0/16  -p all -j ACCEPT
$iptablespath -wI FORWARD 1  -s 74.125.0.0/16  -p all -j ACCEPT
$iptablespath -wI FORWARD 1  -s 167.142.232.0/24  -p all -j ACCEPT
$iptablespath -wI FORWARD 1  -p all -j d_whitelist
$iptablespath -wI FORWARD 1  -p all -j s_whitelist
$iptablespath -wI FORWARD 1  -p all -j s_static_trusted
$iptablespath -wI FORWARD 1  -p all -j d_static_trusted
$iptablespath -wI FORWARD 1  -o eth0  -p all -j ACCEPT
$iptablespath -wI OUTPUT 1  -p all -j d_blacklist
$iptablespath -wI OUTPUT 1  -p all -j d_whitelist
$iptablespath -wI OUTPUT 1  -p all -j d_static_trusted
$iptablespath -wI OUTPUT 1  -d 207.177.27.130  -p all -j ACCEPT
$iptablespath -wI 3dot2not8081 1  -p all -j DROP
$iptablespath -wI 3dot2not8081 1  -p all -j LOG --log-level 4
$iptablespath -wI 3dot2not8081 1  -p tcp ! --dport 8081 -j ACCEPT
$iptablespath -wI 3dot2not8081 1  -p all -j s_whitelist
$iptablespath -wI GATE1 1  -p all -j DROP
$iptablespath -wI GATE1 1  -p tcp --dport 4080 -m recent --set --name AUTH1 -j DROP
$iptablespath -wI GATE2 1  -p all -j GATE1
$iptablespath -wI GATE2 1  -p tcp --dport 5080 -m recent --set --name AUTH2 -j DROP
$iptablespath -wI GATE2 1  -p all -m recent --remove --name AUTH1
$iptablespath -wI GATE3 1  -p all -j GATE1
$iptablespath -wI GATE3 1  -p tcp --dport 6080 -m recent --set --name AUTH3 -j DROP
$iptablespath -wI GATE3 1  -p all -m recent --remove --name AUTH2
$iptablespath -wI KNOCKED 1  -p all -j GATE1
$iptablespath -wI KNOCKED 1  -i eth0  -p all -j ACCEPT
$iptablespath -wI KNOCKED 1  -p all -m recent --remove --name AUTH3
$iptablespath -wI KNOCKING 1  -p all -j GATE1
$iptablespath -wI KNOCKING 1  -p all -m recent --rcheck --seconds 90 --name AUTH1 -j GATE2
$iptablespath -wI KNOCKING 1  -p all -m recent --rcheck --seconds 90 --name AUTH2 -j GATE3
$iptablespath -wI KNOCKING 1  -p all -m recent --rcheck --seconds 90 --name AUTH3 -j KNOCKED
$iptablespath -wI d_privateIPs 1  -d 10.0.0.0/8  -p all -m comment --comment "private IPs" -j DROP
$iptablespath -wI d_privateIPs 1  -d 172.16.0.0/12  -p all -m comment --comment "private IPs" -j DROP
$iptablespath -wI d_privateIPs 1  -o eth0  -d 192.168.0.0/16  -p all -m comment --comment "private IPs" -j DROP
$iptablespath -wI d_static_trusted 1  -d 199.102.46.70  -p all -m comment --comment "local time server hosted by Monticello" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 208.67.222.222  -p all -m comment --comment "OpenDNS" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.89.199  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.91.13  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.94.4  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.91.15  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.91.24  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.91.23  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.88.149  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.91.14  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 91.189.92.201  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -p all -m comment --comment "established connections are assumed to be OK" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 206.72.26.254  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 207.32.31.195  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 167.142.225.5  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI d_static_trusted 1  -d 207.32.31.196  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 216.58.192.0/19  -p all -m comment --comment "google direct allocation" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 216.58.192.0/19  -p all -m comment --comment "google direct allo
cation" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 209.85.147.26  -p all -m comment --comment "gmail server" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 209.85.147.26  -p all -m comment --comment "gmail server" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 74.125.0.0/16  -p all -m comment --comment "Google's range" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 74.125.0.0/16  -p all -m comment --comment "Google's range" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 173.194.0.0/16  -p all -m comment --comment "Google's range" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 173.194.0.0/16  -p all -m comment --comment "Google's range" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 207.32.31.204  -p all -m comment --comment "isp mail server" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 207.32.31.204  -p all -m comment --comment "isp mail server" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 207.32.31.196  -p all -m comment --comment "isp mail server" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 207.32.31.196  -p all -m comment --comment "isp mail server" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 167.142.225.5  -p all -m comment --comment "name server NS1.NETINS.NET" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 167.142.225.5  -p all -m comment --comment "name server NS1.NETI
NS.NET" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 207.32.31.195  -p all -m comment --comment "isp server" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 207.32.31.195  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 206.72.26.254  -p all -m comment --comment "isp server" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 206.72.26.254  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 207.32.31.198  -p all -m comment --comment "pop3.walnutel.net:pop3 [207.32.31.198/110]" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 207.32.31.198  -p all -m comment --comment "pop3
.walnutel.net:pop3 [207.32.31.198/110]" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 208.80.200.0/21  -p all -m comment --comment "redcondor for walnutel.net support servers-mx, etc Sat Dec 19 20:12:02 CST 2015" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 208.80.20
0.0/21  -p all -m comment --comment "redcondor for walnutel.net support servers-mx, etc Sat Dec 19 20:12:02 CST 2015" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 208.80.206.63  -p all -m comment --comment "isp mail server Sat Jan  9 08:32:13 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 208.80.206.63  -p all -m comment --comment "is
p mail server Sat Jan  9 08:32:13 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 208.80.204.253  -p all -m comment --comment "isp mail server Sat Jan  9 08:34:48 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 208.80.204.253  -p all -m comment --comment "
isp mail server Sat Jan  9 08:34:48 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 98.179.31.188  -p all -m comment --comment "knocked Sat Jan 16 12:26:40 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 98.179.31.188  -p all -m comment --comment "knocked Sa
t Jan 16 12:26:40 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 207.177.27.131  -p all -m comment --comment "via email Sat Jan 16 20:12:44 CST 2016 Sat Jan 16 20:12:44 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 207.177.27.131  -p all
 -m comment --comment "via email Sat Jan 16 20:12:44 CST 2016 Sat Jan 16 20:12:44 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 68.15.224.232  -p all -m comment --comment "via email Sun Jan 17 18:42:53 CST 2016 Sun Jan 17 18:42:53 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 68.15.224.232  -p all -
m comment --comment "via email Sun Jan 17 18:42:53 CST 2016 Sun Jan 17 18:42:53 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 97.107.199.77  -p all -m comment --comment "via email Mon Jan 18 10:22:01 CST 2016 Mon Jan 18 10:22:01 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 97.107.199.77  -p all -
m comment --comment "via email Mon Jan 18 10:22:01 CST 2016 Mon Jan 18 10:22:01 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 166.175.63.191  -p all -m comment --comment "via email Sat Jan 30 20:22:53 CST 2016 Sat Jan 30 20:22:53 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 166.175.63.191  -p all
 -m comment --comment "via email Sat Jan 30 20:22:53 CST 2016 Sat Jan 30 20:22:53 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 70.198.33.1  -p all -m comment --comment "via email Fri Feb  5 19:05:20 CST 2016 Fri Feb  5 19:05:20 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 70.198.33.1  -p all -m co
mment --comment "via email Fri Feb  5 19:05:20 CST 2016 Fri Feb  5 19:05:20 CST 2016" -j ACCEPT
$iptablespath -wI d_whitelist 1  -o eth0  -d 184.187.14.228  -p all -m comment --comment "via email Fri Feb 12 12:46:37 CST 2016 Fri Feb 12 12:46:37 CST 2016" -j ACCEPT;$iptablespath -wI s_whitelist 1  -i eth0  -s 184.187.14.228  -p all
 -m comment --comment "via email Fri Feb 12 12:46:37 CST 2016 Fri Feb 12 12:46:37 CST 2016" -j ACCEPT
$iptablespath -wI s_privateIPs 1  -i eth0  -s 192.168.0.0/16  -p all -m comment --comment "private IPs" -j DROP
$iptablespath -wI s_privateIPs 1  -s 172.16.0.0/12  -p all -m comment --comment "private IPs" -j DROP
$iptablespath -wI s_privateIPs 1  -s 10.0.0.0/8  -p all -m comment --comment "private IPs" -j DROP
$iptablespath -wI s_static_trusted 1  -s 91.189.92.201  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.91.14  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.88.149  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.91.23  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.91.24  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.91.15  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.94.4  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.91.13  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 91.189.89.199  -p all -m comment --comment "Canonical" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 208.67.222.222  -p all -m comment --comment "OpenDNS" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 199.102.46.70  -p all -m comment --comment "local time server hosted by Monticello" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -i lo  -p all -m comment --comment "allow all from 127.0.0.1" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -p all -m comment --comment "established connections are assumed to be OK" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 206.72.26.254  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 207.32.31.195  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 167.142.225.5  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI s_static_trusted 1  -s 207.32.31.196  -p all -m comment --comment "isp server" -j ACCEPT
$iptablespath -wI s_whitelist 1 -i eth0 -s 174.74.1.69  -m comment --comment "via email Sun Feb 28 16:48:56 CST 2016 Sun Feb 28 16:48:56 CST 2016" -j ACCEPT;$iptablespath -wI d_whitelist 1 -o eth0 -d 174.74.1.69 -m comment --comment "vi
a email Sun Feb 28 16:48:56 CST 2016 Sun Feb 28 16:48:56 CST 2016" -j ACCEPT
BUILDIPTABLES.SH_END
) > "$directoryforscripts/buildiptables.sh"
          chmod 755 "$directoryforscripts/buildiptables.sh"
          echo "$directoryforscripts/buildiptables.sh set up..."
       }
       install_cronentries () {
#  Only need to confirm if there are entries in crontab
! [[ "$(eval $crontabpath -l|$greppath -E -v ^#|$greppath -v ^[[:space:]]*$|$wcpath -l)" == "0" ]] && \
     (echo -e "$(eval $crontabpath -l|$greppath -E -v ^#|$greppath -v ^[[:space:]]*$|$wcpath -l) entries in crontab:\n\n$(eval "$crontabpath -l|$greppath -E -v ^#|$greppath -v ^[[:space:]]*$")\n"
      echo "Confirm you understand that your crontab shell is now getting changed which"
      read -n1 -s -p "might affect the above entries if they send values on, contain quotes, etc.: ")
(cat << CRONTAB_ENTRIES_END
$($crontabpath -l)\
*/30 * * * * $iptabperspath save >/dev/null 2>&1
 # @reboot $iptabperspath reload >/dev/null 2>&1
@reboot $nicepath -n19 $inotifywaitpath --quiet --monitor --event modify /var/lib/dhcp/dhclient.eth0.leases|while read;do "$directoryforscripts/newip_no_mysql.sh";done >/dev/null 2>&1
@reboot "$directoryforscripts/newip_no_mysql.sh\" >/dev/null 2>&1
#@reboot if [ \$($iptablespath -w -L INPUT -n|$stdbufpath -o0 /bin/grep -m 1 -c ESTABLISHED) -eq "0" ]; then "$directoryforscripts/buildiptables.sh";fi >/dev/null 2>&1
@reboot $nicepath -n15 $tailpath -F -n 0 /var/log/kern.log|$greppath --line-buffered ' SRC='|$stdbufpath -o0 $greppath -v 'SRC=10\.'|$stdbufpath -o0 $greppath -v 'SRC=0\.0\.0\.0'|$stdbufpath -o0 $greppath -v 'SRC=127.0\.0\.1'|$stdbufpath -o0 $greppath -v 'SRC=192\.168\.'|$stdbufpath -o0 $awkpath '{for (i=4;i<=NF;i++) {if (\$i ~ "^SRC=") {{gsub("SRC=","",\$i); printf \$i" \""} printf "kern.log "\$1" "\$2" "\$3; for (i=i;i<=NF;i++) {if (\$i ~ "^PROTO=" || \$i ~ "^SPT=" || \$i ~ "^DPT") {printf " "\$i}} print "\""}}}'|xargs -l1 "$directoryforscripts/blacklistme.sh"  >/dev/null 2>&1
*/3 * * * * echo "$iptablespath s_blacklist chain is \$($iptablespath -wnL s_blacklist --line-numbers|$tailpath -n-1|$awkpath '{print \$1}') lines long" >> "$directoryforscripts/modemcheck.lastran.log"; if [ \$($ifconfigpath|$headpath -n+2|$greppath -c "inet ") -eq 0 ] || [[ \$($greppath ^d1 <"$directoryforscripts/usbrelay.log"|$tailpath -n 1|$awkpath '{for (i=4;i>=0;i--) {printf \$(NF-i)" "}print ""}') < \$( $greppath -w waiting /var/log/syslog|$greppath '\:123'|$greppath -v grep|$tailpath -n 1|$awkpath '{print $1" "$2" "$3}' ) ]]; then "$directoryforscripts/usbrelay d1";$sleeppath 1;"$directoryforscripts/usbrelay a1";$ifdownpath eth0;$ifuppath eth0; fi >/dev/null 2>&1
*/3 * * * * if [ \$($pspath aux|$greppath "/usr/sbin/knockd \-d \-i eth0"|$greppath -vc grep) -lt 1 ] || [ \$($tailpath -n-1 /var/log/knockd.log|$greppath -c shutting) -gt 0 ] && [ \$($pspath aux|$greppath sshd:|$greppath -vc root) -eq 0 ]; then /etc/init.d/knockd stop;$sleeppath 1;/etc/init.d/knockd start;fi >/dev/null 2>&1
0 3 * * * echo "$directoryforscripts/usbrelay d8"|$atpath \$(timevar=\$($awkpath '{timevar=('\$($bcpath <<< "\$($datepath +\%m) * 2")');printf \$timevar}' <($headpath -n+1 <($tailpath -n-\$($bcpath <<< "32 - \$($datepath +\%d)") "$directoryforscripts/sunrise-set.local")));datevar=\$($datepath +\%Z);if [ \${datevar: -2:1} == "D" ];then timevar=\$($bcpath <<< "\${timevar:0:2} + 1")\${timevar:2};fi;$datepath -d "$timevar today + 20 minutes" +\%H\%M)
0 3 * * * echo "$directoryforscripts/usbrelay a8"|$atpath \$(timevar=\$($awkpath '{timevar=('\$($bcpath <<< "1 + \$($datepath +\%m) * 2")');printf \$timevar}' <($headpath -n+1 <($tailpath -n-\$($bcpath <<< "32 - \$($datepath +\%d)") "$directoryforscripts/sunrise-set.local")));datevar=\$($datepath +\%Z);if [ \${datevar: -2:1} == "D" ];then timevar=\$($bcpath <<< "\${timevar:0:2} + 1")\${timevar:2};fi;$datepath -d "$timevar today - 10 minutes" +\%H\%M)
@reboot timerise=\$($awkpath '{timerise=('\$($bcpath <<< "\$($datepath +\%m) * 2")');printf \$timerise}' <($headpath -n+1 <($tailpath -n-\$($bcpath <<< "32 - \$($datepath +\%d)") "$directoryforscripts/sunrise-set.local")));datevar=\$($datepath +\%Z);if [ \${datevar: -2:1} == "D" ];then timerise=\$($bcpath <<< "\${timerise:0:2} + 1")\${timerise:2};fi;timeset=\$($awkpath '{timeset=('\$($bcpath <<< "1 + \$($datepath +\%m) * 2")');printf \$timeset}' <($headpath -n+1 <($tailpath -n-\$($bcpath <<< "32 - \$($datepath +\%d)") "$directoryforscripts/sunrise-set.local")));datevar=\$($datepath +\%Z);if [ \${datevar: -2:1} == "D" ];then timeset=\$($bcpath <<< "\${timeset:0:2} + 1")\${timeset:2};fi;if [ \$($bcpath <<< "\$($datepath +\%H\%M) - \$timerise") -ge 0 ] && [ \$($bcpath <<< "\$timeset - \$($datepath +\%H\%M)") -ge 0 ];then "$directoryforscripts/usbrelay d8";else "$directoryforscripts/usbrelay a8";fi
@reboot $nicepath -n19 $inotifywaitpath -q --monitor --format "\%f" --event create /var/run/|while read filename;do if [ \$filename == "reboot-required" ];then "$directoryforscripts/rebootreqd";fi;done >/dev/null 2>&1
# 10 * * * * nice -n19 "$directoryforscripts/email_fetch_parse" >/dev/nul 2>&1
CRONTAB_ENTRIES_END
) |$crontabpath -
[[ "$(eval "$crontabpath -l|$greppath -c \"SHELL=\"")" == "0" ]] && \
  echo -e "SHELL=/bin/bash\n$($crontabpath -l)"|$crontabpath - || \
  eval "$crontabpath -l|$sedpath \"/SHELL=/c\SHELL=/bin/bash\"|$crontabpath -"
echo "crontab set up..."
          }


       conf_postfix () {
# See https://www.linode.com/docs/email/postfix/postfix-smtp-debian7
line=""
############### remove line up to the until statement
line="fdgfhjk@gmail.com"
outemailadd="ertyuik@cox.net";outemailpw="-------";outemailacct="${outemailadd%@*}";outemailprovider="${outemailadd#*@}";outemaildomain="${outemailprovider%.*}";outtopdomain="${outemailprovider#*.}";outemailsubdomain="smtp";
while true;do
     clear;echo -e "Three emailing functions need email addresses.  Provide at least one email\
\naddress now.  The address[es] asked for now is/are the one or more that will\
\nreceive the various notifications sent out by this system.  Commonly, this would\
\nbe at least two addresses - one for a text message to a cell phone, the other an\
\nemail account so you could read the full content of the notification, since cell\
\nphone carriers often limit the length of email-to-texting conversion and cut\
\nshort the longer texts."
     echo -e "\nAddress[es] where to send notifications to:\n"
     toemailadds="4567899876@text.republicwireless.com\nghjk,kj@walnutel.net\nrtyujkkl@cox.net\n";printf "$toemailadds$line"
     while IFS= read  -s -n1 -r char;do # [[ -z "$char" ]] && break
          if [[ "$(printf "%d" "'$char")" == "27" ]];then # escape or extended key has been detected, single quote important
                     read -r -s -t 1 -n2 # read & discard 2nd extended key field, timeout if real escape
          elif [[ -z "$char" ]] || [[ "$char" == " " ]];then
                      [[ -z "$line" ]] || [[ "${toemailadds: -1}" == "\n" ]] && break
                      toemailacct="${line%@*}";
                      toemailprovider="${line#*@}"
                      toemaildomain="${toemailprovider%.*}"
                      totopdomain="${toemailprovider##*.}"
                      if ! [[ "$line" == "$toemailacct"@"$toemaildomain"."$totopdomain" ]] || [[ -z "$toemaildomain" ]] || [[ -z "$totopdomain" ]];then
                          printf " checked bad, use backspace to correct\r$line"
                      else
                          echo "";toemailadds+="$line\n";line=""
                      fi
          elif [[ "$(printf "%d" "'$char")" == "127" ]];then
                     if ! [[ -z "$line" ]];then
                         line="${line:0: -1}" # handles the backspace character
                         printf "\r$line\033[K" # needed b/c when several keys are pressed simultaneously only first gets silented
                     fi
          else
                          printf "$char";
                          line+="$char"
          fi
     done
# echo "";echo -e "Addresses are\n\n${toemailadds:: -2}"
             if ! [[ -z "$toemailadds" ]];then
                 directoryforscripts="$( cat directoryforscripts )"
                 echo "$(echo "${toemailadds:: -2}"|$sedpath 's/\\n/,/g')" > "$directoryforscripts/toemailadds"
                 break
             fi
exit
done
              echo -e "\nNow, a single email address with its password is needed for an outgoing email\
\nserver somewhere to authenticate the outgoing email traffic (it's come to this\
\nbecause of spammers).  Enter now the email account name to use for an outgoing\
\nemail server based on its ability to accept sign-on through this scripting\
\nyou're installing.  Preferrably not too strict accepting sign-on because this\
\nscript uses the mid-tier security of standard smtp protocol (your email\
\ncredentials, including password, are stored in this scripting and sent encrypted\
\nbut via standard smtp protocol) rather than upper-tier security (\"OAuth 2.0\" -\
\ncredentials entered on a web page that only a real human can reliably determine\
\nwhere on the screen to enter the credentials today, which may be different from\
\nyesterday.  It also includes a sort of dynamic security key exchange not\
\navailable via standard smtp protocol).  NOTE - this email account may be the\
\nsame or different from the one that the notices get sent to.  We can test and\
\ncompare suitability repeatedly, so you may select from all your accounts which\
\none this scripting is most able to sign into (use up/down arrow keys, or enter a\
\nnew name entirely).  SUGGESTION: If reading this has made you suspicious\
\n(hopefully so!), create a NEW account with a provider that will allow logins\
\nfrom \"less secure apps\" on a per-account basis (like Gmail) and set that\
\ndedicated account to allow such logins, then resume here and enter that account\
\nname and password.  That same account could also be dedicated for this scripting\
\nto read commands emailed from you for it to be remote controlled:\n"

(cat <<EOF1
#!/bin/bash
lineshere="\$($greppath -E --line-number "^:$" < \$0)"
(cat << EOF
#!/bin/bash
head -n "\${lineshere%::*}" \$0 > \$0.bak
mv \$0.bak \$0
chmod 777 \$0
EOF
) > cleanup.sh
chmod 777 cleanup.sh
./cleanup.sh
# read -s -n 1 -p "press a key before while..."
while getopts "t:" opt; do
# read -s -n 1 -p "press a key in while before case..."
  case "\$opt" in
      t) timeout=\$OPTARG;shift \$((OPTIND-1)) ;;
  esac
#  read -s -n 1 -p "press a key in while after case..."
done
# read -s -n 1 -p "press a key after both while and case..."

start_watchdog(){
  timeout="\$1"
  (( i = timeout ))
  while (( i > 0 ))
  do
      kill -0 \$\$ || exit 0
      sleep 1
      (( i -= 1 ))
  done

  # echo "killing process after timeout of \$timeout seconds"
  kill \$\$
}

start_watchdog "\$timeout" 2>/dev/null &
echo "\$@" >> "\$0"
:

EOF1
) > "timeouttry.sh"
chmod 700 "timeouttry.sh"
#          stty -echo; echo -n $'\e[6n'; read -d R x; stty echo;xypos="${x#??}";ypos="${xypos%;*}";xpos="${xypos#*;}"
# gomore="run1"
while true;do  #this loop allows user to select an email account for outbound server & builds connect.txt file
#     until [[ -f "$directoryforscripts/$outemailprovider.outconnects.txt" ]]; do #this loop goes through all connections found for a given address
     while true; do #this loop goes through all connections found for a given address
          scratchpad="${toemailadds%%'\n'*}"
          toemailaddid=1 ;horizptr="${#scratchpad}"
          printf "(up/down-arrows will select, or edit into an entirely different account name)\n$scratchpad"
          while true;do #this loop ensures an email account gets chosen
              while IFS= read  -s -n1 -r char;do
                   if [[ "$(printf "%d" "'$char")" == "27" ]];then
                         char1="";char2="";char3=""
                         read -r -s -t 0.001 -n1 char1
                         read -r -s -t 0.001 -n1 char2
                         read -r -s -t 0.001 -n1 char3
                         if [[ "$char1$char2$char3" == "[A" ]] || [[ "$char1$char2$char3" == "[B" ]];then
                              if [[ "$char1$char2$char3" == "[A" ]];then
                                   toemailaddid=$(( $toemailaddid - 1 ))
                              else
                                   toemailaddid=$(( $toemailaddid + 1 ))
                              fi
                              if [[ $(( $toemailaddid )) -lt 1 ]];then
                                    toemailaddid=$(( $toemailaddid + 1 ))
                                    continue
                              fi
                              scratchpad="$toemailadds"
                              for i in `seq 2 $(( $toemailaddid ))`;do
                                   ! [[ -z "${scratchpad#*'\n'}" ]] \
                                       && scratchpad="${scratchpad#*'\n'}" \
                                       || toemailaddid=$(( $toemailaddid - 1 ))
                              done
                              scratchpad="${scratchpad%%'\n'*}"
                              printf "\r${scratchpad}\033[K"
                              horizptr="$(( ${#scratchpad} ))"
                         elif [[ "$char1$char2$char3" == "[C" ]];then
                              if [[ $(( ${horizptr} )) -lt $(( ${#scratchpad} )) ]];then
                                    horizptr="$(( ${horizptr} + 1 ))"
                                    printf "\033[1C"
                              fi
                         elif [[ "$char1$char2$char3" == "[D" ]];then
                              if [[ $(( ${horizptr} )) -gt 0 ]];then
                                    horizptr="$(( ${horizptr} - 1 ))"
                                    printf "\033[1D"
                              fi
                         elif [[ "$char1$char2$char3" == "OF" ]];then
                              horizptr="$(( ${#scratchpad} ))"
                              printf "\r\033[${#scratchpad}C"
                         elif [[ "$char1$char2$char3" == "OH" ]];then
                              horizptr="0"
                              printf "\r"
                         elif [[ "$char1$char2$char3" == "[3~" ]];then
                              if [[ $(( ${horizptr} )) -lt $(( ${#scratchpad} )) ]];then
                                   scratchpad="${scratchpad:0:horizptr}${scratchpad:horizptr+1}" # handles the delete character
                                   printf "${scratchpad:horizptr}\033[K\r${scratchpad:0:horizptr}"
                              fi
                         fi
                   elif [[ "$(printf "%d" "'$char")" == "127" ]];then
                     if ! [[ $(( ${horizptr} )) -eq 0 ]];then # exit
                         horizptr="$(( ${horizptr} - 1 ))"
                         scratchpad="${scratchpad:0:horizptr}${scratchpad:horizptr+1}" # handles the backspace character
                         printf "\033[1D${scratchpad:horizptr}\033[K\r${scratchpad:0:horizptr}"
                     fi
                   elif [[ -z "$char" ]];then
                         break
                   else
                        horizptr="$(( ${horizptr} + 1 ))"
                        scratchpad="${scratchpad:0:horizptr-1}$char${scratchpad:horizptr-1}"
                        printf "$char${scratchpad:horizptr}\033[K\r${scratchpad:0:horizptr}"
                   fi
              done
              outemailadd="${scratchpad%%'\n'*}"
# echo -e  "\n\nSelected address is $outemailadd\n"
              outemailacct="${outemailadd%@*}";outemailprovider="${outemailadd#*@}"
              outemaildomain="${outemailprovider%.*}"
              outtopdomain="${outemailprovider##*.}"
              if ! [[ "$outemailadd" == "$outemailacct"@"$outemaildomain"."$outtopdomain" ]] || [[ -z "$outemaildomain" ]] || [[ -z "$outtopdomain" ]];then
                  printf "\nEmail address not in correct format.  Re-enter it...\033[1A\r$scratchpad";horizptr="${#scratchpad}"
                  continue
              fi
              outemailsubdomain="smtp";printf "\n\033[K"
              outemailpw1="";outemailpw=""
              until [[ "$outemailpw1" == "$outemailpw" ]] && ! [[ -z "$outemailpw1""$outemailpw" ]];do
                  read -s -p "Password for account $outemailadd: " outemailpw1
                  [[ -z "$outemailpw1" ]] && exit || echo ""
                  read -s -p "Re-type same password: " outemailpw
                  if ! [[ "$outemailpw1" == "$outemailpw" ]];then
                      echo -e "\nPassword not entered consistently."
                  else
                      echo ""
                  fi
              done
          ! [[ -z "$outemailadd" ]] && ! [[ -z "$outemailpw" ]] && break
          done
          echo -e "determining best option for outgoing email server login.  You should be doing\
\nthis step from the Internet location of final operation if you have/want your\
\nlocal ISP-provided email account considered for your outgoing email server...\n"
          [[ -f "$directoryforscripts/$outemailprovider.outconnects.txt" ]] \
             && rm "$directoryforscripts/$outemailprovider.outconnects.txt" 2>/dev/null
          printf  "\rSelected address $outemailadd \033[K\n"
          
#          while ! nc -zw1 google.com 80; do #note that port 80 might always be true even for invalid site if the local ISP substitutes for non-existers
#                printf "\r\033[KNo internet connection found with full DNS.  Press a key when corrected...";read -n1 -s
#          done
          for MAIL_PROT in smtp mail;do
               for port in 587 25 2587 26 2525 25025 2526 3325 465 995 110 993 143;do
                    printf "\rChecking $MAIL_PROT.$outemailprovider:$port\033[K";
                    (./timeout.sh -t 2 "exec 5>&-;exec 5<>/dev/tcp/$MAIL_PROT.$outemailprovider/$port;read -u 5 HELO;! [[ -z \$HELO ]] && echo -e \"$MAIL_PROT:$port\" >> \"$directoryforscripts/$outemailprovider.outconnects.txt\";echo -e \"quit\" >&5;read -t 2 -u 5 QUIT;exec 5>&-")
               done  2> /dev/null
          done
          if [[ -f "$directoryforscripts/$outemailprovider.outconnects.txt" ]];then
               echo -e "\rThe possibilities are\033[K\n$(<"$directoryforscripts/$outemailprovider.outconnects.txt")"
               break
          else
               printf "\r\033[K\033[1ASelected email provider doesn't allow logins.  Enter a different account...\n"
          fi
     done
     while read -u 3 -r line;do #? this while loop iterates once for each port that accepted a smtp connection for outgoing email
          chmod 744 /etc/postfix/main.cf
          [[ "$($greppath -c ^myhostname </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "myhostname = ""$(hostname)" >> /etc/postfix/main.cf \
              || $sedpath -i 's/^myhostname.*/myhostname = '"$(hostname)"'/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^relayhost </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "relayhost = ["${line%:*}"."$outemailprovider"]:"${line#*:} >> /etc/postfix/main.cf \
              || $sedpath -i 's/^relayhost.*/relayhost = ['"${line%:*}.$outemailprovider]:${line#*:}"'/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^mech_list: cram-md5 </etc/postfix/sasl/smtpd.conf)" == "0" ]] \
              && echo -e "mech_list: cram-md5" >> /etc/postfix/sasl/smtpd.conf
          [[ "$($greppath -c ^smtp_sasl_auth_enable </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf \
              || $sedpath -i 's/^smtp_sasl_auth_enable.*/smtp_sasl_auth_enable = yes/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^smtp_sasl_security_options </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf \
              || $sedpath -i 's/^smtp_sasl_security_options.*/smtp_sasl_security_options = noanonymous/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^smtp_sasl_password_maps </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf \
              || $sedpath -i 's/^smtp_sasl_password_maps.*/smtp_sasl_password_maps = hash:\/etc\/postfix\/sasl_passwd/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^smtp_tls_security_level </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "smtp_tls_security_level = encrypt" >> /etc/postfix/main.cf \
              || $sedpath -i 's/^smtp_tls_security_level.*/smtp_tls_security_level = encrypt/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^smtp_tls_CAfile </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "smtp_tls_CAfile = /etc/postfix/cacert.pem" >> /etc/postfix/main.cf \
              || $sedpath -i 's/^smtp_tls_CAfile.*/smtp_tls_CAfile = \/etc\/postfix\/cacert.pem/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^[[]"${line%:*}"".""$outemailprovider""]:""${line#*:}" </etc/postfix/sasl_passwd)" == "0" ]] \
              && echo -e "[""${line%:*}"".""$outemailprovider""]:""${line#*:}""    $outemailadd":"$outemailpw" >> /etc/postfix/sasl_passwd \
              || $sedpath -i 's/^[[]'"${line%:*}.$outemailprovider]:${line#*:}"'.*/'"[${line%:*}.$outemailprovider]:${line#*:}     $outemailadd:$outemailpw"'/g' /etc/postfix/sasl_passwd
          [[ "$($greppath -c ^smtp_generic_maps </etc/postfix/main.cf)" == "0" ]] \
              && echo -e "smtp_generic_maps = hash:/etc/postfix/generic" >> /etc/postfix/main.cf \
              || $sedpath -i 's/^smtp_generic_maps.*/smtp_generic_maps = hash:\/etc\/postfix\/generic/g' /etc/postfix/main.cf
          [[ "$($greppath -c ^root@$(hostname) </etc/postfix/generic)" == "0" ]] \
              && echo -e "root@$(hostname)           $outemailadd" >> /etc/postfix/generic \
              || $sedpath -i 's/^'"root@$(hostname)"'.*/'"root@$(hostname)           $outemailadd"'/g' /etc/postfix/generic
          chown postfix /etc/postfix
          chown postfix /etc/postfix/generic
          chmod 600 /etc/postfix/sasl_passwd
          eval "$postmappath /etc/postfix/sasl_passwd"
          eval "$postmappath /etc/postfix/generic"
          chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
          chmod 600 /etc/postfix/sasl_passwd.db
          chmod 644 /etc/postfix/cacert.pem
          chmod 644 /etc/postfix/master.cf
          cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | tee -a /etc/postfix/cacert.pem 1&>/dev/null
          chown postfix /etc/postfix/sasl_passwd*
          /etc/init.d/postfix reload
          postqueuepath=$($whereispath $binaryflag postqueue);postqueuepath="${postqueuepath#*:}";postqueuepath="${postqueuepath# }";postqueuepath="${postqueuepath%% *}"
          if ! [[ "$( $postqueuepath -p )" == *is\ empty* ]];then
               echo -e "For the next step, the mail queue needs to be flushed.  You will lose the\
\nfollowing emails that haven't been sent.  Press a key to acknowledge..."
               echo -e "$( $postqueuepath -p )"
               read -n1
               echo -e "$( $postqueuepath -f )"
          fi
          echo -e "Next, suitability test notifications will be sent out to all email addresses you\
\nindicated should receive notifications.  Press a key to send them..."
          read -s -n1 -r
          notemsg=""
          ! [[ "${answer%f*}" == "$answer" ]] && notemsg+="Firewalling\n"
          ! [[ "${answer%r*}" == "$answer" ]] && notemsg+="Email remote control\n"
          ! [[ "${answer%d*}" == "$answer" ]] && notemsg+="Dynamic IP address change notifier\n"
          ! [[ "${answer%p*}" == "$answer" ]] && notemsg+="Port knocking\n"
          echo -e "Test using "${line%:*}"".""$outemailprovider"":""${line#*:}" \
\nas outgoing email server from firewall/dynamic IP notifier \
\nItems being installed:\n$( echo -e "${notemsg:: -2}" )"|mail -s "Test notification from firewall install script" "$(echo "${toemailadds:: -2}"|$sedpath 's/\\n/,/g')"
#          cat \
<< See
If error: “SASL authentication failed; server smtp.gmail.com”,
you need to unlock the captcha by visiting this page \
https://www.google.com/accounts/DisplayUnlockCaptcha
See
          sleep 2
          [[ "$( $postqueuepath -p )" == *is\ empty* ]] \
            && printf "All emails sent just fine.  Have they all been received in a timely manner?  If\
\nany were delayed, a different outgoing email server may do a better job." \
            || printf "Judging by the email queue not getting emptied quickly, a different outgoing\
\nemail server may do a better job.\n$($tailpath /var/log/syslog|$greppath postfix|$greppath ${line%:*}.$outemailprovider|$greppath -m 1 \]:${line#*:}|$sedpath 's/^.*status=//g')"
# \nemail server may do a better job.\n$($tailpath /var/log/syslog|$greppath postfix|$greppath ${line%:*}.$outemailprovider|grep -m 1 \]:${line#*:}|sed 's/^.*status=//g')"
          printf "\nNote that not all email providers keep a record of your emails sent from this\
\ntype of connection.  If it is meaningful to you that these notification emails\
\nremain in the sent folder of this email address, be sure to check for that\
\nfeature before accepting this outgoing email server.  Press ENTER key to accept\
\nthis outgoing email server, any other key to see if another one can be tested..."
          [[ "$(until IFS= read -s -n1 -t .1 domore;[[ "$?" == "0" ]] && echo ${#domore};do :;done)" -eq 0 ]] && break 2 # I don't want to mess with IFS but do need to know diff between space and enter
     done 3<"$directoryforscripts/$outemailprovider.outconnects.txt"  2> /dev/null
# user wants a to re-select an email address
     echo -e "Select a different email address for its outgoing email server:"
done #this loop goes through the email provider outbound servers & builds connect.txt files until user selects one
echo -e "\nFind a different way to get this !!!!!!!!!!!\n"
          echo -e "postfix files configured for $($greppath -m 1 "set from=" </root/.mailrc|$sedpath 's/set from=//g')\
\nand $($greppath -m 1 "set smtp=smtp://" </root/.mailrc|$sedpath 's/set smtp=smtp:\/\///g')..."
          }
          install_rc () {
directoryforscripts="$( cat directoryforscripts )"
line="k,sjdk,@walnutel.net"
inemailadd="";inemailacct="${inemailadd%@*}";inemailprovider="${inemailadd#*@}";inemaildomain="${inemailprovider%.*}";intopdomain="${inemailprovider#*.}";inemailsubdomain="pop";
rm successlogins 2>/dev/null
clear
while true;do
     echo -e "Enter the email address now that this system will retrieve instructions through\
\nthat you or others will send in:\n";printf "$line"
     while IFS= read  -s -n1 -r char;do # [[ -z "$char" ]] && break
          if [[ "$(printf "%d" "'$char")" == "27" ]];then # escape or extended key has been detected, single quote important
                         read -r -s -t 0.001 -n1 char1
                         read -r -s -t 0.001 -n1 char2
                         read -r -s -t 0.001 -n1 char3
          elif [[ -z "$char" ]] || [[ "$char" == " " ]];then
                      [[ -z "$line" ]] && break
                      inemailacct="${line%@*}";
                      inemailprovider="${line#*@}"
                      inemaildomain="${inemailprovider%.*}"
                      intopdomain="${inemailprovider##*.}"
                      if ! [[ "$line" == "$inemailacct"@"$inemaildomain"."$intopdomain" ]] || [[ -z "$inemaildomain" ]] || [[ -z "$intopdomain" ]];then
                          printf " checked bad, use backspace to correct.\r$line"
                      else
                          echo "";break
                      fi
          elif [[ "$(printf "%d" "'$char")" == "127" ]];then
                     if ! [[ -z "$line" ]];then
                         line="${line:0: -1}" # handles the backspace character
                         printf "\r$line\033[K" # needed b/c when several keys are pressed simultaneously only first gets silented
                     fi
          else
                          printf "$char";
                          line+="$char"
          fi
     done
             ! [[ -z "$line" ]] && break || exit
              echo -e "Configuring for that email account.  You should be doing\
\nthis step from the Internet location of final operation if you have/want your\
\nlocal ISP-provided email account considered for this...\n"
              [[ -f "$directoryforscripts/$inemailprovider.inconnects.txt" ]] \
                 && rm "$directoryforscripts/$inemailprovider.inconnects.txt" 2>/dev/null
              printf  "\rSelected address $line \033[K\n"
          
#          while ! nc -zw1 google.com 80; do #note that port 80 might always be true even for invalid site if the local ISP substitutes for non-existers
#                printf "\r\033[KNo internet connection found with full DNS.  Press a key when corrected...";read -n1 -s
#          done
              while ! [[ -f "$directoryforscripts/$inemailprovider.inconnects.txt" ]];do # this loop re-tries if no connection file is created in the loop
                  exec 5>&-;wait
                  for MAIL_PROT in pop pop3 mail;do
                       for port in 465 995 110 993;do
                            printf "\rChecking $MAIL_PROT.$inemailprovider:$port\033[K";
                            (./timeout.sh -t 2 "exec 5>&-;exec 5<>/dev/tcp/$MAIL_PROT.$inemailprovider/$port;read -u 5 HELO;! [[ -z \$HELO ]] && echo -e \"$MAIL_PROT:$port\" >> \"$directoryforscripts/$inemailprovider.inconnects.txt\";echo -e \"quit\" >&5;read -t 2 -u 5 QUIT;exec 5>&-")
                       done  2> /dev/null
                  done
                  if [[ -f "$directoryforscripts/$inemailprovider.inconnects.txt" ]];then
                       echo -e "\rThe possibilities are\033[K\n$(<"$directoryforscripts/$inemailprovider.inconnects.txt")"
                  else
                       printf "\r\033[K\033[2ASelected email provider isn't allowing an initial connection right now, or maybe\
\nthe Internet connection is faulty.  Press Ctrl-c to abort retries...\n"
# We need a better way to interrupt this
                       continue
                  fi
              done
# echo "";echo -e "Address is\n\n$inemailacct"@"$inemaildomain"."$intopdomain"
          rcpw="";rcpw1=""
          while printf "Password for that email account:";read -s rcpw;do # This loop is for when a password is under question
              printf "\n\033[KRe-type password:"
              read -s rcpw1
              printf "\r\033[K\033[1A\033[K"
              [[ -z "$rcpw$rcpw1" ]] && break 2
              ! [[ "$rcpw" == "$rcpw1" ]] && continue
              rm fifo 2>/dev/null
# mkfifo fifo
              while read -u 3 -r line;do #? this while loop iterates once for each port that accepted a pop connection ${line%:*}"."$outemailprovider"]:"${line#*:}
                  while true;do # This loop for exact settings retry
                      exec 5>&-;wait
                      exec 5<>/dev/tcp/"${line%:*}.$inemailprovider/${line#*:}"
                      printf "\rExecuted the connect of ${line%:*}.$inemailprovider/${line#*:}, now communicating with it for user $inemailacct...\033[K"
                      read -t 2 -u 5 HELO 
                      echo -e "$HELO" >> fifo 
printf "\n$HELO"
                      msgnumber=0
                      for msg in "user $inemailacct\r" "pass $rcpw\r" stat list;do
                           msgnumber=$(( msgnumber+=1 ))
                           printf "\r\033[KSending $msg\n"
                           echo -e "$msg" >&5
                         #  while true;do # this loop stores server responses for a configuration
                           while (read -u 5 replyline
                                  printf "\r\033[K$replyline\n"
                                  echo "$replyline" >> fifo 
                                  ! [[ "${replyline:0:1}" == "+" ]] && break
                                 ) &
                                pid="$!"
                           do
                                sleep 2 &
                                sid="$!"
                                until ! [[ $(kill -0 "$pid";echo "$?") == "0" ]] || ! [[ $(kill -0 "$sid";echo "$?") == "0" ]]; do
                                :
                                done
                                if [[ $(kill -0 "$pid";echo "$?") == "0" ]];then
                                    kill "$pid" >/dev/null
                                    break
                                else
                                    break
                                fi
                           done 2>/dev/null
                      done
                      echo -e "quit\r" >&5 
                      read -t 2 -u 5 BYE
#                      echo -e "$BYE" >> fifo 
                      exec 5>&-
                      if ! [[ "$( replystart="$($tailpath -n 1 fifo)";echo "${replystart::1}")" == "+" ]];then # present this choice with every error
                         echo -e "Unsuccessful sign-in of $inemailacct to ${line%:*}.$inemailprovider/${line#*:}" # with this error:\n$($tailpath -n 1 fifo)"
                         echo -e "quit\r" >&5
                         read -t 2 -u 5 BYE
#                          echo -e "$BYE" >> fifo 
                         exec 5>&-
                         printf "If you're sure about the password, and there are more port options for this\
\nemail account, option 'N' would make the most sense.  Try a new email Address, a\
\nnew Password, the Next possibility, same Everything, or Quit\
\n(A, P, N, E, or Q)..."
                         read -n1 retryansw # 4 does new pw, 0,1 goes into new pw
                         loops="A3P2N1E0Q4";loops="${loops#*${retryansw^}}"
                         echo ""
                         ! [[ "${loops::1}" == "0" ]] && continue "${loops::1}"
                      else
                         echo -e "$inemailacct ${line%:*}.$inemailprovider/${line#*:}" >> "$directoryforscripts/successlogins"
                         break
                      fi
                  done # This loop for exact settings retry
              done 3<"$directoryforscripts/$inemailprovider.inconnects.txt" 2> /dev/null
            # if we have even a single success, break
                     [ -f "$directoryforscripts/successlogins" ] && break 2
          done # This loop is for when a password is under question
done # This loop is to change the account
toemailadds=$( cat "$directoryforscripts/toemailadds" )
#     echo -e "\n\nLet's look at the results:\n"
#     cat fifo
#     rm fifo 2>/dev/null
           (cat <<EOF
#!/bin/bash

# THIS SCRIPT ALLOWS FOR CONTROL VIA EMAIL
# I suggest it be launched with a special port
# knock logged in kern.log by virtue of an
# iptables rule in the INPUT chain that
# identifies itself with the term "email-reader"
# in its comments. The script searching for that
# port-match and launching this script is called
# blacklistme.sh.  By maintaining a dynamic
# blacklist for a while you'll better be able
# to determine a good port for you.

# The controlling email should be already sent
# before knocking said port because this
# script has no way of knowing for sure that
# an email will come in a timely manner.

# Numerous grep commands are contained herein
# that could be refined to use separate text
# files to hold the search terms/keywords. I did
# not so refine them simply to minimize the
# number of files in this project since I am
# targeting users who might get lost in
# an excessive number of files.  I would
# encourage you to modify those grep commands
# yourself if you value the finer points of
# programming.

# Example: (roughly, please don't criticize imperfection between the lists)
#     echo "\$(grep -e "Content-Type: text/plain; charset=UTF-8" -iwe "remove" -e "undo" -e "delete" -e "whitelist" -e "permit" -e "let" -e "on" -e "open" -e "allow" -e "blacklist" -e "off" -e "stop" -e "block" -e "recent" -e "report" -e "shut" -e "close" -e "prevent" -e "recent" -e "me" -e "report" -e "what" -e "who" -e "whoami" -e "kern" -e "kernlog" -e "kern.log" <(echo "\$mailcontentline"))" >> $directoryforscripts/mailcontent
#
# becomes (except the email content header line becomes case-insensitive along with everything else):

#     cat *.keywords > allwords.tmp; echo "\$(grep -wif allwords.tmp <(echo "\$mailcontentline"))" >> "$directoryforscripts/mailcontent";rm allwords.tmp
#       -the grep -f flag is what does it
#
# given the following files exist in the appropriate directory, and
# there are no empty lines in the files, including the last ones:

#    'emailbegins.keywords' having the following contents: (case becomes insensitive if following the example given)
#       Content-Type: text/plain; charset=UTF-8

#    'blacklistlog.keywords' having the following contents:
#       log
#       logging

#    'tailkernlog&emailresults.keywords' having the following contents:
#       recent
#       report
#       kern
#       kernlog
#       kern.log
#       tail
#       who
#       whoami
#       what
#       me

#    'deleting.keywords' having the following contents:
#       remove
#       undo
#       delete
#       end
#       stop

#    'blacklisting.keywords' having the following contents:
#       blacklist
#       off
#       block
#       shut
#       close
#       prevent

#    'whitelisting.keywords' having the following contents:
#       whitelist
#       permit
#       let
#       on
#       open
#       allow

[ \$(( \$($tailpath -n-2 \$0|$greppath -c "^#running"))) -gt 0 ] && exit
until [ \$(( \$($tailpath -n-2 \$0|$greppath -c "^#running"))) -gt 0 ];do
      echo "#running" >> \$0
      sleep 1
done
trap "$sedpath -i '/^\#running/d' \$0" EXIT
[[ \$- = *i* ]] && echo "Connecting to email...."
port="${line#*:}";MAIL_PROT="${line%:*}"
MAIL_FROM="$inemailacct@$inemailprovider"
[ ! -z \$2 ] && [ -z "\${2//[0-9]}" ] && [ \$2 -ge 0 ] && [ \$2 -le 65535 ] &&  port=\$2
[ ! -z \${3,S} ] && [ \${3,S} == "s" ] && MAIL_PROT="smtp"
[ ! -z \${3,S} ] && [ \${3,I} == "i" ] && MAIL_PROT="imap"
accountname="\${MAIL_FROM%%@*}";domainname="\${MAIL_FROM##*@}"
exec 5>&-;wait
exec 5<>/dev/tcp/\$MAIL_PROT"."\$domainname/\$port
[[ \$- = *i* ]] && echo "Executed the connect, now trying to read..."
read -t 2 -u 5 HELO # <&5
[ x\$1 == "x-v" ] && echo -e "GOT: \\n\$HELO"
[ x\$1 == "x-v" ] && echo "SENDING: username"
echo -e "user $inemailacct\\r" >&5
read -t 2 -u 5 sendyourpassword
[ x\$1 == "x-v" ] && echo "\$sendyourpassword"
[ x\$1 == "x-v" ] && echo "SENDING: password"
echo -e "pass $rcpw\\r" >&5
read -t 2 -u 5  maildroplockedandready
[ x\$1 == "x-v" ] && echo "\$maildroplockedandready"
[ x\$1 == "x-v" ] && echo "SENDING: list"
echo -e "list\\r" >&5
[ -f "$directoryforscripts/mailcontent" ] && rm "$directoryforscripts/mailcontent"
numofemails=-1
while read  -t 2 -u 5 emailtitle; do
    [ \$(( \${#emailtitle} )) -lt 3 ] && break
    if [ \$(( \${#emailtitle} )) -lt 20 ]; then
         #add to array of emailtitlnums
         numofemails=\$(( \$numofemails + 1 ))
         [ x\$1 == "x-v" ] && echo "\$numofemails"
         emailtitlenums[ \$((numofemails)) ]=\${emailtitle% *}
    fi
done
if [ \$((numofemails)) -gt -1 ]; then
    [[ \$- = *i* ]] && echo "Retrieving \$numofemails email[s]..."
    for i in \`seq 0 \$((numofemails))\`;do
         echo -e "RETR \${emailtitlenums[i]}\\r" >&5
          boundary=""
          while read  -t 2 -u 5 mailcontentline;do
             [ \$(( \${#mailcontentline} )) -lt 2 ] && continue
             mailcontentline="\${mailcontentline:: -1} " #strip the linefeed and put space there instead
              [[ \$- = *i* ]] && echo "\$mailcontentline" #
              if [ -z "\$boundary" ];then [ \$(echo "\$mailcontentline"|$greppath -e "^Content-Type: "|$greppath -c "; boundary=") -gt 0 ] && boundary="\$(echo "\$mailcontentline"|$greppath -e "^Content-Type: " -e "; boundary="|$awkpath -F= '{print \$2}')" && boundarymarker=1
              else
                  echo "\$($greppath -iwe "remove" -e "undo" -e "delete" -e "whitelist" -e "permit" -e "let" -e "on" -e "open" -e "allow" -e "blacklist" -e "off" -e "stop" -e "block" -e "recent" -e "report" -e "shut" -e "close" -e "prevent" -e "recent" -e "me" -e "report" -e "what" -e "who" -e "whoami" -e "kern" -e "kernlog" -e "kern.log" -e "log" -e "end" -e "logging" <(echo "\$mailcontentline"))"|while read line;do [ \$(( \${#line} )) -gt 1 ] && echo "\$line" >> "$directoryforscripts/mailcontent";done
                  [ \$($bcpath <<<"\${#mailcontentline} - \${#boundary}") -eq 2 ] && [ "\${mailcontentline:2: -1}" == "\${boundary:: -1}" ] && [ \$(( ++boundarymarker )) -gt 2 ] && (read  -t 2 -u 5 mailcontentline;read -t 2 -u 5  mailcontentline;read  -t 2 -u 5 mailcontentline;read -t 2 -u 5 mailcontentline) && break # && echo "Retrieved one message" && break
              fi
          done
    done
    for i in \`seq 0 \$((numofemails))\`;do
         echo -e "dele \${emailtitlenums[i]}\\r" >&5
         while read -t 2 -u 5 deleteresponse;do [ \$(( \${#deleteresponse} )) -lt 1 ] && break;done
    done
     [ -f "$directoryforscripts/valid_instructions_from_email" ] && rm "$directoryforscripts/valid_instructions_from_email"
#This will give us the subject line of first email: head -n+\$(( \$($greppath -m 1 --line-number "Content-Type: text/plain; charset=UTF-8" < mailcontent|$awkpath -F: '{print \$1}') - 1)) mailcontent|$greppath -E '^Subject'
#This will start us at content of first email: $tailpath -n+\$(( 2 + \$($greppath -m 1 --line-number "Content-Type: text/plain; charset=UTF-8" < mailcontent|$awkpath -F: '{print \$1}'))) mailcontent
     cat "$directoryforscripts/mailcontent" |while read line; do line1="\$(echo "\$line "|$greppath -E -o "\\b((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])( |/[1-2]?[0-9] |/3[0-2] )")" && ( echo "\$line1"|while read ipadd;do echo "\$ipadd \$line" >> "$directoryforscripts/valid_instructions_from_email"; done ) || (line1="\$(echo "\$line"|$greppath -wie "recent" -e "me" -e "report" -e "what" -e "who" -e "whoami" -e "kern" -e "kernlog" -e "kern.log" -e "tail" -e "log")" && ( echo "\$line1" >> "$directoryforscripts/valid_instructions_from_email" ));done
     cat "$directoryforscripts/valid_instructions_from_email" |while read line
     do option=""
          [ \$($greppath -cwie "undo" -e "remove" -e "delete" -e "end" -e "stop" <(echo "\$line")) -gt 0 ] && option="-r"
          if [ \$($greppath -cwie "report" -e "send" <(echo "\$line")) -gt 0 ] && [ \$($greppath -cwi "whitelist" <(echo "\$line")) -gt 0 ];then
              script="echo \\"\$($iptablespath -wnvL s_whitelist|$awkpath '{print \$8}')\\"|mail -s \\"As you requested\\" \\"$toemailadds\\""
          elif [ \$($greppath -cwie "recent" -e "report" -e "kern" -e "kernlog" -e "kern.log" -e "tail" -e "who" -e "whoami" -e "what" -e "me" <(echo "\$line")) -gt 0 ];then
              script="echo \\"\$($tailpath /var/log/kern.log)\\"|mail -s \\"As you requested\\" \\"$toemailadds\\""
          elif [ \$($greppath -cwie "permit" -e "let" -e "on" -e "open" -e "allow" -e "whitelist" <(echo "\$line")) -gt 0 ]; then
              script="$directoryforscripts/openall.sh \$(echo \$line|$awkpath '{print \$1}') \$option \\"via email \$(date)\\""
          elif [ \$($greppath -cwie "log" -e "logging" <(echo "\$line")) -gt 0 ];then
              if [ \$(( \${#option} )) -eq 0 ];then script="$iptablespath -wI INPUT \$($iptablespath -wnL INPUT --line-numbers|$greppath "s_privateIPs"|$awkpath '{print \$1 + 1}') -m comment --comment \\"via email \$(date) - remove when not needed\\" -j LOG"
              elif [ \$($iptablespath -wnL INPUT|$greppath -c "remove when not needed") -gt 0 ];then script="[[ \$($iptablespath -wnL INPUT --line-numbers|$greppath -m 1 "remove when not needed"|$awkpath '{print \$1}') -gt 0 ]] && $iptablespath -wD INPUT \$($iptablespath -wnL INPUT --line-numbers|$greppath -m 1 "remove when not needed"|$awkpath '{print \$1}')"
              else
                  script=""
              fi
              [ \$(( \${#script} )) -ne 0 ] && echo "\$script" >> "$directoryforscripts/buildiptables.sh"
          else
              script="$directoryforscripts/blacklistme.sh \$(echo \$line|$awkpath '{print \$1}') \$option \\"via email \$(date)\\""
          fi
          echo "$directoryforscripts/email_fetch_parse is sending the following command to be executed:" >> "$directoryforscripts/email_fetch_parse.log"
          echo "\$script"  >> "$directoryforscripts/email_fetch_parse.log"
          [ \$(( \${#script} )) -ne 0 ] && eval "\$script"
     done
else
     [[ \$- = *i* ]] && echo "No emails were in the inbox"
fi
[[ \$- = *i* ]] && echo "SENDING: QUIT"
echo -e "QUIT\\r" >&5
wait
exec 5>&-
EOF
) > "$directoryforscripts/email_fetch_parse"
chmod 700 "$directoryforscripts/email_fetch_parse"
          }
install_dynIPch () {
:
##The following 3 lines are intentionally redundant to allow system admin to change dhcp client package and still get notified of dhcp change
##
#/var/lib/dhclient/dhclient-eth0.leases
#/var/lib/dhcp/dhclient.eth0.leases
#/var/lib/dhcp3/dhclient.leases
# "$directoryforscripts/newdynip.sh"
echo -e "The notification email you'd receive should refer to this computer by what name?"
pcname=$(while read -e -r -i "$(hostname)" sysname;do if ! [[ -z "$sysname" ]];then echo "$sysname";break;fi;done)
echo ""
if [[ "$(dig +short myip.opendns.com @resolver1.opendns.com)" =~ ^((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$ ]];then 
     echo -e "To learn any new IP address gotten, this computer will interrogate a public\nservice, \
default is shown below.  Press enter to keep it; otherwise, change it\nto suit you:"
else 
     echo -e "To learn any new IP address gotten, this computer will interrogate a public\nservice, \
default is shown below, but is NOT WORKING now.  Change it to suit you:"
fi
resolver="$(while read -e -i "dig +short myip.opendns.com @resolver1.opendns.com" resolver;do 
     echo "$resolver";break;
done)"
echo -e "In the email that will inform those recipients who you'll specify of the new IP\
\naddress listed as one or a series of link[s] formatted as any browser would\
\naccept in the address bar, enter the protocol, subdirectories and options, and\
\nport that the address will begin and end with, in as many combinations as you'd\
\nlike displayed in the email.\
\nExample: Suppose your computer serves two web pages, one as http and the other\
\nas https, two camera video streams, wifi modem administration, ssh, and a remote\
\ncontrol channel, so you could want all 7 links sent in the new IP address\
\nnotification email, along with reminder links of those 7 services with their\
\ninside (private) IP addresses for access to them when you are home, like this,\
\nsome port numbers fictitious:\
\n\nhttp://<new IP address>/sub/dir[s]:80\
\nhttps://<new IP address>/sub/dir[s]:443\
\nrtsp://<new IP address>/sub/dir[s] and options:15541\
\nrtsp://<new IP address>/sub/dir[s] and options:15542\
\nhttp://<new IP address>/sub/dir[s]:801\
\nssh homeowner@<new IP address>:122\
\nxmpp://<new IP address>/sub/dir[s] and options:121\
\n"
(cat <<EOF
#!/bin/bash
# arg 1 is file name of modified file in same directory as leases
# verify ending type is lease or leases
# then parse backwards making sure no private ip range is referenced
! [[ "\${1##*.}" == "lease" ]] && ! [[ "\${1##*.}" == "leases" ]] && exit
#site-specific variables:
webpageprotocol=https
emailsubjectline="New IP address for $pcname: "
file_to_store_ip="$directoryforscripts/oldip"
resolver="dig +short myip.opendns.com @resolver1.opendns.com"
ip_from_resolver="\$(\$resolver)"
if [[ \$ip_from_resolver =~ ^((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\$ ]];
then
    if ( [ -f \$file_to_store_ip ] );
    then
        if [[ \$(< \$file_to_store_ip) =~ ^((1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\.){3}(1?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\$ ]] && [[ \$ip_from_resolver == \$(< \$file_to_store_ip) ]];
        then
echo "IP address is <\$ip_from_resolver> and not new, old ip = <\$(< \$file_to_store_ip)>"
            exit
        fi
    else
        : #first run
    fi
else
echo "IP address is <\$ip_from_resolver> and not acceptable"
    exit
fi
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

echo \$ip_from_resolver > \$file_to_store_ip
echo "IP address is <\$ip_from_resolver>"
EOF
) > "$directoryforscripts/newdynip.sh"

<<EOF1
:
EOF1
}
outemail_warnings () {
         echo -e "This installation script is about to make changes to this computer that can\
\nprofoundly change the way it sends out email.  No accommodation will be given\
\nfor any email sending capability that you might already have set up.  PLEASE do\
\nNOT expect this scripting to give any outbound emailing consideration for email\
\nprograms you have previously installed.  Only proceed if you agree with this\
\nnotion.  In contrast, INBOUND emailing is not expected to be affected because this\
\nscripting does not rely on, nor change the settings of, any email client program\
\nfor inbound email."
}
end_warnings () {
         echo -e "Remember always this fact of life:  Email providers do make unpredictable\
\nchanges to their email service!  The same holds true for ISPs.  Blame that any\
\nnumber of different reasons...technical, social, and otherwise.  Be aware that\
\nthe settings you just created may need to be adjusted in the future in response\timeou
\nto changes that others WILL make to affect your Internet experience, even\
\nchanges expressly designed to limit the usefulness of this fine enhancement\
\nyou've made to your Internet connectivity!  Though let's hope they'll have\
\nbetter reason for doing so than that."
}
       directoryforscripts="${directoryforscripts%%/}"
#        if ! [[ "${answer%f*}" == "$answer" ]];then
#            echo "firewalling"
# determine usable interfaces, build for eth0 dhcp in, eth1 static out first
########### uncomment the next two lines
#             echo -e "iptables, including ruleset and crontab entries will be set up next.\
# \n   Press a key...";read -n1 -r
# The next section prints itself out to its shell script file
#             install_buildiptablessh
#             install_cronentries
#             outemail_warnings
#             echo -e "\nPress a key to acknowledge and continue, Ctrl-c to abort..."
#             read -n1
#             conf_postfix
#:
#        fi
#        if ! [[ "${answer%r*}" == "$answer" ]];then
#             echo -e "remote controlling"
#             install_rc
#             
#        fi
        if ! [[ "${answer%d*}" == "$answer" ]];then
             echo -e "dynamic IP change notify"
#             install_rc
             install_dynIPch

        fi
    fi
done
exit
