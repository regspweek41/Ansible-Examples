#!/bin/bash

while getopts o:v:c:z:r:p:x: flag
do
    case "${flag}" in
        o) namespace=${OPTARG};;
        v) enviro=${OPTARG};;
        c) context=${OPTARG};;
        x) channels=${OPTARG};;
        z) nzpcluster=${OPTARG};;
        r) resourcegroup=${OPTARG};;
        p) privatednszone=${OPTARG};;
        
    esac
done

echo $context
kubectl config use-context $context
#eztracker-mt-prod-new-zp
helmRelease="my-release"
echo $helmRelease
helmStatus=$(helm status "$helmRelease" -n $namespace )
echo $helmStatus
podgrepname="my-release-nginx"
echo $podgrepname

 
if [[ $helmStatus =~ STATUS:\ deployed ]]; then
    podName=$(kubectl get pods -n $namespace | grep $podgrepname | awk '{print $1}')
    echo $podName
    #podPhase=$(kubectl get pod -n $namespace $podName -o jsonpath="{.status.phase}" )
    # podstateStatus=$(kubectl get pod -n ${organ}-net $podName -o jsonpath="{.status.containerStatuses.state.reason}" )


    timeout=240
    start_time=$(date +%s)
    retry_count=1;

    while true; do 
    podPhase=$(kubectl get pod -n $namespace $podName -o jsonpath="{.status.phase}" )
    if [[ $podPhase = "Running" ]]; then
        echo "Helm release $helmRelease is deployed and pod is running."
        exit 0
    fi
   
    elapsed_time=$(($(date +%s) - $start_time))

    if [ $elapsed_time -ge $timeout ]; then
    echo "After waiting for 240 seconds, Helm release $helmRelease is not deployed or has failed."
    exit 1
    fi

    echo "waiting for the pod status to be completed, retry count :${retry_count}"
    retry_count=$((retry_count+1))
    sleep 5
    done
fi
echo "logger check end"
# podName1=$(kubectl get pods -n ${organ}-net -o=jsonpath='{.items[*].metadata.name}' | grep 'anchorpeer-peer1-${organ}-msd-[0-9]\{4\}')
# echo podName1 $podName1
# podName2=$(kubectl get pods -n ${organ}-net | grep anchorpeer-peer1-${organ}-msd | awk '{print $1}')
# echo podName2 $podName2