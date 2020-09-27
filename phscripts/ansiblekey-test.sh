#!/bin/bash
#
#

#for node in `cat  /home/ky593/ansible/inventories/prodpatching.txt`
for node in `cat  $1`
do
echo " ";
echo "******************************************* ";
echo " ";
echo $node;
ping -c2 -i3 $node

if [ $? -eq 0 ]
then
ssh root@$node "hostname";
ssh root@$node "uptime";
ssh root@$node "[[ -f /etc/redhat-release ]] && cat /etc/redhat-release || cat /etc/issue";
#ssh root@$node "[[ -f /etc/sssd/sssd.conf ]] && grep allow /etc/sssd/sssd.conf || cat /etc/redhat-release";
ssh root@$node "grep admin /etc/group ";
echo "+++++++++++++++++++++++++++++++++"
#ssh root@$node "grep requiretty /etc/sudoers | grep -v without";
#ssh root@$node "crontab -l | grep puppetlabs";
#ssh root@$node "yum history | head -n 8 ";
#ssh root@$node "dsmc q fi  ";
#ssh root@$node "ls -lad /opt/splunkforwarder  ";

else
echo "*************** $node failed ****************"
echo "*************** $node failed ****************"
echo "*************** $node failed ****************"
echo "*************** $node failed ****************"
fi



done
