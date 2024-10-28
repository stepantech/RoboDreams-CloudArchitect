# Demo použití Virtual Machine Scale Set

> Source: [What are Virtual Machine Scale Sets?](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-create-and-manage-cli)

## Variables
```
export RANDOM_ID="$(openssl rand -hex 3)"
export MY_RESOURCE_GROUP_NAME="rg-vmss-dev-sc-001"
export REGION=swedencentral
export MY_VNET_NAME="vnet-vmss-dev-sc-$RANDOM_ID"
export NETWORK_PREFIX="$(($RANDOM % 254 + 1))"
export MY_VNET_PREFIX="10.$NETWORK_PREFIX.0.0/16"
export MY_VM_SN_NAME="myVMSN$RANDOM_ID"
export MY_VM_SN_PREFIX="10.$NETWORK_PREFIX.0.0/24"
export MY_VMSS_NAME="vmss-vmss-dev-sc-$RANDOM_ID"
export MY_VM_IMAGE="Ubuntu2204"
export MY_USERNAME="adminuser"
export MY_PASSWORD="Azure12345678"
export MY_LB_NAME="lb-vmss-dev-sc-$RANDOM_ID"

```

## Vytvoření RESOURCE GROUP
```
az group create --name $MY_RESOURCE_GROUP_NAME --location $REGION -o JSON
```

## Vytvoření VIRTUAL NETWORK a SUBNET
```
az network vnet create  --name $MY_VNET_NAME  --resource-group $MY_RESOURCE_GROUP_NAME --location $REGION  --address-prefix $MY_VNET_PREFIX  --subnet-name $MY_VM_SN_NAME --subnet-prefix $MY_VM_SN_PREFIX -o JSON
```

## Vytvoření VMSS
```
az vmss create --name $MY_VMSS_NAME --resource-group $MY_RESOURCE_GROUP_NAME --image $MY_VM_IMAGE --authentication-type password --admin-username $MY_USERNAME --admin-password $MY_PASSWORD  --public-ip-per-vm --orchestration-mode Flexible --instance-count 2 --zones 1 2 3 --vnet-name $MY_VNET_NAME --subnet $MY_VM_SN_NAME --vm-sku Standard_B1s --upgrade-policy-mode Automatic --load-balancer $MY_LB_NAME  -o JSON
```

### Výpis informací o VMSS
```
az vm list --resource-group $MY_RESOURCE_GROUP_NAME --output table
```
### Změna počtu VM na 3
```
az vmss scale --resource-group $MY_RESOURCE_GROUP_NAME --name $MY_VMSS_NAME --new-capacity 3
```
### Dealokace VM ve scale set
```
az vmss deallocate --resource-group $MY_RESOURCE_GROUP_NAME --name $MY_VMSS_NAME
```
### Start VM ve scale set
```
az vmss start --resource-group $MY_RESOURCE_GROUP_NAME --name $MY_VMSS_NAME
```




## Smazání všech prostředků
```
az group delete --name $MY_RESOURCE_GROUP_NAME --no-wait --yes
```