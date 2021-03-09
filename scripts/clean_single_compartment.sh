###
###  Remove all logan artifacts from a single compartment
###

DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
export NAMESPACE=`oci os --profile DBSEC ns get | jq -r .data`
echo "$DATE:Start of the clean up process" >> cleanup.txt
export user=analytics001

if [ -z $user ]
   then
   echo " usage clean_single_compartment.sh compartment_name example => clean_single_compartment.sh analyticsXXXX"
   exit 1
fi   

oci log-analytics upload list \
--profile DBSEC \
--namespace-name $NAMESPACE \
--name  "logginganalytics-$user" |jq -r .data.items[].reference > upload_list.txt
 
if [[ ! -f  "upload_list.txt" ]]
then
	 echo "No upload list for the $COMPARTMENT_NAME"
else
	DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
	echo "$DATE:Upload_ref=>upload_list.txt" >> cleanup.txt
	while IFS= read -r line; do 
	oci log-analytics upload delete \
	--profile DBSEC \
	--namespace-name $NAMESPACE \
	--upload-reference $line \
	--force	
	done < upload_list.txt
fi
	
oci iam compartment list \
--access-level ACCESSIBLE \
--profile DBSEC \
--name $user \
--lifecycle-state ACTIVE \
--compartment-id ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq \
--compartment-id-in-subtree true | jq -r .data[].id > COMPARTMENTID.txt	

while IFS= read -r line; do
COMPARTMENTID=$line
oci log-analytics entity list \
--profile DBSEC \
--namespace-name $NAMESPACE \
--compartment-id $COMPARTMENTID \
--lifecycle-state ACTIVE \
| jq  '.data.items[] | "\(."are-logs-collected") \(."entity-type-internal-name") \(."entity-type-name") \(."name")   \(.id)"' | sed 's/"//g' | awk '{print $NF}' > entity_ids.txt

	if [ ! -s entity_ids.txt ]
		then
			echo "No entities discovered for the compartment $COMPARTMENT_NAME "
			DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
			echo "$DATE:No entities discovered for the compartment $COMPARTMENT_NAME ">> cleanup.txt
		else
		### delete the entities
			cp entity_ids.txt ${COMPARTMENT_NAME}_entity_ids.rpt

					echo "delete the entities of the compartment $COMPARTMENT_NAME "
					DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
					echo "$DATE:delete the entities of the compartment $COMPARTMENT_NAME ">> cleanup.txt
					input="entity_ids.txt"
					while IFS= read -r line
						do   
						echo "delete entity $line"
						DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
						echo "delete entity $line">> cleanup.txt
						oci log-analytics entity delete \
						--entity-id $line \
						--profile DBSEC \
						--namespace-name $NAMESPACE \
						--force
					done < "$input"


	fi
done < COMPARTMENTID.txt

oci log-analytics log-group list \
--profile DBSEC \
--compartment-id $COMPARTMENTID   \
--namespace-name $NAMESPACE | jq -r .data.items[].id > ${COMPARTMENT_NAME}_loggroup_ref.txt


  if [ ! -s  "${COMPARTMENT_NAME}_loggroup_ref.txt" ]
  then
     echo "log-group list is empty for the $COMPARTMENT_NAME"
	 rm -rf ${COMPARTMENT_NAME}_loggroup_ref.txt
  else
	#### need ETAG to move on otherwise the delete doesnt work !
	###

	while IFS= read -r line; do 
		echo "delete log-group => $line"
		export ETAG=`oci log-analytics log-group get \
		--profile DBSEC \
		--namespace-name $NAMESPACE \
		--log-group-id $line | jq -r .etag` 

		oci log-analytics log-group delete \
		--profile DBSEC \
		--namespace-name $NAMESPACE       \
		--log-group-id $line --if-match $ETAG \
		--force 
	done < ${COMPARTMENT_NAME}_loggroup_ref.txt
	DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
	echo "$DATE: LogGroup list deteted=>$LOGGROUPID" >>   cleanup.txt

  fi	
		


### offboard analytics
# oci log-analytics namespace offboard \
#--namespace-name $NAMESPACE

rm -rf entity_ids.txt
