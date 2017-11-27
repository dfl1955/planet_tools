#!/bin/bash

# Author : Dave Levy, London  CC BY-SA

# v2.1 enable URL config file
#      gets directory name from output theme parameter
# v2.0 port to ubuntu 9
#      usage/help & version inserted, new file location standards inc. 
#      new python location

Pname=$0
PVer="2.1"
Pmsg="${Pname} ${PVer}"

USAGE="${Pname} directory containing a config file, or a URL pointing  or --version"
USAGE="${Pname} directory name | URL | --version | -h|--help"
#
# The directory name is also the stem for the log control file. The directory
# syntax must NOT have a trailing / i.e. DFL not DFL/. This version if the 
# directory is mingle, it will assume the config file = mingle.ini. The program
# assumes any string startingwith http:// is a URL, which means wget fails 
# if it is invalid. An excuse for python.

case $1 in
-h|-help|--help|-?) echo $USAGE ; exit ;;
-v|-version|--version) echo ${Pmsg} ; exit ;;
esac

echo ${Pmsg} starts
#
# This is configuration specific
#
cd $HOME/venus/venus

.  /kunden/homepages/19/d106342642/htdocs/venus/venus/functions

getthemename()
{
	# needs the config file name as $1
	egrep \^output_theme $1 | cut -f3 -d' '
}
CONFIG=config.ini
# does it start with http://
stringisurl $1 
case $? in
0)	# the argument is a URL
	wf=$(./getremoteconfig $1)
	theme=$(getthemename $wf)
	goodconfigfile=$wf
	;;
*)	# the argument is not a web URL
	if [ $1 == "mingle" ]
	then
		CONFIG=mingle.ini
		#$1=mingle
		goodconfigfile=$1/$CONFIG
	fi
	if [ ! -f $1/${CONFIG} ]
	then
		echo ${Pmsg} fails $1 has no ${CONFIG}
		exit 102
	fi
	goodconfigfile=$1/$CONFIG
	theme=$1
	;;
esac

if [ ! -d $theme ]
then
	echo ${Pmsg} fails $theme is not a directory
	exit 101
fi
echo CONFIG = $CONFIG
if [ ! -e ./Logs/$theme.i ]
then
	echo ${Pmsg} fails no ./Logs/$theme.i
	exit 103
fi


LogFile=$theme.log
Serial=`head -1 ./Logs/$theme.i`
#Serial=`expr $Serial + 1`
echo `expr $Serial + 1`  > ./Logs/${theme}.i
LogFile=./Logs/${theme}.log.${Serial}
#ExpectedSize=`cat ./Logs/${1}.size`

echo "${Pmsg}  ... starting planet feed aggregator for ${theme} "

/usr/bin/python ./planet.py $goodconfigfile > $LogFile 2>&1 

if [ ! $? -eq '0' ]
then
	echo ${Pmsg} WARNING, python reports an error
	exit $?
fi

echo "$Pmsg ends OK"
