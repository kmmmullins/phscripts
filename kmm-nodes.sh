#!/bin/bash
#
#
# for loop to run thru servers
#
#
DATE=`date +%m%d%y%H%M`
tempfile=/home/ky593/puppet-home`$DATE`
for node in kmmc7.dipr.partners.org kmmt1.dipr.partners.org kmmt2.dipr.partners.org kmm-test.dipr.partners.org
do
echo $node;
ssh $node "cat /var/spool/cron/root | grep partners.org "  
echo "---------------";
done
#echo $tempfile
#cat $tempfile

