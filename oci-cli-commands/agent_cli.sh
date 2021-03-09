### helpers to get info on the Agents
###
export AGENT_COMPARTMENT_OCID=ocid1.compartment.oc1..aaaaaaaado7k3yxvwtwwdfuhi4imtwkv2km5opjx6wspihqg3jr325in3rvq
oci management-agent agent list \
--profile DBSEC \
--compartment-id $AGENT_COMPARTMENT_OCID


oci management-agent plugin list \
--profile DBSEC \
--compartment-id $AGENT_COMPARTMENT_OCID


oci management-agent install-key list  \
--profile DBSEC \
--compartment-id $AGENT_COMPARTMENT_OCID






oci compute instance list-vnics \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta \
--instance-id  $line 



oci compute instance list-vnics \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta \
--instance-id ocid1.instance.oc1.eu-frankfurt-1.antheljrufnzx7ickdgyitreeoiatijyo3sqvojjrs5vxl7cnoouyl2enr7a