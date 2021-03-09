cho "get the log-group list"
export LOGGROUPID=`oci log-analytics log-group list \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--display-name $LOGGROUP_NAME   \
--namespace-name $NAMESPACE | jq -r .data.items[].id`
echo $LOGGROUPID

oci log-analytics log-group get \
--namespace-name $NAMESPACE \
--log-group-id $LOGGROUPID | jq -r '.data | "\(.description)  \(."display-name")  \(.id)" '



echo "get the get-assoc-summary"
oci log-analytics assoc get-assoc-summary \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--namespace-name $NAMESPACE | jq -r '.data | "\(."association-count")" '


echo "get the associated-entities"
oci log-analytics assoc list-associated-entities \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--namespace-name $NAMESPACE


oci log-analytics assoc list-source-assocs  \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--namespace-name $NAMESPACE


oci log-analytics assoc list-entity-source-assocs \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--namespace-name $NAMESPACE
{
  "data": {
    "items": [
      {
        "agent-entity-name": null,
        "agent-id": "ocid1.managementagent.oc1.eu-frankfurt-1.amaaaaaaufnzx7ia6ip2dfzhldtromz7bxzfpxjugfdjnyvl37uvpxswzeoq",
        "entity-id": "ocid1.loganalyticsentity.oc1.eu-frankfurt-1.amaaaaaaufnzx7iagg6om2clebv4jxtfxdy4ismdoglzkplfrnafu62nueua",
        "entity-name": "bastion",
        "entity-type-display-name": null,
        "entity-type-name": "omc_host_linux",
        "failure-message": null,
        "host": null,
        "life-cycle-state": "SUCCEEDED",
        "log-group-compartment": "ocid1.compartment.oc1..aaaaaaaaold7zxbenwlyogbb7gx3my3gwti3au7aqn5sifgjp6b44x6uf7jq",
        "log-group-id": "ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7iasczjx3u5sfvxf4swkmijluqgglgbnzkspcmfzlg423ua",
        "log-group-name": "hostlog",
        "retry-count": null,
        "source-display-name": "Linux Secure Logs",
        "source-name": "LinuxSecureLogSource",
        "source-type-name": "os_file",
        "time-last-attempted": "2021-01-24T11:44:55+00:00"
      },
      {
        "agent-entity-name": null,
        "agent-id": "ocid1.managementagent.oc1.eu-frankfurt-1.amaaaaaaufnzx7ia6ip2dfzhldtromz7bxzfpxjugfdjnyvl37uvpxswzeoq",
        "entity-id": "ocid1.loganalyticsentity.oc1.eu-frankfurt-1.amaaaaaaufnzx7iagg6om2clebv4jxtfxdy4ismdoglzkplfrnafu62nueua",
        "entity-name": "bastion",
        "entity-type-display-name": null,
        "entity-type-name": "omc_host_linux",
        "failure-message": null,
        "host": null,
        "life-cycle-state": "SUCCEEDED",
        "log-group-compartment": "ocid1.compartment.oc1..aaaaaaaaold7zxbenwlyogbb7gx3my3gwti3au7aqn5sifgjp6b44x6uf7jq",
        "log-group-id": "ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7iasczjx3u5sfvxf4swkmijluqgglgbnzkspcmfzlg423ua",
        "log-group-name": "hostlog",
        "retry-count": null,
        "source-display-name": "Linux Syslog Logs",
        "source-name": "LinuxSyslogSource",
        "source-type-name": "os_file",
        "time-last-attempted": "2021-01-24T11:44:55+00:00"
      }
    ]
  }

cat<<EOF>delete-assocs.json
 [
    {
      "agentId": "ocid1.managementagent.oc1.eu-frankfurt-1.amaaaaaaufnzx7ia6ip2dfzhldtromz7bxzfpxjugfdjnyvl37uvpxswzeoq",
      "entityId": "ocid1.loganalyticsentity.oc1.eu-frankfurt-1.amaaaaaaufnzx7iagg6om2clebv4jxtfxdy4ismdoglzkplfrnafu62nueua",
      "entityTypeName": "omc_host_linux",
      "logGroupId": "ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7iasczjx3u5sfvxf4swkmijluqgglgbnzkspcmfzlg423ua",
      "sourceName": "LinuxSecureLogSource",
      "sourceTypeName": "os_file"
    },
    {
      "agentId": "ocid1.managementagent.oc1.eu-frankfurt-1.amaaaaaaufnzx7ia6ip2dfzhldtromz7bxzfpxjugfdjnyvl37uvpxswzeoq",
      "entityId": "ocid1.loganalyticsentity.oc1.eu-frankfurt-1.amaaaaaaufnzx7iagg6om2clebv4jxtfxdy4ismdoglzkplfrnafu62nueua",
      "entityTypeName": "omc_host_linux",
      "logGroupId": "ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7iasczjx3u5sfvxf4swkmijluqgglgbnzkspcmfzlg423ua",
      "sourceName": "LinuxSecureLogSource",
      "sourceTypeName": "os_file"
    }
  ]

EOF

oci log-analytics assoc delete-assocs  \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--namespace-name $NAMESPACE --items file://delete-assocs.json








LOGGROUPID=ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7ialp5q75zmglscl52dn4xmuyejl6ns4ek7ei2wkruppgdq


DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
rm -rf cleanup.txt
echo "$DATE: LogGroup list=>$LOGGROUPID" >>   cleanup.txt

if [ -z $LOGGROUPID ]
then
echo "log-group list is empty"
else
#### need ETAG to move on otherwise the delete doesnt work !
###
export ETAG=`oci log-analytics log-group get \
--namespace-name $NAMESPACE \
--log-group-id $LOGGROUPID | jq -r .etag`
echo "ETAG=>$ETAG"

oci log-analytics log-group delete \
--namespace-name $NAMESPACE       \
--log-group-id $LOGGROUPID --if-match $ETAG \
--force

DATE=$(date +%d-%m-%Y"-"%H:%M:%S)
echo "$DATE: LogGroup list deteted=>$LOGGROUPID" >>   cleanup.txt
fi


oci work-requests work-request get \
--work-request-id F3717209DBA04FC092797F944EF192D6/DD7F35476071CB6F46A20D3637E26B1E/760F9C61C7E47FF91E726EB952F9A24C

oci log-analytics work-request-error list \
--namespace-name $NAMESPACE \
--work-request-id F3717209DBA04FC092797F944EF192D6/DD7F35476071CB6F46A20D3637E26B1E/760F9C61C7E47FF91E726EB952F9A24C