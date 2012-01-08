#!/bin/bash
# Installs packages from a http-repository (jens atm) and keeps track of them
# etc/snowball/intstalled.files keeps an overview of installed packages
# every package gets a etc/snowball/"package name".file with all files associated
# writes to current folder instead of fsroot atm (forgetting to chroot before trying would be annoying)
# snowball-del uses similar code but deletes stuff instead 
#TODO: implement bifrost packet specifics. Is http really optimal repository? Support packet versioning/updates etc etc.  
#(C) 2012, Elis Kullberg & Hannes Junnila. This code is public domain, do whatever you like with it.

snowball_path="etc/snowball"
mkdir -p $snowball_path

#Parse http list of packages
#packets=( `curl -k https://laas.mine.nu/jens/bifrost/ | awk -v LINES=0 '/tgz|tar.gz/ {print}' | awk '{gsub(/.*href="|">.*/,"");print ++LINES, $0, "off"}'`)

packets=( `curl --silent ftp://ftp.sunet.se/pub/Linux/distributions/bifrost/opt/ | awk -v LINES=0 '/tgz|tar.gz/ {print ++LINES, $9, "off"}'`)

selected=( `dialog --stdout --separate-output --checklist "Choose package:" 20 40 ${#packets[@]} ${packets[@]} `)

#Figure out what packets correspong to selection numbers in menu
for index in ${selected[@]}
do
  curr_pkg=${packets[($index*3)-2]}
  wget ftp://ftp.sunet.se/pub/Linux/distributions/bifrost/opt/$curr_pkg
  tar -zxvf $curr_pkg > $snowball_path/$curr_pkg.files
  echo "$curr_pkg" >> $snowball_path/installed.files
  rm $curr_pkg
  echo "$curr_pkg installed"
done





