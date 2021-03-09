###
###  Provision a series of siblings compartments with LogAn artifacts and LogFiles from the logs directory
###  superseeded by the go sdk logan.go
###
###
#!/bin/bash
export TENANCY_OCID="ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq"
export LOGGING_ANALYTICS_COMPARTMENT_NAME="LoggingAnalytics"
export LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID="ocid1.compartment.oc1..aaaaaaaalatb5qnxqrqh7c3fnuj5q7k4mndh3zw7ctq3hkjdwljl2nlbojga"
export ANALYTICS_USERS_FILE="analytics_users"
export NAMESPACE=`oci os --profile DBSEC ns get | jq -r .data`
DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE:Workshop COMPARTMENTID=>$COMPARTMENTID for the compartment  $COMPARTMENT_NAME" >> provision_steps.log
export NAME="LoggingAnalytics" ### root compartment for the labs
#export COMPARTMENT_NAME=$NAME
#export GROUP_NAME="Logging-Analytics-SuperAdmins"
#export POLICY_NAME="LoggingAnalytics"



start_log()
{
DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE:Workshop provision started" > provision_steps.log
}

end_log()
{
DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE:Workshop provision ended" >> provision_steps.log
}


display_log()
{
cat provision_steps.log
}

check_variables()
{
if [ -z $LOGGING_ANALYTICS_COMPARTMENT_NAME ]
  then
   echo "LOGGING_ANALYTICS_COMPARTMENT_NAME not set exit"
  exit 1
fi

if [ -z $LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID ]
  then
   echo "LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID not set exit"
  exit 1
fi

if [[ ! -f "$ANALYTICS_USERS_FILE" ]];
 then
   echo "analytic users file doenst exit exit"
 exit 1
fi

}

create-defined_tags()
{
cat<<EOF>defined_tags.json
{
	"Oracle-Tags": {
		"ResourceAllocation": "Logging-Analytics"
	}
}
EOF
}

create_loggroups()
{
  log_group_name=$1
  LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID=$2

  echo "compartmentId  $LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID for  setup_log group => $log_group_name"

  echo "Checking to see if log group $log_group_name already exists"
  export LOGGROUPID=`oci log-analytics log-group list \
	--profile DBSEC \
	--compartment-id $LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID   \
	--display-name $LOGGROUP_NAME   \
	--namespace-name $NAMESPACE | jq -r .data.items[].id`


  if [ -z $LOGGROUPID ]
  then
    echo "log group $log_group_name Does not exist yet, create log group"
    LOGGROUPID=`oci log-analytics log-group create \
                    --compartment-id $LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID   \
					--profile DBSEC \
                    --display-name "$log_group_name"   \
					--defined-tags file://defined_tags.json \
                    --namespace-name $NAMESPACE       \
                    --description "Store all logs uploaded for the Logging Analytics demo setup" | jq .data.id | sed s'/"//g'`
  else
    echo "log group $log_group_name Already exists"
  fi

  if [ -z $LOGGROUPID ]
  then
     echo "  Failed to get $log_group_name OCID - exiting"
     exit 1
  else
     echo "Log Group $log_group_name OCID=$LOGGROUPID" |tee -a setup.properties
  fi
}


create_entity()
{
  entity_name=$1
  entity_type=$2
  WorkshopUser_COMPARTMENTID=$3

    ENTITYID=`oci log-analytics entity list    \
        --namespace-name $NAMESPACE     \
		--profile DBSEC \
        --compartment-id $WorkshopUser_COMPARTMENTID   \
		--name $entity_name \
		--lifecycle-state ACTIVE \
        --all   | jq -r '.data.items[] | .id'`

  if [ ! -z $ENTITYID ]
    then
      echo "Entity $entity_name already exists with ocid $ENTITYID"
	  echo $ENTITYID > get_entity_ocid.txt
      return 0
  else
     echo "Entity $entity_name doenst exists it will be created"
  fi
  
  echo "create entity $entity of type $entity_type $WorkshopUser_COMPARTMENTID  $entity"
  
  ENTITYID=`oci log-analytics entity create \
	--profile DBSEC \
	--compartment-id $LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID \
	--entity-type-name  $entity_type \
	--name   $entity_name \
	--namespace-name $NAMESPACE \
	--defined-tags file://defined_tags.json | jq -r ' .data.id'`
 
 

  if [ -z "$ENTITYID" ]
  then
    echo "  Unable to create entity $entity_name"
    exit 1
  else
       echo "  Created Entity $entity_name $ENTITYID"
	   echo $ENTITYID > get_entity_ocid.txt
  fi
}

get_entity()
{
  entity=$1
  type=$2
  WorkshopUser_COMPARTMENTID=$3

  cmd=`oci log-analytics entity list    \
        --namespace-name $NAMESPACE     \
		--profile DBSEC \
        --compartment-id $WorkshopUser_COMPARTMENTID   \
		--name $entity \
        --all   | jq -r '.data.items[] | .id'`

  ENTITYID=$(eval "$cmd")
}

upload_pattern()
{
  pattern=$1
  log_source=$2
  id=$3
  UPLOAD_NAME=$4
  for file in $pattern
  do
    upload "$log_source" "$file" "$id" $UPLOAD_NAME
  done
}


upload()
{
  logsource="$1"
  file=$2
  entity_id=$3
  UPLOAD_NAME=$4

  filename=`basename $file`
  echo $filename

  entity_string=""
  if [ ! -z "$entity_id" ]
    then
    entity_string="--entity-id $entity_id"
  fi

  cmd="oci log-analytics upload upload-log-file  \
  		--profile DBSEC \
        --namespace-name $NAMESPACE              \
		--file $(echo \"$file\") \
		--filename $(echo \"$filename\")         \
        --log-source-name $(echo \"$logsource\") \
        --upload-name $UPLOAD_NAME               \
        --opc-meta-loggrpid $LOGGROUPID          \
         $entity_string"

  echo "  Uploading $filename in logsource $logsource with upload name $UPLOAD_NAME with loggrpid $LOGGROUPID with entity $entity_string"
  echo $cmd > debug.txt
  eval "$cmd > /dev/null"
}


upload_files()
{
  WorkshopUser_COMPARTMENTID=$1
  WorkshopUser=$2
  UPLOAD_NAME=$3

  echo "Uploading Logs for user $WorkshopUser"
  echo "create entity db1-$WorkshopUser omc_oracle_db_instance $WorkshopUser_COMPARTMENTID"
  create_entity db1-$WorkshopUser omc_oracle_db_instance $WorkshopUser_COMPARTMENTID
  export ENTITYID=`cat get_entity_ocid.txt`
  echo "uploading logs/db with entity $ENTITYID"
  upload_pattern 'logs/db/*.log' 'Database Alert Logs' $ENTITYID  $UPLOAD_NAME
  echo

  echo "create entity dbhost1.oracle.com-$WorkshopUser omc_host_linux $WorkshopUser_COMPARTMENTID"
  create_entity dbhost1.oracle.com-$WorkshopUser omc_host_linux $WorkshopUser_COMPARTMENTID
  export ENTITYID=`cat get_entity_ocid.txt`
  echo "uploading logs/syslog/* with entity $ENTITYID"
  upload_pattern 'logs/syslog/*.log' 'Linux Syslog Logs' $ENTITYID  $UPLOAD_NAME
  echo

  create_entity bigip-ltm-dmz1.oracle.com-$WorkshopUser omc_host_linux $WorkshopUser_COMPARTMENTID
  echo "uploading logs/F5/ with entity $ENTITYID"
  export ENTITYID=`cat get_entity_ocid.txt`
  upload_pattern 'logs/F5/*.log' 'F5 Big IP Logs' $ENTITYID  $UPLOAD_NAME
  echo

########---  create_entity cisco-asa1.oracle.com-$WorkshopUser omc_host_linux $WorkshopUser_COMPARTMENTID
########---  export ENTITYID=`cat get_entity_ocid.txt`
########---  upload_pattern 'logs/cisco-asa/*.log' 'Cisco ASA Logs' $ENTITYID 'ciscologs'

  create_entity srx-test.oracle.com-$WorkshopUser omc_host_linux $WorkshopUser_COMPARTMENTID
  echo "uploading logs/juniper/ with entity $ENTITYID"
  export ENTITYID=`cat get_entity_ocid.txt`
  upload_pattern 'logs/juniper/*.log' 'Juniper SRX Syslog Logs' $ENTITYID  $UPLOAD_NAME
  echo

  create_entity apigw1.oracle.com-$WorkshopUser oci_api_gateway $WorkshopUser_COMPARTMENTID
  export ENTITYID=`cat get_entity_ocid.txt`
  echo "uploading logs/oci-api-gw/*access with entity $ENTITYID"
   upload_pattern 'logs/oci-api-gw/*access.zip' 'OCI API Gateway Access Logs'     $ENTITYID  $UPLOAD_NAME
  echo "uploading logs/oci-api-gw/*exec with entity $ENTITYID"
   upload_pattern 'logs/oci-api-gw/*exec.zip'   'OCI API Gateway Execution Logs'  $ENTITYID  $UPLOAD_NAME
   
  create_entity vcn-flow.oracle.com-$WorkshopUser oci_vcn $WorkshopUser_COMPARTMENTID  
  export ENTITYID=`cat get_entity_ocid.txt`
  echo "uploading logs/oci-vcn-flow/ with entity $ENTITYID"
  upload_pattern 'logs/oci-vcn-flow/*.zip' 'OCI VCN Flow Logs' ''  $UPLOAD_NAME
  echo

########---  echo "uploading logs/audit_oci with entity $ENTITYID"
########---  upload_pattern 'logs/audit_oci/*.log' 'OCI Audit Logs' '' 'OCI_Audit_LogAn_Logs'
########---  echo
  
########---  echo "uploading logs/cloudguard with entity $ENTITYID"
########---  upload_pattern 'logs/cloudguard/*.log' 'OCI CloudGuard Logs' '' 'OCI_ CloudGuard_Logs'
########---  echo 
}




### for each compartement take comp ocid create upload as logginganalytics-comp_name
upload_saved_searches()
{
COMPARTMENT_OCID=$1
ROOT_COMPARTEMENT=$2
UPLOAD=$3
./provision_saved_search_template_VCN_flows.sh \
$COMPARTMENT_OCID \
$ROOT_COMPARTEMENT \
$UPLOAD
}

get_compartment_ocid_by_name()
{
rm -rf  COMPARTMENTID.txt

COMPARTMENT_NAME=$1
oci iam compartment list \
--access-level ACCESSIBLE \
--profile DBSEC \
--name $COMPARTMENT_NAME \
--lifecycle-state ACTIVE \
--compartment-id ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq \
--compartment-id-in-subtree true | jq -r .data[].id > COMPARTMENTID.txt

if [  ! -s COMPARTMENTID.txt ]
   then echo " compartment $COMPARTMENT_NAME doest not exist yet lets create it"
   oci iam compartment create \
   --profile DBSEC \
   --compartment-id $LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID \
   --description  "Logging Analytics Test drive compartment for user $COMPARTMENT_NAME"  \
   --name $COMPARTMENT_NAME \
   --defined-tags file://defined_tags.json |  jq -r .data.id > COMPARTMENTID.txt
   cat COMPARTMENTID.txt
   sleep 60
else
   echo "compartment exist" 
fi   
}

create_compartments()
{
while IFS= read -r line; do
  export analytics_user=`echo $line |  awk '{print $1}' | sed 's/\@[A-Za-z.]*//g'`
  echo user provisioned $analytics_user
  
COMPARTMENT_NAME=$analytics_user

export COMP_OCID=`oci iam compartment list \
--access-level ACCESSIBLE \
--profile DBSEC \
--name $COMPARTMENT_NAME \
--lifecycle-state ACTIVE \
--compartment-id ocid1.tenancy.oc1..aaaaaaaanpuxsacx2rn22ycwc7ugp3sqzfvfhvyrrkmd7eanmvqd6bg7innq \
--compartment-id-in-subtree true | jq -r .data[].id`

if [ -z $COMP_OCID ]
then
 echo "compartment $COMPARTMENT_NAME doest not exist yet lets create it"
 echo " "
   COMP_OCID=`oci iam compartment create \
   --profile DBSEC \
   --compartment-id $LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID \
   --description  "Logging Analytics Test drive compartment for user $COMPARTMENT_NAME"  \
   --name $COMPARTMENT_NAME \
   --defined-tags file://defined_tags.json |  jq -r .data.id `
   echo $COMP_OCID
   sleep 60 
else 
 echo "$COMPARTMENT_NAME=>$COMP_OCID "
fi

done < $ANALYTICS_USERS_FILE


########---
########---if [  ! -s COMPARTMENTID.txt ]
########---   then echo " compartment $COMPARTMENT_NAME doest not exist yet lets create it"

########---else
########---   echo "compartment exist" 
########---fi   
}


provision_analytics()
{
while IFS= read -r line; do
  export analytics_user=`echo $line |  awk '{print $1}' | sed 's/\@[A-Za-z.]*//g'`
  export UPLOAD_NAME="$NAME-$analytics_user"
  echo user provisioned $analytics_user
  export LOGGROUP_NAME="LogGroup-$analytics_user"
  get_compartment_ocid_by_name $analytics_user
  create_loggroups $LOGGROUP_NAME `cat  COMPARTMENTID.txt`                                      ##$LOGGING_ANALYTICS_COMPARTMENT_NAME_OCID
  upload_files `cat  COMPARTMENTID.txt`  $analytics_user $UPLOAD_NAME
  upload_saved_searches `cat  COMPARTMENTID.txt` $TENANCY_OCID $UPLOAD_NAME
done < $ANALYTICS_USERS_FILE
}

rm -rf COMPARTMENTID.txt debug.txt compartemnts_name.txt cle*.txt anal*.txt
#start_log
#check_variables
create-defined_tags
create_compartments
provision_analytics
#end_log
#display_log
