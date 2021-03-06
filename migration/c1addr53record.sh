#!/bin/bash

. ./../demos/loadvariables.sh

echo "Updating record in R53"
ZONEID=`aws route53 list-hosted-zones-by-name --dns-name $DOMAIN | jq --raw-output '.HostedZones[0].Id'`
echo "ZONEID is $ZONEID"
cp r53c1.json r53c1-mod.json
find r53c1-mod.json -type f -exec sed -i -e "s/##DOMAINGOESHERE##/$DOMAIN/g" {} \;
aws route53 change-resource-record-sets --hosted-zone-id $ZONEID --change-batch file://r53c1-mod.json
rm -f r53c1-mod.json r53c1-mod.json-e 
echo "Record to R53 Added"

echo "Customer 1 url is: customer1.$DOMAIN"
