# Firejail profile for Gajim

#mkdir ${HOME}/.cache/gajim
#mkdir ${HOME}/.local/share/gajim
#mkdir ${HOME}/.config/gajim
#mkdir ${HOME}/Downloads

# Allow the local python 2.7 site packages, in case any plugins are using these
noblacklist /sbin
noblacklist /usr/sbin

mkdir ${HOME}/.local/lib/python2.7/site-packages/
read-only ${HOME}/.local/lib/python2.7/site-packages/
read-only /bin/bash

whitelist ${HOME}/canary-env
read-write /var/tmp/opencanary.log

read-write /etc/opencanaryd/
read-write /var/log/kern.log

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-devel.inc

#private-etc twistd.pid opencanary.conf
#caps.drop all
netfilter
#nonewprivs
#nogroups
#noroot
private-tmp
protocol unix,inet,inet6
seccomp
#shell none

#private-bin python2.7 
#private-dev
