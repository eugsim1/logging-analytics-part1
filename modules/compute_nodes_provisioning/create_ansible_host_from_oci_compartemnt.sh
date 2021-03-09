#### this script create the ansible hosts files for the agent provisionings
####
#### collect IP from compute instances
#### get the ocids
cd  /home/oracle/terraform-excercises/oci-certification/logging-analytics/modules/compute_nodes_provisioning
oci compute instance list \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta |  jq -r '.data[] | .id' > compute_instances_ocids.txt

### create a <ansible hosts file>
### from the vnics of a compartement
### we excpect tha the private key is called wls-wdt-testkey  and it will be on the same directory as the <ansible host file> otherwise the printf should be modified
rm -rf ansible_hosts.txt
echo "[servers]" > ansible_hosts.txt
input="compute_instances_ocids.txt"
while IFS= read -r line
do
echo "comp =>$name compute node ocid=>$line"
Public_ip=`oci compute instance list-vnics \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta \
--instance-id  $line |  jq -r '.data[] |"\(."public-ip")" '`
printf "%s ansible_user=opc ansible_ssh_private_key_file=wls-wdt-testkey\n" $Public_ip >> ansible_hosts.txt
done < "$input" 