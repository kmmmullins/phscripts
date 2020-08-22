#!/bin/bash
#
# Partners Healthcare - ERIS
# Fabio Martins - 07/15/2015
# eris-generate-csr.sh
#

echo "IMPORTANT: This script is supposed to be ran with the sudo command!"
echo "If you didn't use sudo, please press CTRL+C now!"
echo 
echo "This script will generate a CSR to issue a certificate."
read -r -p "Do you want to continue? [Y/n] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
   ERISPATH="/crypto"
   read -r -p "Enter the DN for the certificate (your server hostname): " CERTIFICATEDN
   read -r -p "Enter a challenge password (min 4 bytes long, max 20 bytes long): " CHALLENGE
   echo "Creating diretory: $ERISPATH/$CERTIFICATEDN ..."
   mkdir $ERISPATH/$CERTIFICATEDN
   echo "Setting proper permissions ..."
   chmod 750 $ERISPATH/$CERTIFICATEDN
   echo "Setting proper group accesses ..."
   chgrp PHS-ERISADM-G $ERISPATH/$CERTIFICATEDN
   echo "Generating certificate key ..."
   /usr/bin/openssl genrsa -out $ERISPATH/$CERTIFICATEDN/$CERTIFICATEDN.key 4096
   echo "Generating CSR ..."
   sudo /opt/eris/bin/eris-generate-csr-v2.exp "US" "MA" "Boston" "Partners Healthcare" "ERIS" "$CERTIFICATEDN" "erisalerts
@partners.org" "$CHALLENGE" "PHS" "$ERISPATH/$CERTIFICATEDN/$CERTIFICATEDN.key" "$ERISPATH/$CERTIFICATEDN/$CERTIFICATEDN.cs
r" 
   echo "CSR generated."
   echo "-------------------------------------------------------------------------------------------"
   echo "Checking key & csr ..."
   /usr/bin/openssl rsa -noout -modulus -in $ERISPATH/$CERTIFICATEDN/$CERTIFICATEDN.key | openssl md5
   /usr/bin/openssl req -noout -modulus -in $ERISPATH/$CERTIFICATEDN/$CERTIFICATEDN.csr | openssl md5
   echo "If the hashes shown are different, you have a problem with the key or the csr!"
   echo "-------------------------------------------------------------------------------------------"
   echo
   echo "This is your CSR:"
   cat $ERISPATH/$CERTIFICATEDN/$CERTIFICATEDN.csr
   echo 
   echo "Copy it and paste it in the CSR field in the InCommon website."
   echo "Reference:"
   echo "https://confluence.partners.org/display/EI/Issuing+InCommon+Certificate"
else
   exit
fi

