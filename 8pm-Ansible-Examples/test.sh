#!/bin/bash

while getopts m:v:o: flag
do
    case "${flag}" in
        o) org=${OPTARG};;
        v) env=${OPTARG};;
        m) mail=${OPTARG};;
    esac
done



sleep 3
echo "You have selected the organisation as ${org} and the environment as ${env}."
echo ""
sleep 3
if [ -e ${org}-certs.csv ]
then
    echo "File already exists for ${org} organisation."
else
    echo "Generating the file for ${org} organisation............."



echo "peer0-${org}MSP-admincerts,admin.${env}.multitenant.${org}.zuelligpharma.com.crt" >> ${org}-certs.csv
echo "peer0-${org}MSP-signcerts,peer0.${env}.multitenant.${org}.zuelligpharma.com.crt" >> ${org}-certs.csv
fi