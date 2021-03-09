###
### this script deletes all saved searches from a compartment
### 
###export COMPARTMNT_ID=$1
export COMPARTMNT_ID=ocid1.compartment.oc1..aaaaaaaalatb5qnxqrqh7c3fnuj5q7k4mndh3zw7ctq3hkjdwljl2nlbojga


oci iam compartment list \
--profile DBSEC \
--access-level  ANY \
--compartment-id-in-subtree true \
--compartment-id "ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq" \
--lifecycle-state ACTIVE | jq -r ' .data[] | .id ' > compartemnts_name.txt

rm -rf saved_serches_ocid.txt

while IFS= read -r line 
do
COMPARTMNT_ID=$line
echo $COMPARTMNT_ID
oci management-dashboard saved-search list \
--profile DBSEC \
--compartment-id $COMPARTMNT_ID  \
--all | jq -r ' .data.items[]  | .id ' >> saved_serches_ocid.txt
done < compartemnts_name.txt

while IFS= read -r line 
do
oci management-dashboard saved-search delete  \
--profile DBSEC \
--management-saved-search-id $line \
--force
done < saved_serches_ocid.txt