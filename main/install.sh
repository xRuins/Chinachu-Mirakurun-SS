#!/bin/bash

# ------------------------------------------------------- #
#
# Chinachu with Mirakurun Sleep Scripts - Installer
#
# Copyright (c) 2016 tag
#
# ------------------------------------------------------- #

# ======================================================= #

function CheckRunAsRoot() {
	echo "checking this script is run as root..."
	if [ "$UID" -ne 0 ]
	then
		echo "error: please run as root." 1>&2
		exit 1
	fi
}

# ======================================================= #

function CreateAndImportConfig() {
	echo "setup configuration:"

	Prefix="/usr/local"
	ProjectName="chinachu-mirakurun-ss"
	ConfigFile="${Prefix}/etc/${ProjectName}/config"
	ComponentsListFile="${Prefix}/etc/${ProjectName}/components"

	# check to exist the directory
	if [ ! -d ${ConfigFile%/*} ]
	then
		echo "creating a configuration directory..."
		mkdir -p ${ConfigFile%/*}
	fi

	# check to exist the config file
	if [ ! -f ${ConfigFile} ]
	then
		echo "creating a configuration file..."
		cp ./etc/config ${ConfigFile%/*}
	fi

	# import the config file
	source ${ConfigFile}

	# copy and import the components list file
	cp -f ./etc/components ${ComponentsListFile} 
	source ${ComponentsListFile}

	echo
}

# ======================================================= #

function CopyLibs() {
	echo "setup libraries:"

	if [ ! -d ${LibDir} ]
	then
		mkdir -p ${LibDir}
	fi

	for F in `ls ./lib`
	do
		echo "copying \`${F}'..."
		cp "./lib/${F}" "${LibDir}/${F}"
		chmod +x "${LibDir}/${F}"
	done

	echo
}

# ------------------------------------------------------- #

function LinkPowerManagerScript() {
	echo "setup power manager:"

	if [ -d ${PmUtilsScript%/*} ]
	then
		echo "linking to script for pm-utils..."
		ln -fs ${LibDir}/chinachu-mirakurun-sleep ${PmUtilsScript}
	fi

	if [ -d ${SystemdScript%/*} ]
	then
		echo "linking to script for systemd..."
		ln -fs ${LibDir}/chinachu-mirakurun-sleep ${SystemdScript}
	fi

	echo
}

# ======================================================= #

function SetupCron() {
	echo "setup cron for sleep:"

	# delete a cron file if it exists
	if [ -f ${CronScript} ]
	then
		echo "deleting an old cron file..."
		rm -f ${CronScript}
	fi

	# copy a cron file
	echo "creating an cron base file..."
	cp ./cron/chinachu-mirakurun-ss-cron ${CronScript}

	# write a cron schedule
	declare CronEntry="*/${CheckPeriod} * * * * root ${ChinachuCheckStatus} && sleep 10 && ${ShiftToSleep}"
	echo "writing a cron job..."
	echo "${CronEntry}" >> "${CronScript}"

	echo
}

# ------------------------------------------------------- #

function RestartCron() {
	echo "restart cron daemon:"

	InitSystem=`ps -p 1 | tail -n 1 | tr -s " " " " | sed "s/^[ ]*//" | cut -d " " -f 4`
	OsName=`cat /etc/os-release | grep "^NAME=" |  cat /etc/os-release | grep "^NAME=" | cut -d "=" -f 2 | tr -d "\""`

	case ${InitSystem##*/} in
	init)
		# for SysVinit / Upstart
		if [ -f /etc/rc.d/init.d/crond ]
		then
			/etc/rc.d/in.d/crond restart
		elif [ -f /etc/init.d/crond ]
		then
			# for Debian (?)
			/etc/init.d/crond restart
		elif [ -f /etc/init.d/cron ]
		then
			# for Ubuntu
			/etc/init.d/cron restart
		fi	 
		;;
	systemd)
		# for systemd
		# for RHEL / CentOS 7.x
		systemctl restart crond.service
		;;
	esac

	if (( $? != 0 ))
	then
		echo "error: please restart crond by yourself." 1>&2
	fi

	echo
}

# ======================================================= #


# ======================================================= #

echo
echo "# ------------------------------------------------------- #"
echo "#                                                         #"
echo "#    Chinachu with Mirakurun Sleep Scripts - Installer    #"
echo "#                                                         #"
echo "#                               Copyright (c) 2016 tag    #"
echo "#                                                         #"
echo "# ------------------------------------------------------- #"
echo

# check evironment
CheckRunAsRoot
CreateAndImportConfig

echo
echo "# ------------------------------------------------------- #"
echo

CopyLibs
LinkPowerManagerScript

SetupCron
RestartCron

echo
echo "# ------------------------------------------------------- #"
echo
echo "Installation is finished."
exit 0

# ======================================================= #
