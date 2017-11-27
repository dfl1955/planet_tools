#!/bin/bash

# Author : Dave Levy, London  CC BY-SA 

# $Header: /opt/planet/tidy_planetlogs.sh,v 1.2 2006/12/24 10:03:05 planet Exp $

# $Log: tidy_planetlogs.sh,v $
# Revision 1.2  2006/12/24 10:03:05  planet
# The counter files can now be reset to zero, a help/usage function was
# implemented. RCS control was implemented.
#

Pname=$0
PVer=1.3
Pmsg="${Pname} ${Pver}"
USAGE="$Pname [ -h ] | [ -r  planetname ]"
#
# Could do with a log cycling parameters
#
. ${HOME}/venus/venus/functions



LOGDIR=${HOME}//venus/venus/Logs
LOGDIR=${BASEDIR}/Logs

case $1 in
-h|h|-help|help|-?) echo $USAGE ; exit ;;
-r|r|-reset|reset) \
	if [  -f ${LOGDIR}/$2.i ]; then
		echo ${Pmsg} starts
		echo 0 > ${LOGDIR}/${2}.i
		echo ${Pmsg} ${LOGDIR}/$2.i reset to 0
	else
		echo " ${2}.i not found in $LOGDIR"
	fi
	exit ;;
esac

echo ${Pmsg} starts

cd $HOME/venus
cd ${BASEDIR}
TooOld=2
set s

echo ${Pmsg} starts
if [ $TooOld -gt 1 ]
then
	plural=s
fi

echo ${Pmsg} ... deleting files over ${TooOld} day${plural}

if [ ! -d ${LOGDIR} ]
then
	echo ${Pmsg} fails ./Logs is not a directory
	exit 101
fi

set OLDLOGS
PLANETS=`listplanets`
counter=0

for planet in ${PLANETS}
do
	counter=0
	for OldLogFile in $(find ${LOGDIR} -name "${planet}.log.*"  -mtime +${TooOld})
	do
		#echo  ${OldLogFile}
		[ -f ${OldLogFile} ] && ( rm ${OldLogFile} ; counter=`expr $counter + 1`)
	done
	# it'd be nice to have the word file agree with $counter
	echo ${Pmsg} $counter Log File belonging to $planet deleted
done

echo ${Pmsg}  ends


echo "$Pmsg ends OK"
