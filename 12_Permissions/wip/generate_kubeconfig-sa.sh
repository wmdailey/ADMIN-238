#!/bin/sh

# Title: generate_kubeconfig.sh
# Author: Md Shamim 
# Date: 15SEPT22
# Purpose: This script is used to create a custom kubeconfig file for individual 
# users. The script requires an input of "username", "group name", "namesapce name", 
# and "yes" for execution.

# DEBUG
set -x
#set -eu
#set >> /tmp/setvar.txt

read -p 'Enter the ServiceAccount Name : ' name
read -p 'Enter the Namespace Name: ' namespace

export SA_NAME=$name
export NAMESPACE=$namespace

echo -e "\nServiceAccount Name is: ${SA_NAME}\nand Namespace is: ${NAMESPACE}"
echo -e "\nIf you want to proceed with above informaton, type \"yes\" or \"no\": " 
read value

if [ $value == "yes" ]
then
    mkdir ${SA_NAME}
    cd ${SA_NAME}
    
    #Change context
    kubectl config set-context --current --namespace=$NAMESPACE
    
    #CA extraction from current kubeconfig file
    kubectl config view --raw -o jsonpath='{..cluster.certificate-authority-data}' | base64 --decode > ca.crt
    
    #Generate TOKEN for the Service Account 
    kubectl create token $SA_NAME --duration=60000s > token 
   
    #Set ENV
    export CA_CRT=$(cat ca.crt | base64 -w 0)
    export CONTEXT=$(kubectl config current-context)
    export CLUSTER_ENDPOINT=$(kubectl config view -o jsonpath='{.clusters[?(@.name=="'"$CONTEXT"'")].cluster.server}')
    export SA_NAME=$name
    export NAMESPACE=$namespace
    export TOKEN=$(cat token)
    
    #Configure kubeconfig file
    cat > sa-kubeconfig-template.yaml <<EOF  
#kubeconfig file template
apiVersion: v1
kind: Config
current-context: <context>
clusters:
- name: <cluster-name>
  cluster:
    certificate-authority-data: <ca.crt>
    server: <cluster-endpoint>
contexts:
- name: <context>
  context:
    cluster: <cluster-name>
    user: <user-name>
    namespace: <namespace>
users:
- name: <user-name>
  user:
    client-certificate-data: <user.crt>
    client-key-data: <user.key>
EOF 

    cat sa-kubeconfig-template.yaml | sed "s#<context>#${CONTEXT}# ;
    s#<cluster-name>#${CONTEXT}# ;
    s#<ca.crt>#${CA_CRT}# ;
    s#<cluster-endpoint>#${CLUSTER_ENDPOINT}# ;
    s#<service-account>#${SA_NAME}# ;
    s#<namespace>#${NAMESPACE}# ;
    s#<token>#${TOKEN}#" > config

else
    echo -e "File complete.\n" 
    exit
fi
