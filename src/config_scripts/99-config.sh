#!/bin/bash

# fedora-kiwi-descriptions2/config.sh

set -euxo pipefail

#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]-[$kiwi_profiles]..."



#======================================
# Clear machine specific configuration
#--------------------------------------
## Clear machine-id on pre generated images
rm -f /etc/machine-id
echo 'uninitialized' > /etc/machine-id
## remove random seed, the newly installed instance should make its own
rm -f /var/lib/systemd/random-seed




#======================================
# Delete & lock the root user password
#--------------------------------------
# if [[ "$kiwi_profiles" == *"Cloud"* ]] || [[ "$kiwi_profiles" == *"Disk"* ]] || [[ "$kiwi_profiles" == *"Live"* ]] || [[ "$kiwi_profiles" == *"WSL"* ]]; then
	passwd -d root
	passwd -l root
# fi

#======================================
# Setup default services
#--------------------------------------

# if [[ "$kiwi_profiles" == *"Live"* ]]; then
	## Configure livesys session
	if [[ "$kiwi_profiles" == *"GNOME"* ]]; then
		echo 'livesys_session="gnome"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"KDE"* ]]; then
		echo 'livesys_session="kde"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"Budgie"* ]]; then
		echo 'livesys_session="budgie"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"Cinnamon"* ]]; then
		echo 'livesys_session="cinnamon"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"COSMIC"* ]]; then
		echo 'livesys_session="cosmic"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"i3"* ]]; then
		echo 'livesys_session="i3"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"LXDE"* ]]; then
		echo 'livesys_session="lxde"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"LXQt"* ]]; then
		echo 'livesys_session="lxqt"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"MATE_Compiz"* ]]; then
		echo 'livesys_session="mate"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"MiracleWM"* ]]; then
		echo 'livesys_session="miraclewm"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"Sway"* ]]; then
		echo 'livesys_session="sway"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"SoaS"* ]]; then
		echo 'livesys_session="soas"' > /etc/sysconfig/livesys
	fi
	if [[ "$kiwi_profiles" == *"Xfce"* ]]; then
		echo 'livesys_session="xfce"' > /etc/sysconfig/livesys
	fi
# fi


#======================================
# Finalization steps
#--------------------------------------
# Inhibit the ldconfig cache generation unit, see rhbz2348669
touch -r "/usr" "/etc/.updated" "/var/.updated"



exit 0
