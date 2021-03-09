###
### Main clean up script give the tenancy and this script will remove any log an artifacts
### 
###
export LOGGING_ANALYTICS_COMPARTEMT=LoggingAnalytics
echo "get the NameSpace for the tenancy "
export NAMESPACE=`oci os ns get --profile DBSEC | jq -r .data`
DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE:Workshop NAMESPACE=>$NAMESPACE"
rm -rf cleanup.txt

oci iam compartment list \
--profile DBSEC \
--access-level  ANY \
--compartment-id-in-subtree true \
--compartment-id "ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq" \
--lifecycle-state ACTIVE | jq -r ' .data[] | .name ' > compartemnts_name.txt


## if there no compartemnts_name.txt   dont go furhter DRYRUN  to report configurations 
if [  -s compartemnts_name.txt ]
then 
  ./01-delete_all_uploads.sh
  input="compartemnts_name.txt"
  while IFS= read -r line
  do
    ./02-clean_log_analytics_compartement.sh $line  
	./03-delete-saved-searches $line
  done < "$input"
fi

##./clean_log_analytics_compartement.sh $LOGGING_ANALYTICS_COMPARTEMT

oci log-analytics storage purge-storage-data \
--compartment-id "ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq" \
--namespace-name $NAMESPACE \
--compartment-id-in-subtree true \
--profile DBSEC \
--time-data-ended 2021-02-12