#!/bin/bash
#
#

#for node in `cat  /home/ky593/ansible/inventories/prodpatching.txt`
po=".partners.org"
dpo=".dipr.partners.org"
rs=".research.partners.org"
bw=".bwh.harvard.edu"
mh=".mgh.harvard.edu"
validnode="none"

for node in `cat  $1`
do
  echo " ";
  echo "******************************************* ";
  echo " ";
  echo $node;
  ping -c2 -i3 $node
  if [ $? -eq 0 ]
  then 
    echo $node >> validnodes-kmm2.txt
    validnode=$node
    echo " Found $node in dns"
    ssh $node "[ -d /opt/CrowdStrike] && echo "/opt/CrowdStrike is installed on $node"
  else
     node2="'$node$po'"
 #    echo $node2
     ping -c2 -i3 $node2
     if [ $? -eq 0 ]
     then
       echo $node2 >> validnodes-kmm2.txt
       validnode=$node2
       echo " Found $node2 in dns"
     else
        node3="'$node$dpo'"
  #      echo $node3
       ping -c2 -i3 $node3
       if [ $? -eq 0 ]
       then
         echo $node3 >> validnodes-kmm2.txt
         validnode=$node3
         echo " Found $node3 in dns"
        else
          node4="'$node$rs'"
  #       echo $node3
          ping -c2 -i3 $node4
          if [ $? -eq 0 ]
          then
           echo $node4 >> validnodes-kmm2.txt
           validnode=$node4
           echo " Found $node4 in dns"
          else
            echo "$node not online or not in dns"
           echo $node >> notonline3
        fi
     fi
  fi
fi

done
exit
#KMM
