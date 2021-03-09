for files in *.json
do
  echo $files
  echo "    "
  oci management-dashboard saved-search create \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaahd45l6jvxsnw5xvnfybs75aqujhmw4ygqjwnawuiay7wo2xjjbba \
--provider-version "2.0" \
--provider-name "Logging Analytics" \
--from-json file://$files
  echo "  "
done


for files in *.json
do
 echo file://$files
done
