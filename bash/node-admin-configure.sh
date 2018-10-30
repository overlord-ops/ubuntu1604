#!/bin/bash
#node-admin-configure.sh
MY_VERSION=0.1.2

# for things like:
# new VPS setup, adding git, nano, wget, ansible, SSH key
# adding new sudo users
# fail2ban
# configure IPv6 in /etc/network/interfaces
# install bootstrap
# call ansible plays

GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
NC='\e[0m'

PKGS='git vim nano wget htop gzip ansible autotools-dev automake omake cmake libssl-dev libtool curl tree rsync software-properties-common pkg-config libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libdb4.8-dev libdb4.8++-dev'

clear

echo -e "${GREEN}Masternode Admin Configure - BETA ${NC}"
echo -e "${CYAN} --- ${NC}"
echo -e "${CYAN} server sysadmin tasks ${NC}"
echo -e "${CYAN}  ${NC}"
echo -e "${CYAN} --- ${NC}"
echo "*** working ***"
echo ""
echo ""

PS3="Please choose a task number (press enter to view menu) : "
options=("initial setup" "add sudo user" "reset user password" "install fail2ban" "configure ipv6" "task6" "task7" "task8" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "initial setup")
	 echo "${GREEN}this will update and configure a newly provisioned server.${NC}"
	 echo "${GREEN}this will update then isntall following packages via apt-get: ${NC}"
	 echo -e "${YELLOW} $PKGS ${NC}";
	 echo ""
	 #sudo apt-get update
	 #sudo apt-get upgrade -y
	 #for pkg in $PKGS; do sudo apt-get install -y $pkg; done
	 echo -e "${GREEN} almost done... ${NC}"
	 #sudo apt-get update
	 curl https://raw.githubusercontent.com/CobraKenji/thawed/master/ansible/keyzon/keyzon-fullplay.yml -o keyzon-fullplay.yml
	 ansible-playbook keyzon-fullplay.yml
	 RESULT=$?
	 if [ $RESULT -eq 0 ]; then
	  echo -e "${GREEN}success ${NC}"
	 else
	  echo -e "${YELLOW}failed. screenshot and contact your script kiddy ${NC}"
	 fi
	 #cat /root/ansible/keyzon.tmp.yml
	 rm keyzon-fullplay.yml
	 echo "...done..."
         echo "";
            ;;
        "add sudo user")
         #call ansible playbook to add new sudo user
	 echo -e "${GREEN} Grant sudo to a user. Creates new sudo user if not present. ${NC}"
	 echo -e "${YELLOW}!!! This will grant passwordless sudo access !!! ${NC}"
	 read -e -p "Enter sudo user name : " newSudoer
         echo -e "${YELLOW} Veryfing passwordless sudo access for $newSudeor ... ${NC}";
         echo ""
	 echo ""
	 curl https://raw.githubusercontent.com/CobraKenji/ubuntu1604/master/ansible/create-sudoer.yml -o create-sudoer.yml
	 ansible-playbook create-sudoer.yml --extra-vars "newSudoer=$newSudoer" --ask-become-pass
	 RESULT=$?
	 if [ $RESULT -eq 0 ]; then
  	  echo -e "${GREEN} $newSudoer is a passwordless sudo user. ${NC}"
	 else
  	  echo -e "${YELLOW}user sudo check failed. screenshot and contact your script kiddy${NC}"
	 fi
	 rm create-sudoer.yml
        echo "";
            ;;
        "reset user password")
	echo -e "${GREEN} Password reset ${NC}"
	read -e -p "Which user's password do you wish to set? : " newPwduser
	echo -e "${CYAN}changing password for $newPwduser ...${NC}"
	echo ""
	sudo passwd $newPwduser
        RESULT=$?
        if [ $RESULT -eq 0 ]; then
         echo -e "${CYAN}password for $newPwduser updated. ${NC}"
        else
         echo -e "${YELOW}failed. screenshot and contact your script kiddy${NC}"
        fi
        echo "";
            ;;
         "install fail2ban")
	read -e -p "Prompt " var1
        echo "$var1".conf
        echo "";
            ;;
         "configure ipv6")
	read -e -p "Question? : " var2
        echo -e "${YELLOW} $var2 ${NC}";
        echo "something"
        echo "";
        echo "";
            ;;
         "task6")
	read -e -p "Which $coinName number? : " mnIteration
        echo -e "${YELLOW} $coinName$mnIteration masternode status : ${NC}";
        echo "$coinName"-cli -conf=/root/."$coinName$mnIteration"/"$coinName".conf -datadir=/root/."$coinName$mnIteration" masternode status
    	echo "";
    	echo "";
            ;;
         "task7")
        read -e -p "Which $coinName number? : " mnIteration
        echo EMPTY TASK SLOT 
        echo "";
            ;;
	 "task8")
        echo you are currently managing as user: "$(whoami)".
	echo EMPTY TASK SLOT
	read -e -p "Some var prompt " someVar
        echo "$someVar";
            ;;


        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY"
         clear
           ;;
    esac
done


