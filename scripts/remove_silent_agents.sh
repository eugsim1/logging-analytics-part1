oci management-agent agent list \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaafvsxrymuqiytkja2r47xjxcmbeeoxed3fthapg2azd6r72heonra \
--lifecycle-state ACTIVE | jq '.data[] | " \(.id) \(."availability-status") " '  | grep SILENT | sed 's/" //g' | sed 's/SILENT \"//g' > silent.txt


while IFS= read -r line; do 
oci management-agent agent delete \
--profile DBSEC \
--agent-id $line \
--force
done <silent.txt

