cat<<EOF>defined-tags.json
{"Oracle-Tags":{"ResourceAllocation":"Logging-Analytics"}}
EOF
oci log-analytics object-collection-rule create \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--profile DBSEC \
--log-group-id $LOGGROUPID \
--namespace-name $NAMESPACE \
--log-source-name "ociVcnFlowUniFmtLogSource" \
--name "myrule" \
--os-bucket-name  "loggin_bucket" \
--collection-type HISTORIC \
--defined-tags  file://defined-tags.json \
--os-namespace $NAMESPACE \
--is-enabled true \
--poll-since "2020-01-01T12:12:12.000Z"

### reply
{
  "data": {
    "char-encoding": null,
    "collection-type": "HISTORIC",
    "compartment-id": "ocid1.compartment.oc1..aaaaaaaaold7zxbenwlyogbb7gx3my3gwti3au7aqn5sifgjp6b44x6uf7jq",
    "defined-tags": {
      "Oracle-Tags": {
        "CreatedBy": "oracleidentitycloudservice/eugene.simos@oracle.com",
        "ResourceAllocation": "Logging-Analytics"
      }
    },
    "description": null,
    "entity-id": null,
    "freeform-tags": {},
    "id": "ocid1.loganalyticsobjectcollectionrule.oc1.eu-frankfurt-1.amaaaaaaufnzx7ial6my7dgkghkgf35qymvp5n7nlu6xeyi3qwxmb3gl2bsq",
    "is-enabled": null,
    "lifecycle-details": null,
    "lifecycle-state": "ACTIVE",
    "log-group-id": "ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7iaskd4vyo7oxh3b73vkvjstp2zt4nxu7kcvlmapnrsar4a",
    "log-source-name": "ociVcnFlowUniFmtLogSource",
    "name": "myrule",
    "os-bucket-name": "loggin_bucket",
    "os-namespace": "frnj6sfkc1ep",
    "overrides": null,
    "poll-since": "2020-01-01T12:12:12.000Z",
    "poll-till": "2021-01-25T19:09:34.679Z",
    "time-created": "2021-01-25T19:09:34.679000+00:00",
    "time-updated": "2021-01-25T19:09:34.679000+00:00"
  },
  "etag": "dab502f12f758646a4bc62e697fa180ee216325ff7fc298846335712e2097db2"
}

###

oci log-analytics object-collection-rule list  \
--compartment-id $WorkshopUser_COMPARTMENTID   \
--profile DBSEC \
--namespace-name $NAMESPACE | jq -r '.data.items[] | " \(.name) \(."is-enabled") \(."lifecycle-details")  \(."lifecycle-state")  "'


export ETAG=`oci log-analytics object-collection-rule get \
--profile DBSEC \
--namespace-name $NAMESPACE \
--object-collection-rule-id "ocid1.loganalyticsobjectcollectionrule.oc1.eu-frankfurt-1.amaaaaaaufnzx7ial6my7dgkghkgf35qymvp5n7nlu6xeyi3qwxmb3gl2bsq" \
| jq -r '.etag'`


oci log-analytics object-collection-rule update \
--profile DBSEC \
--namespace-name $NAMESPACE \
--object-collection-rule-id "ocid1.loganalyticsobjectcollectionrule.oc1.eu-frankfurt-1.amaaaaaaufnzx7ial6my7dgkghkgf35qymvp5n7nlu6xeyi3qwxmb3gl2bsq"  \
--is-enabled "true" \
--if-match $ETAG \
--force

oci log-analytics object-collection-rule delete \
--profile DBSEC \
--namespace-name $NAMESPACE \
--object-collection-rule-id "ocid1.loganalyticsobjectcollectionrule.oc1.eu-frankfurt-1.amaaaaaaufnzx7ial6my7dgkghkgf35qymvp5n7nlu6xeyi3qwxmb3gl2bsq"  \
--force
