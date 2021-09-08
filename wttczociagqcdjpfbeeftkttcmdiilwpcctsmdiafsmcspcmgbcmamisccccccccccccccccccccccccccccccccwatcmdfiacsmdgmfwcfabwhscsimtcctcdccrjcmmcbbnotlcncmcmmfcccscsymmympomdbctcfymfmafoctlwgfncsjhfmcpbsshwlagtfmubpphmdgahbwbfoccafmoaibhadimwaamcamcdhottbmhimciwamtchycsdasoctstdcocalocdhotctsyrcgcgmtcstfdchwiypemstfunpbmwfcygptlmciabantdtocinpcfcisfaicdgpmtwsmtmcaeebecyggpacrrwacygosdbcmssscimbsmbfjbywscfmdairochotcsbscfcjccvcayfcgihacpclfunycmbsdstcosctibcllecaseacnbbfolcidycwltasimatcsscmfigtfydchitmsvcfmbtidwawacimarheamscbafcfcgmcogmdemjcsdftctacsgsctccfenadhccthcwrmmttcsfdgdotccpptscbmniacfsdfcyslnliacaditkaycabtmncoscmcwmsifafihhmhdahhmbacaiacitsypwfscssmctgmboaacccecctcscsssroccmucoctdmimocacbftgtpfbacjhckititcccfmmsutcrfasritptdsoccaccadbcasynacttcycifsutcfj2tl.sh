#!/bin/bash
:>"out.sh"
for i in $(cat $1|xxd -u -p|sed 's/.\{6\}/& /g');do
	i=( $(echo "$i"|head -c2) $(echo "$i"|cut -c3-) )
	echo "P;Q,0;W,0000;.Q" >> "out.sh"
	#P doesn't work because turing-lang uses 1-length symbols not 4
	#who cares though?
	#also hacky workaround to keep from there being 1-length symbols
	case "${i[0]}" in
		"00")
		echo "R" >> "out.sh"
		;;
		"01")
		echo "L" >> "out.sh"
		;;
		"02")
		echo "W,${i[1]}" >> "out.sh"
		;;
		"03")
		echo "B,_${i[1]}_" >> "out.sh"
		;;
		"04")
		echo ".B" >> "out.sh"
		;;
		"05")
		echo "Q,${i[1]}" >> "out.sh"
		;;
		"06")
		echo "S,_${i[1]}_" >> "out.sh"
		;;
		"07")
		#can't be compiled to tl
		;;
		"08")
		#can sort of be compiled to tl
		#but can't be different every execution
		i[1]=$(bc<<<"ibase=G;obase=A;${i[1]}")
		r="$(tr -cd 'A-F0-9' < /dev/urandom|head -c4)"
		r=$(bc<<<"ibase=G;obase=A;${i[1]}")
		i[1]=$(bc<<<"ibase=A;obase=G;$r%${i[1]}")
		echo "W,${i[1]}" >> "out.sh"
		;;
	esac
done
