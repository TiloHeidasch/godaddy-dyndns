#!/bin/bash

mydomain=$1
myhostname="@"
key=$2
secret=$3
gdapikey="${key}:${secret}"
logdest="local7.info"

if [ -z ${mydomain} ]; then
	echo "mydomain is unset"
	exit 1
fi
if [ -z ${key} ]; then
	echo "key is unset"
	exit 1
fi
if [ -z ${secret} ]; then
	echo "secret is unset"
	exit 1
fi

while :; do
	myip=$(curl -s "https://api.ipify.org")
	dnsdata=$(curl -s -X GET -H "Authorization: sso-key ${gdapikey}" "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}")
	gdip=$(echo $dnsdata | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2)
	echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $myip, GoDaddy DNS IP is $gdip"

	if [ "$gdip" != "$myip" -a "$myip" != "" ]; then
		echo "IP has changed!! Updating on GoDaddy"
		curl -s -X PUT "https://api.godaddy.com/v1/domains/${mydomain}/records/A/${myhostname}" -H "Authorization: sso-key ${gdapikey}" -H "Content-Type: application/json" -d "[{\"data\": \"${myip}\"}]"
		logger -p $logdest "Changed IP on ${hostname}.${mydomain} from ${gdip} to ${myip}"
	fi
	sleep 5m
done
