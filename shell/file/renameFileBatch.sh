#!/bin/bash

for file in `ls`
do  # 20210113-name  => 2021-0114
    echo "$file" | test $(grep "20210113") 
    && newFileName=$(echo $file | sed -n 's#20210113\(.*\)#20210114\1#p')
    || newFileName=$(echo $file | sed -n 's#20210114\(.*\)#20210115\1#p')
    echo $newFileName
done

:<<1
for file in `ls`; do echo "old - $file" ; echo "$file" | test $(grep "20210113") && newFileName=$(echo $file | sed -n 's#20210113\(.*\)#20210114\1#p') || newFileName=$(echo $file | sed -n 's#20210114\(.*\)#20210115\1#p'); echo "new - $newFileName"; mv $file $newFileName; done

 for i in `ls`; 
 do 
    echo "old $i"
    nfil=$(echo "$i" | $(sed -n 's#\(.*\)-2021011509\(.*\)#\1-2021011510\2#p'))
    mv $i $nfil
done
1