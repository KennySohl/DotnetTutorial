#!/bin/bash

RESOURCE_GROUP_NAME=DotnetTutorialRG
VM_NAME=DotnetTutorialVM
PORT=5000

az group create --name $RESOURCE_GROUP_NAME --location northeurope

az vm create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $VM_NAME \
  --image Ubuntu2404 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys

az vm open-port \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $VM_NAME \
  --port $PORT \
