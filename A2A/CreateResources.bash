a=$(az ad signed-in-user show --query userPrincipalName)
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -24}
D=$(echo "$C"a2a01)
RG=MigrateA2A
VNet=A2A-VNet
Nsg=A2ANSG
L=westeurope
VM01=VM01
Pip01=$(echo "$VM01"Pip)
AP="10.208.0.0/16"
SN01="10.208.1.0/24"
user=cem
pass=1q2w3e4r5t6y*
size1=standard_B2ms

az group create -n $RG -l $L

az storage account create -n $D -g $RG --kind Storage -l $L --sku Standard_LRS


az network nsg create -g $RG -n $Nsg
az network nsg rule create -g $RG --nsg-name $Nsg -n DCRule1 --priority 100 --destination-port-ranges "*" --direction Inbound


az network vnet create --resource-group $RG --name $VNet  --address-prefixes $AP --subnet-name SN01 --subnet-prefix $SN01

export SUBNETID=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SN01 --query id -o tsv)
export SUBNETN=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SN01 --query name -o tsv)

az network vnet subnet update -g $RG --vnet-name $VNet -n $SUBNETN --network-security-group $Nsg

az vm create --resource-group $RG -n $VM01 -l $L --image Win2019DataCenter --admin-username $user --admin-password $pass --size $size1 --public-ip-address $Pip01 --public-ip-address-allocation static --subnet $SUBNETID --boot-diagnostics-storage $D --license-type Windows_Server --nsg ""
