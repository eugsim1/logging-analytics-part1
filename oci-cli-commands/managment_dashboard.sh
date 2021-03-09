export LOGAN_COMPT_OCID=ocid1.compartment.oc1..aaaaaaaahd45l6jvxsnw5xvnfybs75aqujhmw4ygqjwnawuiay7wo2xjjbba
export LOGAN_ROOT_COMP_OCID=ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq
export LOGAN_ROOT_COMP_LABEL="oractdemeasec (root)"
export LOGAN_LOGCROUP_NAME="logginganalytics-analytics000"

oci management-dashboard dashboard list \
--profile DBSEC \
--compartment-id $LOGAN_COMPT_OCID --all | jq -r .data.items[]


oci management-dashboard dashboard get  \
--profile DBSEC \
--management-dashboard-id ocid1.managementdashboard.oc1..aaaaaaaau6oc65rwco3wrxr44jd35dm3nvwfk6ijeflgszxa664q6ho5jc4a | \
jq -r .data

oci management-dashboard dashboard create \
--profile DBSEC \
--from-json file://dashboard.json