#! /bin/bash
echo "Sorry, still under development ... press a key to continue"
read -n1 -r
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
min_bash_version_tested="4.3.11";! [[ "$($sortpath <<<"$(echo -e "$BASH_VERSION\n$min_bash_version_tested")"|$headpath -n 1)" == "$min_bash_version_tested" ]] && trap "echo If you had run-time errors, your version of bash might be too old" EXIT
#  though some effort was given to making the menu aspect of this helper script compatible with Mac running 3.2.57 bash
if [[ "$($unamepath)" =~ BSD ]];then echo -e "This firewalling solution does not accommodate any BSD system due to BSD and"\
"\niptables not being compatible with each other.  Sorry...";exit;fi
if ! [ "$(whoami)" == "root" ];then echo -e "\nWithout being launched by su, this script\
 won't be able to do anything except\
\\ndisplay menus.  No control of this computer can be made by this script unless\
\\nre-launched by root.  Press a key to acknowledge, Ctrl-c to abort\n";read -n1 -r;fi
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
echo -e "\n\n       Jesus Christ is Lord of all  ... press a key to acknowledge\n"
read -n1 -r
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
eval "$pythonpath -c \"import platform;print(platform.linux_distribution()[0])\" &> /dev/null > \"distributionby.${0#*/}\"" || eval "echo -e \"Functionality may be limited due to inability to determine distribution type\\n...press a key to continue...\";read -n1 -r" || eval "echo $OSTYPE > \"distributionby.${0#*/}\""
eval "$ifconfigpath -a|$awkpath -F'^ ' '{print \$1}'|$awkpath '{print \$1}'|$greppath -vw lo|xargs" > "interfacesby.${0#*/}"
# echo "Script-required items: whereis path=$whereispath, awk path=$awkpath, python path=$pythonpath, grep path=$greppath, ifconfig path=$ifconfigpath, uniq path=$uniqpath, sort path=$sortpath, head path=$headpath";exit
#
# Introduction and what we'll do

startscreen="\\n\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Main Configuration Screen\
\\n                SELECT DESIRED OPTIONS FOR THIS INSTALLATION\
\\n\\n\\n                            (f) firewalling\
\\n\\n                            (r) email remote control\
\\n\\n                            (d) dynamic address change notifier\
\\n\\n                            (p) port knocking\
\\n\\n                            (?) context helpful information\
\\n\\n
\\nTyping the letters f, r, d, p, optionally followed by a question mark, or just\
\\nplain ? with no letters, select all of the five services listed above that you\
\\nwant, then press ENTER: (or Ctrl-c at any time to terminate script)"
ghscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\\n                              HELPER SCRIPT OVERVIEW\
\\nThis set of Linux scripts can install several capabilities useful for\
\\nhomeowners up to large enterprises that are Internet-connected with Linux.\
\\nAdvantages to using scripting vs. a compiled program include\
\\n\\n - you, the owner, don't need to learn new software and config files\
\\n - easier adaptation and expansion by you, the owner\
\\n - less disk and memory space used\
\\n - less internal complexity means less risk of programming bugs and\
\\n     insurmountable limitations\
\\n - less need to restart processes means fewer operating interruptions\
\\n - no obsolescence"
fwscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\\n                        FIREWALLING WITH THIS SCRIPT SET\
\\n( As you read, please realize the difference between this installation \"helper\
\\nscript\" that you are running now and the \"script set\" it helps you install )\
\\n\\nTo configure firewalling, port-knocking, or email remote control, iptables &\
\\nnetfilter-persistent are required if not already present.  These are standard\
\\nfor any Linux firewalling.  As far as manual control of iptables during run\
\\ntime, this script set is friendly.  It will simply configure iptables - an\
\\ninitial configuration by the helper script, then periodic configurations of\
\\niptables throughout the course of normal operations by the installed script set.\
\\nUnlike what exists with ufw, shorewall, and fail2ban, no ongoing integration\
\\nwith iptables will exist to interfere at any time with direct user adjustment of\
\\nthe iptables ruleset.\
\\nFirewalling options this install script can alter from the script set defaults:\
\\n  -- Stop probe logging/blacklisting to save space or if you're just not curious\
\\n  -- Open specific ports to offer public services\
\\n  -- Allow swap interfaces (default=public:eth0, private:eth1)\
\\n  -- Force single-interface firewalling even though two interfaces exist\
\\n  -- Alter the IP address of the private-side interface from 192.168.3.1\
\\n\\n* No testing has been done using DHCP client nor server on the private interface"
rcscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\\n                  REMOTE CONTROL VIA EMAIL WITH THIS SCRIPT SET\
\\n( As you read, please realize the difference between this installation \"helper\
\\nscript\" that you are running now and the \"script set\" it helps you install )\
\\n\\nWhat we mean by Remote Control Via Email:  You find yourself travelling far away\
\\nfrom home, and thus, far away from this computer you are configuring.  You\
\\ndecide you need this computer to do a few things for you now before you return.\
\\nOne is to turn on and off one of the electrical outlets that it controls through\
\\na USB-connected Arduino board.  You also remember that there is an old iptables\
\\nrule whitelisting an IP address that belongs no longer belongs to you, so you\
\\nneed your home system to remove it from the iptables whitelist.  This and more\
\\nis possible if you just connect that Arduino you've built and run this script.\
\\nThis helper script will need from you name and password of the email account\
\\nthat this computer will retrieve the emails from that you send to it.  This\
\\nhelper script will test its functionality and give you a choice of which port\
\\nnumber you want to use (knock) to trigger your system to read and parse emails.\
\\nIdeally, you would want to choose a port number that never gets probed by\
\\nthe hackers of the world.  Logging probed ports (configured in the firewall\
\\nsection of this helper script) would be a handy reference here.\
\\n\\n* No testing has been done using DHCP client nor server on the private interface"
dascreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\\n          EMAIL NOTIFY OF DYNAMIC IP ADDRESS CHANGE WITH THIS SCRIPT SET\
\\n( As you read, please realize the difference between this installation \"helper\
\\nscript\" that you are running now and the \"script set\" it helps you install )\
\\n\\nTo configure firewalling, port-knocking, or email remote control, iptables &\
\\nnetfilter-persistent are required if not already present.  These are standard\
\\nfor any Linux firewalling.  As far as manual control of iptables during run\
\\ntime, this script set is friendly.  It will simply configure iptables - an\
\\ninitial configuration by the helper script, then periodic configurations of\
\\niptables throughout the course of normal operations by the installed script set.\
\\nUnlike what exists with ufw, shorewall, and fail2ban, no ongoing integration\
\\nwith iptables will exist to interfere at any time with direct user adjustment of\
\\nthe iptables ruleset.\
\\nFirewalling options this install script can alter from the script set defaults:\
\\n  -- Stop probe logging/blacklisting to save space or if you're just not curious\
\\n  -- Open specific ports to offer public services\
\\n  -- Allow swap interfaces (default=public:eth0, private:eth1)\
\\n  -- Force single-interface firewalling even though two interfaces exist\
\\n  -- Alter the IP address of the private-side interface from 192.168.3.1\
\\n\\n* No testing has been done using DHCP client nor server on the private interface"
pkscreen="\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`Information Screen\
\\n                        PORT KNOCKING WITH THIS SCRIPT SET\
\\n( As you read, please realize the difference between this installation \"helper\
\\nscript\" that you are running now and the \"script set\" it helps you install )\
\\n\\nTo configure firewalling, port-knocking, or email remote control, iptables &\
\\nnetfilter-persistent are required if not already present.  These are standard\
\\nfor any Linux firewalling.  As far as manual control of iptables during run\
\\ntime, this script set is friendly.  It will simply configure iptables - an\
\\ninitial configuration by the helper script, then periodic configurations of\
\\niptables throughout the course of normal operations by the installed script set.\
\\nUnlike what exists with ufw, shorewall, and fail2ban, no ongoing integration\
\\nwith iptables will exist to interfere at any time with direct user adjustment of\
\\nthe iptables ruleset.\
\\nFirewalling options this install script can alter from the script set defaults:\
\\n  -- Stop probe logging/blacklisting to save space or if you're just not curious\
\\n  -- Open specific ports to offer public services\
\\n  -- Allow swap interfaces (default=public:eth0, private:eth1)\
\\n  -- Force single-interface firewalling even though two interfaces exist\
\\n  -- Alter the IP address of the private-side interface from 192.168.3.1\
\\n\\n* No testing has been done using DHCP client nor server on the private interface"
answer=""
singinterf="\nBased on finding only one pluggable network interface, your intentions seem\
\\nto be to have this firewalling computer be a terminal (end) device rather than\
\\nan inline (passthrough) device.  That would result in any protective\
\\nfirewalling you'll set up next to apply only to this computer.  If instead you\
\\nwant this firewalling computer to protect other devices with its firewalling\
\\nservices, select"

until ! [ -z "$answer" ];do
    clear
    echo -e "$startscreen"
    while IFS= read -r -s -n1 char;do [[ -z "$char" ]] && break
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
        [[ "$answer$char" == "?" ]] && (echo -e "$ghscreen";read -n1 -r -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%f*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$fwscreen";read -n1 -r -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%r*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$rcscreen";read -n1 -r -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%d*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$dascreen";read -n1 -r -p "                         Press a key to continue...";echo "")
        ! [[ "${answer%p*}" == "$answer" ]] || [[ "$answer$char" == "?" ]] && (echo -e "$pkscreen";read -n1 -r -p "                         Press a key to continue...";echo "")
        answer=""
    else
      until [ "$goahead" == "true" ];do
        rhel=$(chkconfig --list 2> /dev/null | grep iptables)
#       echo "$rhel";exit #DNF, zypper, yum
        installers=(apt-get install dnf install yum install zypper install emerge "" pacman -S pkg install pkg_add "" xbps-install -Sy brew install port install)
        for aptname in "${installers[@]}";do
              aptitudepath=$($whereispath $binaryflag $aptname);aptitudepath="${aptitudepath#*:}";aptitudepath="${aptitudepath# }";aptitudepath="${aptitudepath%% *}"
              [[ -z "$aptitudepath" ]] && continue
              case "$aptname" in
                  $installers[0])

              esac
        done
        inotifypath=$($whereispath $binaryflag inotifywait);inotifypath="${inotifypath#*:}";inotifypath="${inotifypath## }";inotifypath="${inotifypath%% *}"
        iptablespath=$($whereispath $binaryflag iptables);iptablespath="${iptablespath#*:}";iptablespath="${iptablespath## }";iptablespath="${iptablespath%% *}"
        iptabperspath=$($findpath / -maxdepth 3 -name iptables-persistent 2> /dev/null)
        stdbufpath=$($whereispath $binaryflag stdbuf);stdbufpath="${stdbufpath#*:}";stdbufpath="${stdbufpath## }";stdbufpath="${stdbufpath%% *}"
        crontabpath=$($whereispath $binaryflag crontab);crontabpath="${crontabpath#*:}";crontabpath="${crontabpath# }";crontabpath="${crontabpath%% *}"
        mailpath=$($whereispath $binaryflag mail);mailpath="${mailpath#*:}";mailpath="${mailpath## }";mailpath="${mailpath%% *}"
        if [ -z "$mailpath" ];then
            mailpath=" $($whereispath $binaryflag sendmail)"
            mailpath="${mailpath#*:}"
        fi
        mailpath="${mailpath## }";mailpath="${mailpath%% *}"

        notinstalled=""
        if ! [[ "${answer%f*}" == "$answer" ]];then
            [[ -z "$inotifypath" ]] && notinstalled+="inotify-tools\\n"
            [[ -z "$iptablespath" ]] && notinstalled+="iptables\\n"
            [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\\n"
            [[ -z "$stdbufpath" ]] && notinstalled+="stdbuf\\n"
            [[ -z "$mailpath" ]] && notinstalled+="mailutils\\n"
            [[ -z "$crontabpath" ]] && notinstalled+="crontab\\n"
        fi
        if ! [[ "${answer%r*}" == "$answer" ]];then
            [[ -z "$inotifypath" ]] && notinstalled+="inotify-tools\\n"
            [[ -z "$iptablespath" ]] && notinstalled+="iptables\\n"
            [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\\n"
            [[ -z "$stdbufpath" ]] && notinstalled+="stdbuf\\n"
            [[ -z "$mailpath" ]] && notinstalled+="mailutils\\n"
            [[ -z "$crontabpath" ]] && notinstalled+="crontab\\n"
        fi
        if ! [[ "${answer%d*}" == "$answer" ]];then
            [[ -z "$inotifypath" ]] && notinstalled+="inotify-tools\\n"
            [[ -z "$iptablespath" ]] && notinstalled+="iptables\\n"
            [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\\n"
            [[ -z "$stdbufpath" ]] && notinstalled+="stdbuf\\n"
            [[ -z "$mailpath" ]] && notinstalled+="mailutils\\n"
            [[ -z "$crontabpath" ]] && notinstalled+="crontab\\n"
        fi
        if ! [[ "${answer%p*}" == "$answer" ]];then
            [[ -z "$inotifypath" ]] && notinstalled+="inotify-tools\\n"
            [[ -z "$iptablespath" ]] && notinstalled+="iptables\\n"
            [[ -z "$iptabperspath" ]] && notinstalled+="iptables-persistent\\n"
            [[ -z "$stdbufpath" ]] && notinstalled+="stdbuf\\n"
            [[ -z "$mailpath" ]] && notinstalled+="mailutils\\n"
            [[ -z "$crontabpath" ]] && notinstalled+="crontab\\n"
        fi
        notinstalled="$(echo -e "$notinstalled"|$sortpath|$uniqpath)"
#        echo "$notinstalled";exit
        if ! [[ -z "$notinstalled" ]] && [[ -z "$aptitudepath" ]] && [[ -z "$rhel" ]] && ! [[ "$ackd" == "true" ]];then
             echo -e "\n\n                  UNABLE TO INSTALL ANY PROGRAMS ON YOUR SYSTEM\
\\nThis helper script version is not advanced enough to install needed programs on\
\\nsystems such as yours that don't use apt-get to install programs.  For this\
\\ninstall script to serve its purpose for you, you'll need to install all\
\\nnecessary programs yourself before anything referenced hereafter can succeed.\
\\nConsider yourself lucky if this script does anything at all for you beyond this\
\\npoint, but do understand that the programs most certainly won't get installed.\
\\nThe necessary programs that won't get installed until you install them are:\
\\n$notinstalled\
\\n\\nYou may install them in another terminal and resume here, or press Ctrl-c to\
\\nterminate here, or press any other key to proceed as-is\
\\n\\n     Acknowledge by keypress..."
             read -n1 -r;ackd="true"
        else
             goahead="true"
        fi
      done
        clear
      if ! [ -z "$aptitudepath" ] && ! [ -z "$notinstalled" ];then # install what is needed
#                  notinstalled="$(echo -e "$notinstalled"|xargs)"
                  echo -e "Installation of\n$notinstalled\\n\\nwill begin after your keypress...";read -n1 -r
                  eval "$aptitudepath update 2> /dev/null"
                  notinstalled="$(echo -e "$notinstalled"|xargs)"
                  eval "$aptitudepath -y install $notinstalled"
      fi
#        echo "You selected "
        if ! [[ "${answer%f*}" == "$answer" ]];then
#            echo "firewalling"
            :
        fi
        if ! [[ "${answer%r*}" == "$answer" ]];then
#            echo "remote controlling"
            :
        fi
        if ! [[ "${answer%d*}" == "$answer" ]];then
#            echo "dynamic address change notifying"
            :
        fi
        if ! [[ "${answer%p*}" == "$answer" ]];then
#            echo "port knocking"
            :
        fi
#        echo "final answer=$answer";exit
        echo -e "Not installed=$notinstalled\niptables path=$iptablespath, iptables-persistent path=$iptabperspath, stdbuf path=$stdbufpath, mail path=$mailpath, inotifywait path=$inotifypath, aptitude path=$aptitudepath, crontab path=$crontabpath, rhel=$rhel"
    fi
done
