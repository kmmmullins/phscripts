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
echo " ++++++++  "
nslookup $node 8.8.8.8
echo " ++++++++  "
nslookup $node 
echo " ++++++++  "


done

