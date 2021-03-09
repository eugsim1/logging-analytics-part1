### clean LoggingAnalytics

##'Log Group' = vnc_ingestion | stats count
##'Log Group' = hostlog | timestats count as logrecords by 'Log Source' | sort -logrecords
##'Log Group' = test_vcn | stats count

export WorkshopUser_COMPARTMENTID=ocid1.compartment.oc1..aaaaaaaaold7zxbenwlyogbb7gx3my3gwti3au7aqn5sifgjp6b44x6uf7jq
export LOGGROUP_NAME=vnc_ingestion_from_local_upload
echo "get the NameSpace"
export NAMESPACE=`oci os ns get --profile DBSEC  | jq -r .data`

## ocid1.serviceconnector.oc1.eu-frankfurt-1.amaaaaaaufnzx7iaygvbgpb7owku76brtyzdilhm6xz3raujzbgimiettida
mkdir -p /home/oracle/oci-logs
oci os object bulk-download \
--profile DBSEC \
--bucket-name "loggin_bucket" \
--include ocid1.serviceconnector.oc1.eu-frankfurt-1.amaaaaaaufnzx7iasveyvv4lfvs6quhoe44ewulane2g5vhh3rfryk44tenq* \
--download-dir /home/oracle/oci-logs \
--parallel-operations-count 10 \
--part-size  128 --overwrite
oci os object bulk-download \
--profile DBSEC \
--bucket-name "loggin_bucket" \
--include ocid1.serviceconnector.oc1.eu-frankfurt-1.amaaaaaaufnzx7iak2pvanmkv7oe4x3p4tphlk6d43mgb2pr665jro4ghlwa* \
--download-dir /home/oracle/oci-logs \
--parallel-operations-count 10 \
--part-size  128 --overwrite
oci os object bulk-download \
--profile DBSEC \
--bucket-name "loggin_bucket" \
--include ocid1.serviceconnector.oc1.eu-frankfurt-1.amaaaaaaufnzx7iaygvbgpb7owku76brtyzdilhm6xz3raujzbgimiettida* \
--download-dir /home/oracle/oci-logs \
--parallel-operations-count 10 \
--part-size  128 --overwrite


oci os object bulk-delete  \
--profile DBSEC \
--bucket-name "loggin_bucket" \
--include ocid1.serviceconnector.* \
--force --parallel-operations-count 10 



### create a log group
cat<<EOF>defined-tags.json
{"Oracle-Tags":{"ResourceAllocation":"Logging-Analytics"}}
EOF

export LOGGROUPID=`oci log-analytics log-group create \
--profile DBSEC \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--namespace-name $NAMESPACE  \
--defined-tags  file://defined-tags.json \
--display-name "test_vcn"  | jq -r .data.id`
echo "LOGGROUPID=>$LOGGROUPID"

oci log-analytics source list-sources \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--profile DBSEC \
--namespace-name $NAMESPACE | jq -r '.data.items[] | "\(.name) \(."type-display-name") \(."association-count") \(.description)" '

### get all log groups
oci log-analytics log-group list \
--profile DBSEC \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--namespace-name $NAMESPACE --all | jq -r '.data.items[] | " \(."display-name") \(.id) "' | awk '{print $NF}' > log-group_ocids.txt
cat log-group_ocids.txt

input="log-group_ocids.txt"
while IFS= read -r line
do
 oci log-analytics log-group get \
 --profile DBSEC \
 --namespace-name $NAMESPACE \
 --log-group-id $line | jq -r '.data | "\(."display-name")  \(.description) \(.id)"'
done < "$input"


#### prepapre manual upload
export OCI_LOG_FILE=/home/oracle/oci-logs/ocid1.serviceconnector.oc1.eu-frankfurt-1.amaaaaaaufnzx7iak2pvanmkv7oe4x3p4tphlk6d43mgb2pr665jro4ghlwa/*
export WorkshopUser=test_user
export upload_name=${WorkshopUser}_vcn_logs
export log-source-name="OCI VCN Flow Logs"
for file in  $OCI_LOG_FILE
do
  echo `basename $file`
done

export OCI_LOG_FILE=/home/oracle/oci-logs/ocid1.serviceconnector.oc1.eu-frankfurt-1.amaaaaaaufnzx7iak2pvanmkv7oe4x3p4tphlk6d43mgb2pr665jro4ghlwa/*
export log_source_name="OCI VCN Flow Unified Schema Logs"
rm -f upload_files.sh
for file in  $OCI_LOG_FILE
do
filename=`basename $file`
cat<<EOF>> upload_files.sh
oci log-analytics upload upload-log-file  \\
--profile DBSEC \\
--namespace-name $NAMESPACE  \\
--file $file \\
--filename $filename \\
--log-source-name  "$log_source_name" \\
--namespace-name $NAMESPACE \\
--opc-meta-loggrpid $LOGGROUPID \\
--upload-name $upload_name

EOF
done

cat upload_files.sh
chmod u+x upload_files.sh
./upload_files.sh

#####################