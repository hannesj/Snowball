#!/bin/bash
#See comments for snowball-add
snowball_path="etc/snowball/"

installed_pkt=( `cat $snowball_path/installed.files | awk -v i=0 '{print ++i, $1, "off"}'` )

if [ ${#installed_pkt[@]} == 0 ]
then
  echo "No packages installed!"
  exit 1
fi

selected=( `dialog --stdout --separate-output --checklist "Choose package:" 20 40  ${#installed_pkt[@]} ${installed_pkt[@]}` )

for index in ${selected[@]}
do
  curr_pkg=${installed_pkt[($index*3)-2]}
  for file in `tac $snowball_path/$curr_pkg.files` 
  do
    [ -f $file ] && rm -f $file
    [ -d $file ] && [ $file != "./" ] && rmdir --ignore-fail-on-non-empty $file   
  done
  rm $snowball_path/$curr_pkg.files
  sed -i "/$curr_pkg/d" $snowball_path/installed.files
done



