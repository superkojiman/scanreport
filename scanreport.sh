#!/bin/bash

function usage {
	echo "Usage: $1 [-f nmap.grepable] [-i IP] [-p port] [-s service] [-P protocol] [-a]"
	echo "  -a: outputs matching IP addresses only"
}

db=""
ip=""
port=""
all=0
proto=""
addressonly=""
while getopts "f:i:p:P:s:a" OPT; do
	case $OPT in
		f) db=$OPTARG;;
		i) ip=$OPTARG;;
		p) port=$OPTARG;;
		s) service=$OPTARG;;
		P) proto=$OPTARG;;
		a) addressonly=true;;
		*) usage $0; exit;;
	esac
done

if [[ -z $db ]]; then 
	# check if nmap-db.grep exists
	if [[ -f ${HOME}/nmap-db.grep ]]; then 
		db=${HOME}/nmap-db.grep
	else
		usage $0
		exit
	fi
fi

if [[ ! -z $ip ]]; then # search by IP
	r=$(grep -w $ip "$db" | grep -v ^# | sed 's/Ports: /\'$'\n/g' |  tr '/' '\t' | tr ',' '\n' | sed 's/^ //g' | grep -v "Status: Up" | sed 's/Host:/\\033[0;32mHost:\\033[0;39m/g' | sed 's/Ignored State.*$//')

elif [[ ! -z $port ]]; then # search by port number
	r=$(grep -w -E -e "($port)\/open" "$db" | grep -v ^# | sed 's/Ports: /\'$'\n/g' |  tr '/' '\t' | tr ',' '\n' | sed 's/^ //g' | grep -v "Status: Up" | grep -E -e "Host: " -e "^(${port})" | sed 's/Host:/\\033[0;32mHost:\\033[0;39m/g' | sed 's/Ignored State.*$//')

elif [[ ! -z $service ]]; then # search by service name
	r=$(grep -w -E -i -e "($service)" "$db" | grep -v ^# | sed 's/Ports: /\'$'\n/g' |  tr '/' '\t' | tr ',' '\n' | sed 's/^ //g' | grep -v "Status: Up" | grep -i -E -e "Host: " -e "(${service})" | sed 's/Host:/\\033[0;32mHost:\\033[0;39m/g' | sed 's/Ignored State.*$//')

else
	r=$(cat "$db" | grep -v ^# | sed 's/Ports: /\'$'\n/g' | tr '/' '\t' | tr ',' '\n' | sed 's/^ //g' | grep -v "Status: Up" | sed 's/Host:/\\033[0;32mHost:\\033[0;39m/g' | sed 's/Ignored State.*$//')
fi

if [[ ! -z $addressonly ]]; then # output only IPs/hostnames
	echo -e "$r" | grep "Host:" | awk {'print $2'}
else
	echo -e "$r"
fi