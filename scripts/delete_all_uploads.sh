####
####  delete all upladed files from LogAn
####
DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE:Start the clean up process" >> cleanup.txt


oci log-analytics upload list \
--profile DBSEC \
--namespace-name $NAMESPACE | jq -r .data.items[].reference > upload_list.txt
 
 	if [[ ! -f  "upload_list.txt" ]]
	then
		 echo "No upload list for the $COMPARTMENT_NAME"
	else
		DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
		echo "$DATE:Upload_ref=>upload_list.txt" > cleanup.txt
		while IFS= read -r line; do 
		oci log-analytics upload delete \
		--profile DBSEC \
		--namespace-name $NAMESPACE \
		--upload-reference $line \
		--force	
		done < upload_list.txt
	fi