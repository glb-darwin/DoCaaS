#!/bin/bash

. ./loadvariables.sh

CNAMEC2=`aws elasticbeanstalk describe-environments --environment-names docaas-customer2-eb-env --no-include-deleted | jq --raw-output '.Environments[0].CNAME'`

echo "Adding record to R53"
ZONEID=`aws route53 list-hosted-zones-by-name --dns-name $DOMAIN | jq --raw-output '.HostedZones[0].Id'`
echo "ZONEID is $ZONEID"
cp r53c2.json r53c2-mod.json
find r53c2-mod.json -type f -exec sed -i -e "s/##TARGETGOESHERE##/$CNAMEC2/g" {} \;
find r53c2-mod.json -type f -exec sed -i -e "s/##DOMAINGOESHERE##/$DOMAIN/g" {} \;
aws route53 change-resource-record-sets --hosted-zone-id $ZONEID --change-batch file://r53c2-mod.json
rm -f r53c2-mod.json r53c2-mod.json-e 
echo "Record to R53 Added"

echo "Customer 2 url is: customer2.$DOMAIN"
