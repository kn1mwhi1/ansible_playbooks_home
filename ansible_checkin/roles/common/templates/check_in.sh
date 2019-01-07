#!/bin/bash

USER=admin
PASS=password
INVID=2
ANS_SERVER=10.0.0.3
HOSTNAME=$(hostname | sed 's^\.^ ^g' | awk '{print $1}')
DATE_TIME=$(date +%F_%T)

getHostInfo()
{
mkdir -p /root/scripts

cat > /root/scripts/payload.json <<EOF
{
    "name": "${HOSTNAME}",
    "description": "this was added via API",
    "enabled": true,
    "instance_id": "2",
    "variables": "last_checkin: ${DATE_TIME}"
}
EOF
}

send()
{
output=$(curl -s -u ${USER}:${PASS} -X POST -d @/root/scripts/payload.json -H "Content-Type: application/json" -k http://${ANS_SERVER}/api/v2/inventories/${INVID}/hosts/)




if echo $output | grep -i 'Host with this Name and Inventory already exists.' > /dev/null ;
then

#getId=$(curl -s -u ${USER}:${PASS} -X GET -H "Content-Type: application/json" -k http://${ANS_SERVER}/api/v2/hosts/?search="${HOSTNAME}" | jq '.results[0].id')
getId=$(curl -s -u ${USER}:${PASS} -X GET -H "Content-Type: application/json" -k http://${ANS_SERVER}/api/v2/hosts/?search=sonarr | sed -E 's/,"type":"host","url"/\n/g' | head -1 | sed -E 's/\{"count":1,"next":null,"previous":null,"results"\:\[\{"id"\://g')


cat > /root/scripts/payload.json <<EOF
{
    "variables": "last_checkin: ${DATE_TIME}"
}
EOF









updateOutput=$(curl -s -u ${USER}:${PASS} -X PUT -d @/root/scripts/payload.json -H "Content-Type: application/json" -k http://${ANS_SERVER}/api/v2/hosts/${getId}/variable_data/ )

echo $updateOutput
fi


}

############################### MAIN ##########################
cd /root/scripts
getHostInfo
send
