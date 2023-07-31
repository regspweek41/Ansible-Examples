#!/bin/bash

while getopts v:o: flag
do
    case "${flag}" in
        o) namespace=${OPTARG};;
        v) context=${OPTARG};;
    esac
done
    # Save the current context
    ORIGINAL_CONTEXT=$(kubectl config current-context)

    # Switch to the desired context/cluster
    kubectl config use-context ${context}

    # Get the name of the CLI pod
    POD_Name=$(kubectl get po -n ${namespace} | grep "middleware" | head -n 1 | awk '{print $1}')
    echo $POD_Name
    kubectl config use-context ${ORIGINAL_CONTEXT}
    