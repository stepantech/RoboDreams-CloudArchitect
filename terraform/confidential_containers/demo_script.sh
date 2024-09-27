# Get cluster credentials
az aks get-credentials -n $(terraform output -raw aks_name) -g $(terraform output -raw resource_group_name) --overwrite-existing --admin

# Jump into default node
kubectl debug -it --image=ubuntu --profile=sysadmin node/$(kubectl get nodes -l agentpool=default -o jsonpath='{.items[0].metadata.name}')

apt update
apt install -y -qq procdump
ps aux | grep secret_app
procdump -w secret_app
grep nonexistentthing secret_app_time_2024-08-03_19:34:19.94204   # NO MATCH
grep mysecurepassword secret_app_time_2024-08-03_19:34:19.94204   # MATCH
exit

# Jump into Kata node
kubectl debug -it --image=ubuntu --profile=sysadmin node/$(kubectl get nodes -l agentpool=kata -o jsonpath='{.items[0].metadata.name}')
ps aux | grep secret_app  # NO secret_app process because app is isolated in Kata VM
apt update
apt install -y -qq wget
wget https://github.com/microsoft/avml/releases/download/v0.14.0/avml
chmod +x ./avml
./avml dump  # Dumps all memory on node
grep nonexistentthing dump   # NO MATCH
grep mysecurepassword dump   # MATCH

# Jump into confidential containers node
kubectl debug -it --image=ubuntu --profile=sysadmin node/$(kubectl get nodes -l agentpool=confidential -o jsonpath='{.items[0].metadata.name}')
ps aux | grep secret_app  # NO secret_app process because app is isolated in Kata VM
apt update
apt install -y -qq wget
wget https://github.com/microsoft/avml/releases/download/v0.14.0/avml
chmod +x ./avml
./avml dump  # Dumps all memory on node
grep nonexistentthing dump   # NO MATCH
grep mysecurepassword dump   # NO MATCH