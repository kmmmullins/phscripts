#!/bin/bash
cpu_num=1
mem=2
deploy_yml="deploy.yml"
RAND=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
function help { 
echo " Invalid Option: -$OPTARG."
echo "##############################"
echo " Usage: "$0"  -i 'inventory file'"
echo " Optional agruments:"
echo " -c 'number of cpus'"
echo " -m 'mem_size'" 
echo " -t 'OS type', Centos is default"
echo "           Centos 7 Example:  ./deploy.sh -i inventories/ax753-hosts  "
echo "           Ubuntu 18.04 Example:   ./deploy.sh -i inventories/ax753-hosts -t u"
echo " -d 'dipr' "
echo " -e 'puppet environment'" 
echo " -u user,user1,user2"
echo " -n 'your notes about build'"
exit 2
}

if [[ ! $@ =~ ^\-.+ ]]
then
  help
fi

while getopts ":i:c:d:m:e:u:n:t:h:" opt
   do
     case ${opt} in
        i ) inventory=$OPTARG;;
        c ) cpu=$OPTARG;;
        d ) dns_name=$OPTARG;;
        m ) mem=$OPTARG;;
        e ) env=$OPTARG;;
        u ) users=$OPTARG;;
        n ) notes=$OPTARG;;
        t ) template=$OPTARG;;
        h )
           help
           exit 2
           ;;
        *)
           help
           exit 2
           ;;
     esac
done
TARGET="vars-$RAND.yml"
echo >  $TARGET
let "a = $mem * 1024"

echo --- > $TARGET
echo "spec:" >> $TARGET
echo "  nodes:" >> $TARGET
for i in `cat $inventory`; do 
   VM_NAME=$i
   echo "  - name: $i" >> $TARGET
   if  [[ -z  $cpu  ]]; then
      echo "    cpu: 1" >> $TARGET
   else 
      echo "    cpu: $cpu" >> $TARGET
   fi
   if  [[ -z  $dns_name  ]]; then
      echo "    dns_names: NONE" >> $TARGET
      echo "    yaml_name: $VM_NAME.partners.org" >> $TARGET
   else
      echo "    dns_names: $dns_name" >> $TARGET
      echo "    yaml_name: $VM_NAME.$dns_name.partners.org" >> $TARGET
   fi
   if  [[ -z  $mem ]]; then
      echo "    mem: 2048" >> $TARGET
   else
      a=$( expr 1024 '*' "$mem" )
      echo "    mem: $a" >> $TARGET
   fi
   if  [[ -z  $env  ]]; then
      echo "    env: production" >> $TARGET
   else
      echo "    env: $env" >> $TARGET
   fi
   if  [[ -z  $notes  ]]; then
      echo "    notes: Build by Ansible on $(date +'%y%m%d')" >> $TARGET
   else
      echo "    notes: $notes" >> $TARGET
   fi
   if  [[ $users != ""  ]]; then
    echo "    users: " >> $TARGET
    for i in ${users//,/ }; do 
      echo "      - uname: \"$i\"" >> $TARGET
    done
   fi
   echo "    invfile: $TARGET" >> $TARGET
   if  (( "$a" >= 4096  )); then
    echo "    cluster: BigDIPR" >> $TARGET
   else
    echo "    cluster: LittleDIPR" >> $TARGET
   fi
   if [[ $template == "c" ]]; then
      echo "    template: CentOS"  >> $TARGET
   elif [ "$template" ==  "u" ]; then
      echo "    template: Ubuntu"   >> $TARGET
   elif [[ $template == "c8" ]]; then
      echo "    template: Centos8-TMPL"  >> $TARGET
   elif [ "$template" ==  "S" ]; then
      echo "    template: CSB-RIC Custom"   >> $TARGET   
   else
      echo "OS can be c for Centos; u for Ubuntu, default Centos"
      echo "    template: CentOS"  >> $TARGET
   fi
done
export ANSIBLE_LOG_PATH=/ansible/rcs_logs/$(date +%y%m%d%h%m%S)-ansible.log
cat $TARGET


if [ "$os" ==  "Ubuntu" ];
then
     ansible-playbook --vault-password-file=/root/.esx_vault  -i $inventory $deploy_yml -e vars=$TARGET -e yaml_name=$VM_NAME.partners.org -e dns_names=NONE
else
     ansible-playbook --vault-password-file=/root/.esx_vault  -i $inventory $deploy_yml  -e vars=$TARGET
fi

rm -f $TARGET
