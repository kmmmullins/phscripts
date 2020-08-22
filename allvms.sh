#!/bin/bash

for node in `cat /home/ky593/scripts/nodes.txt`
#for node in kmmc7.dipr.partners.org kmmt1.dipr.partners.org tf889c6.dipr.partners.org phurpa-vm.dipr.partners.org
do
echo " ";
echo $node;
ssh root@$node "cat /etc/redhat-release";
ssh root@$node "[[ -f /etc/redhat-release ]] && cat /etc/redhat-release || cat /etc/issue";
ssh root@$node "uptime";
ssh root@$node "df -h | grep -v tmpfs";
ssh root@$node "crontab -l | grep puppetlabs";
ssh root@$node "last | head -10";
done

