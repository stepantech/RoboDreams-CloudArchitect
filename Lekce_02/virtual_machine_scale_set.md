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
az vmss create --name $MY_VMSS_NAME --resource-group $MY_RESOURCE_GROUP_NAME --image $MY_VM_IMAGE --authentication-type password --admin-username $MY_USERNAME --admin-password $MY_PASSWORD --orchestration-mode Flexible --instance-count 2 --zones 1 2 3 --vnet-name $MY_VNET_NAME --subnet $MY_VM_SN_NAME --vm-sku Standard_B1s --upgrade-policy-mode Automatic --load-balancer $MY_LB_NAME  -o JSON
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

## Deploy aplikace/custom scriptu do VMSS
Vytvořit soubor **customConfig.json** s obsahem
```
{
  "fileUris": ["https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate_nginx.sh"],
  "commandToExecute": './automate_nginx.sh'
}
```
Aplikování scriptu na VMSS
```
az vmss extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --resource-group $MY_RESOURCE_GROUP_NAME --vmss-name $MY_VMSS_NAME --settings customConfig.json
```
Povolení HTTP
```
az network nsg rule create --name AllowHTTP --resource-group $MY_RESOURCE_GROUP_NAME --nsg-name vmss-vmss-dev-sc-1e780cNSG --access Allow --priority 1010 --destination-port-ranges 80
```

### Aktualizace deployované aplikace/scriptu
Vytvořím si obdobný aktualizovaný script **automate_nginx_v2.sh**
```
az vmss extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --resource-group $MY_RESOURCE_GROUP_NAME --vmss-name $MY_VMSS_NAME --settings @customConfigv2.json
```

## Automatické scalování
### Definice autoscale profilu
```
az monitor autoscale create --resource-group $MY_RESOURCE_GROUP_NAME --resource $MY_VMSS_NAME --resource-type Microsoft.Compute/virtualMachineScaleSets --name autoscale --min-count 2 --max-count 10 --count 2
```

### Vytvoření scale out pravidla
```
az monitor autoscale rule create --resource-group $MY_RESOURCE_GROUP_NAME --autoscale-name autoscale --condition "Percentage CPU > 70 avg 5m" --scale out 3
```

### Vytvoření scale in pravidla
```
az monitor autoscale rule create --resource-group $MY_RESOURCE_GROUP_NAME --autoscale-name autoscale --condition "Percentage CPU < 30 avg 5m" --scale in 1
```

### Vytížení CPU
Připoj se na jednotlivé instance [Connect to Virtual Machine Scale Set instances](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-connect-to-instances-cli) a spusť tyto příkazy:
```
sudo apt-get update
sudo apt-get -y install stress
sudo stress --cpu 10 --timeout 420 &
```

Vytížení CPU si zkontroluj příkazem
```
top
```

### Monitoring aktivity scalování
```
watch -n 10 az vmss list-instances --resource-group $MY_RESOURCE_GROUP_NAME --name $MY_VMSS_NAME --output table
```

## Smazání všech prostředků
```
az group delete --name $MY_RESOURCE_GROUP_NAME --no-wait --yes
```