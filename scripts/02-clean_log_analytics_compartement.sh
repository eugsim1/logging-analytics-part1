###
###  this script clean up the log analytics artifacts from a compartment
###
#!/bin/bash

export NAME="LoggingAnalytics"
export GROUP_NAME="Logging-Analytics-SuperAdmins"
export POLICY_NAME="LoggingAnalytics"
export UPLOAD_NAME=$NAME
export COMPARTMENT_NAME=$1
export DRY_RUN=$2


if [  -z $DRY_RUN ] #variable is unset
	then 
	  echo "this is a delete operation all logan resources will be deleted"
	else
	  echo "this is a report operation"
fi  

if [ -z $COMPARTMENT_NAME ]
	then
	echo "Add your compartment to the setup.sh script as ./setup.sh analytics00X"
	exit 0
fi



echo "get the compartment id for the compartment  $COMPARTMENT_NAME"
oci iam compartment list \
--access-level ACCESSIBLE \
--profile DBSEC \
--name $COMPARTMENT_NAME \
--lifecycle-state ACTIVE \
--compartment-id ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq \
--compartment-id-in-subtree true | jq -r .data[].id > COMPARTMENTID.txt

while IFS= read -r line; do
	COMPARTMENTID=$line

	DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
	echo "$DATE:Workshop COMPARTMENTID=>$COMPARTMENTID for the compartment  $COMPARTMENT_NAME" 
	echo "$DATE:Workshop COMPARTMENTID=>$COMPARTMENTID for the compartment  $COMPARTMENT_NAME" >> cleanup.txt
	echo "get the entites of the compartment $COMPARTMENT_NAME:$COMPARTMENTID"

	rm -rf entity_ids.txt

	oci log-analytics entity list \
	--profile DBSEC \
	--namespace-name $NAMESPACE \
	--compartment-id $COMPARTMENTID \
	--lifecycle-state ACTIVE \
	| jq  '.data.items[] | "\(."are-logs-collected") \(."entity-type-internal-name") \(."entity-type-name") \(."name")   \(.id)"' | sed 's/"//g' | awk '{print $NF}' > entity_ids.txt


	DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
	echo "$DATE:Below are the loaded entities for $COMPARTMENT_NAME" >> cleanup.txt
	cat entity_ids.txt >> cleanup.txt
	echo "*********************************************************" >> cleanup.txt


	if [ ! -s entity_ids.txt ]
		then
			echo "No entities discovered for the compartment $COMPARTMENT_NAME "
			DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
			echo "$DATE:No entities discovered for the compartment $COMPARTMENT_NAME ">> cleanup.txt
		else
		### delete the entities
			cp entity_ids.txt ${COMPARTMENT_NAME}_entity_ids.rpt
				if [  -z $DRY_RUN ]
					then 
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

	fi
done < COMPARTMENTID.txt

echo "get the log-group list for the $COMPARTMENT_NAME"
oci log-analytics log-group list \
--profile DBSEC \
--compartment-id $COMPARTMENTID   \
--namespace-name $NAMESPACE | jq -r .data.items[].id > ${COMPARTMENT_NAME}_loggroup_ref.txt

DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE: LogGroup list=>${COMPARTMENT_NAME}_loggroup_ref.txt" >>   cleanup.txt



  if [ ! -s  "${COMPARTMENT_NAME}_loggroup_ref.txt" ]
  then
     echo "log-group list is empty for the $COMPARTMENT_NAME"
	 rm -rf ${COMPARTMENT_NAME}_loggroup_ref.txt
  else
	#### need ETAG to move on otherwise the delete doesnt work !
	###
	if [  -z $DRY_RUN ]
	then
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
  fi	
		


### offboard analytics
# oci log-analytics namespace offboard \
#--namespace-name $NAMESPACE

rm -rf entity_ids.txt

DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE: End of cleanup " >>   cleanup.txt

