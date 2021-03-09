export ANALYTICS_COMPARTMENT=ocid1.compartment.oc1..aaaaaaaaqhhyjrkidluilxlgk5xer7sox6x7ngcak7hfey3iuvcv45s5oz7a
export ANALYTICS_LOGID=ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7iakfepgantk22dx4fay7fmhwsx6mmshrdthwwdkg5a7hua
export ANALYTICS_NAMESPACE=frnj6sfkc1ep
export LOG_GROUP_COMPRTMENT=ocid1.compartment.oc1..aaaaaaaaqhhyjrkidluilxlgk5xer7sox6x7ngcak7hfey3iuvcv45s5oz7a
export LOG_GROUP_COMPRTMENT_ID=ocid1.loganalyticsloggroup.oc1.eu-frankfurt-1.amaaaaaaufnzx7iakfepgantk22dx4fay7fmhwsx6mmshrdthwwdkg5a7hua
export LOG_GROUP_NAME=analytics001


while IFS= read -r line;
do
 ssh -i console-zdm-ssh-key-2021-03-04.key oracle@$line  'bash -s' < ./database_config_for_analytics.sh
done<servers_ip.txt

rm -rf logan_targets.txt
rm -rf config
mkdir -p config
while IFS= read -r line;
do
 echo "scp -o StrictHostKeyChecking=no -i console-zdm-ssh-key-2021-03-04.key oracle@$line:/home/oracle/database_entity.json config/database_entity-$line.json" >> logan_targets.txt
 echo "scp -o StrictHostKeyChecking=no -i console-zdm-ssh-key-2021-03-04.key oracle@$line:/home/oracle/linux_entity.json config/linux_entity-$line.json" >> logan_targets.txt
done<servers_ip.txt
cat logan_targets.txt


sudo su<<EOF
rm -rf config/*
source logan_targets.txt
chmod ugo+rw config/*
chown oracle:oracle config/*
EOF





rm -rf linux_entities_id.txt
for files in config/linux*
do
  sed "s/\$ANALYTICS_COMPARTMENT/$ANALYTICS_COMPARTMENT/g" -i $files
  sed "s/\$ANALYTICS_NAMESPACE/$ANALYTICS_NAMESPACE/g" -i $files
  oci log-analytics entity create  \
  --profile DBSEC \
  --from-json file://$files | jq ' .data  | "\(."management-agent-id") \(.id) \(.name)"'| sed 's/"//g' >> linux_entities_id.txt
done

rm -rf database_entities_id.txt
for files in config/database*
do
  sed "s/\$ANALYTICS_COMPARTMENT/$ANALYTICS_COMPARTMENT/g" -i $files
  sed "s/\$ANALYTICS_NAMESPACE/$ANALYTICS_NAMESPACE/g" -i $files
  oci log-analytics entity create  \
  --profile DBSEC \
  --from-json file://$files |  jq ' .data  | "\(."management-agent-id") \(.id) \(.name) \(.hostname)"'| sed 's/"//g' >> database_entities_id.txt
done

### create the associations Linux
while IFS= read -r line;
do
 export AGENT_ID=`echo $line |  awk -F ' ' '{print $1}'`
 export ENTITY_ID=`echo $line |  awk -F ' ' '{print $2}'`
 export NAME_ENTITY=`echo $line |  awk -F ' ' '{print $3}'`

 cat entiy_linux_association.json | sed "s/\$ANALYTICS_COMPARTMENT/$ANALYTICS_COMPARTMENT/g" | \
 sed "s/\$ANALYTICS_NAMESPACE/$ANALYTICS_NAMESPACE/g" | \
 sed "s/\$AGENT_ID/$AGENT_ID/g" | \
 sed "s/\$ENTITY_ID/$ENTITY_ID/g" | \
 sed "s/\$LOG_GROUP_COMPRTMENT/$LOG_GROUP_COMPRTMENT/g" | \
 sed "s/\$LOG_GROUP_ID/$ANALYTICS_LOGID/g" | \
 sed "s/\$NAME_ENTITY/$NAME_ENTITY/g" | \
 sed "s/\$LOG_GROUP_NAME/$LOG_GROUP_NAME/g" | sed 's/_ID//g' > config/entity_linux_association-$NAME_ENTITY.json
done<linux_entities_id.txt

for files in config/entity_linux_association*
do
 oci log-analytics assoc upsert-assocs \
--profile DBSEC \
--from-json file://$files
done



### create the associations database

while IFS= read -r line;
do
 export AGENT_ID=`echo $line |  awk -F ' ' '{print $1}'`
 export ENTITY_ID=`echo $line |  awk -F ' ' '{print $2}'`
 export NAME_ENTITY=`echo $line |  awk -F ' ' '{print $3}'`
  export HOSTNAME=`echo $line |  awk -F ' ' '{print $4}'`
 cat dbcs_alert_log.json | sed "s/\$ANALYTICS_COMPARTMENT/$ANALYTICS_COMPARTMENT/g" | \
 sed "s/\$ANALYTICS_NAMESPACE/$ANALYTICS_NAMESPACE/g" | \
 sed "s/\$AGENT_ID/$AGENT_ID/g" | \
 sed "s/\$ENTITY_ID/$ENTITY_ID/g" | \
 sed "s/\$LOG_GROUP_COMPRTMENT/$LOG_GROUP_COMPRTMENT/g" | \
 sed "s/\$LOG_GROUP_ID/$ANALYTICS_LOGID/g" | \
 sed "s/\$HOSTNAME/$HOSTNAME/g" | \
  sed "s/\$NAME_ENTITY/$NAME_ENTITY/g" | \
 sed "s/\$LOG_GROUP_NAME/$LOG_GROUP_NAME/g"  > config/entity_database_alert_log-$NAME_ENTITY.json
done<database_entities_id.txt

for files in config/entity_database_alert_log*
do
 oci log-analytics assoc upsert-assocs \
--profile DBSEC \
--from-json file://$files
done

while IFS= read -r line;
do
 export AGENT_ID=`echo $line |  awk -F ' ' '{print $1}'`
 export ENTITY_ID=`echo $line |  awk -F ' ' '{print $2}'`
 export NAME_ENTITY=`echo $line |  awk -F ' ' '{print $3}'`
  export HOSTNAME=`echo $line |  awk -F ' ' '{print $4}'`
 cat dbcs_auditLogsource_log.json | sed "s/\$ANALYTICS_COMPARTMENT/$ANALYTICS_COMPARTMENT/g" | \
 sed "s/\$ANALYTICS_NAMESPACE/$ANALYTICS_NAMESPACE/g" | \
 sed "s/\$AGENT_ID/$AGENT_ID/g" | \
 sed "s/\$ENTITY_ID/$ENTITY_ID/g" | \
 sed "s/\$LOG_GROUP_COMPRTMENT/$LOG_GROUP_COMPRTMENT/g" | \
 sed "s/\$LOG_GROUP_ID/$ANALYTICS_LOGID/g" | \
 sed "s/\$HOSTNAME/$HOSTNAME/g" | \
  sed "s/\$NAME_ENTITY/$NAME_ENTITY/g" | \
 sed "s/\$LOG_GROUP_NAME/$LOG_GROUP_NAME/g"  > config/entity_database_auditLogsource-$NAME_ENTITY.json
done<database_entities_id.txt

for files in config/entity_database_auditLogsource*
do
 oci log-analytics assoc upsert-assocs \
--profile DBSEC \
--from-json file://$files
done





