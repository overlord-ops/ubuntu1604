#!/bin/bash
#node-admin-start.sh
# v0.1.1

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC='\e[0m'

clear

echo -e "${GREEN}Masternode Administrator Menu ${NC}"
echo -e "${CYAN} --- ${NC}"
echo -e "${CYAN} supported coins:${NC}"
echo -e "${CYAN} dextro, dinero, worx, ${NC}"
echo -e "${CYAN} --- ${NC}"
echo "*** this is no longer a beta - commands will attempt to execute ***"
echo ""
echo ""
echo "Enter a coin name (all lowercase): "
echo "dextro, dinero, worx, etc... "
read -e -p " : " coinName

PS3="Please choose a task number (press enter to view menu) : "
options=("start" "stop" "getinfo" "edit config" "mnsync status" "masternode status" "install" "change coin" "list nodes" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "start")
         #systemctl start $coinName
         read -e -p "Which $coinName number? : " mnIteration
	 echo -e "${YELLOW}starting node $coinName$mnIteration ${NC}";
	 sudo "$coinName"d -daemon -datadir=/root/."$coinName$mnIteration"
        echo "";
            ;;
        "stop")
         #systemctl stop $coinName
	 read -e -p "Which $coinName number? : " mnIteration
         echo -e "${YELLOW}stopping $coinName$mnIteration node ${NC}";
         sudo "$coinName"-cli -datadir=/root/."$coinName$mnIteration" stop
        echo "";
            ;;
        "getinfo") 
	read -e -p "Which $coinName number? : " mnIteration
  	  case "$coinName" in
	    *worx*)
             wrxUser="$coinName$mnIteration"
             echo using "${GREEN}$wrxUser${NC}" as the worx node user
             sudo su -c "$coinName-cli -datadir=/root/.$coinName$mnIteration getinfo" "$wrxUser"
		;;
	  *)
	  sudo "$coinName"-cli -datadir=/root/."$coinName$mnIteration" getinfo
		;;
	    esac
	    ;;    
         "edit config")
	read -e -p "Which $coinName number? : " mnIteration

          case "$coinName" in
            *worx*)
             wrxUser="$coinName$mnIteration"
             echo using "${GREEN}$wrxUser${NC}" as the worx node user
             sudo su -c "nano /root/."$coinName$mnIteration"/"$coinName".conf" "$wrxUser"
                ;;
          *)
          sudo nano /root/."$coinName$mnIteration"/"$coinName".conf
                ;;
            esac
        echo "";
            ;;
         "mnsync status")
	read -e -p "Which $coinName number? : " mnIteration

          case "$coinName" in
            *worx*)
             wrxUser="$coinName$mnIteration"
             echo using "${GREEN}$wrxUser${NC}" as the worx node user
	     echo ""
	     echo -e "${YELLOW}$coinName$mnIteration mnsync status: ${NC}";
             sudo su -c ""$coinName"-cli -datadir=/root/.$coinName$mnIteration mnsync status" "$wrxUser"
                ;;
          *)
          echo -e "${YELLOW}$coinName$mnIteration mnsync status: ${NC}";
          sudo "$coinName"-cli -datadir=/root/."$coinName$mnIteration" mnsync status
                ;;
            esac
        echo "";
            ;;
        "masternode status")
	read -e -p "Which $coinName number? : " mnIteration

          case "$coinName" in
            *worx*)
             wrxUser="$coinName$mnIteration"
             echo using "${GREEN}$wrxUser${NC}" as the worx node user
	     echo ""
             echo -e "${YELLOW}$coinName$mnIteration masternode status : ${NC}";
             sudo su -c ""$coinName"-cli -datadir=/root/.$coinName$mnIteration masternode status" "$wrxUser"
                ;;
          *)
          echo -e "${YELLOW}$coinName$mnIteration masternode status : ${NC}";
          sudo "$coinName"-cli -datadir=/root/."$coinName$mnIteration" masternode status        
                ;;
            esac
    	echo "";
            ;;
         "install")
        read -e -p "Which $coinName number? : " mnIteration
        echo TODO - install /root/."$coinName$mnIteration"/"$coinName"
        echo "";
            ;;
         "list nodes")
        sudo ls -lah /root/ | grep "$coinName" | awk '{print $9}'
        echo "";
            ;;

	 "change coin")
        echo you are currently managing "$coinName".
	echo select a coin to manage:
	read -e -p "dextro, dinero, worx, monero, etc... " coinName
        echo "";
            ;;

        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY"
         clear
           ;;
    esac
done
