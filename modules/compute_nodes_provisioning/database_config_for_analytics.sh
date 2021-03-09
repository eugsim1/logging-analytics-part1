#!/bin/bash

rm -rf database.txt
source /home/oracle/.bash_profile


cat <<EOT>report.sql
set headsep off
set term off
set feed off
set serveroutput off
set echo off
set pagesize 0
set trimspool on
set linesize 300
COLUMN name FORMAT A25
COLUMN value FORMAT A120
COLUMN   value_col_plus_show_param        FORMAT   a50  HEADING VALUE
spool database.txt
show parameter AUDIT_FILE_DEST;
show parameter DIAGNOSTIC_DEST;
select 'sid ' || sys_context('userenv','instance_name') from dual;
select 'service_name ' || name from v\$services;
SELECT name, value FROM v\$diag_info;

EOT

sqlplus / as sysdba<<EOF
@report.sql
EOF
sed 's/string//g' -i database.txt
sed '/Active Problem Count/d' -i database.txt
sed '/Active Incident Count/d' -i database.txt
sed '/Health Monitor/d' -i database.txt
sed '/Diag Enabled/d' -i database.txt
sed '/Default Trace File/d' -i database.txt
sed '/Diag Incident/d' -i database.txt
sed '/Diag Cdump/d' -i database.txt
sed '/Diag Trace/d' -i database.txt
sed '/Diag Alert/d' -i database.txt
sed '/SYS/d' -i database.txt
sed '/XDB/d' -i database.txt
sed '/pdb/d' -i database.txt
sed '/ADR Base/d' -i database.txt
sed 's/ADR Home/adr_home/g' -i database.txt

sed '$d' -i database.txt

export hostname_ip=`curl ifconfig.co`
export sid=`grep sid database.txt | sed 's/sid//g' | sed 's/ //g'`
export AUDIT_FILE_DEST=`grep audit_file_dest database.txt | sed 's/audit_file_dest//g' | sed 's/ //g'`
export DIAGNOSTIC_DEST=`grep diagnostic_dest database.txt | sed 's/diagnostic_dest//g' | sed 's/ //g'`
export adr_home=`grep adr_home database.txt | sed 's/adr_home//g' | sed 's/ //g'`
export ORACLE_HOME=`grep ORACLE_HOME database.txt | sed 's/ORACLE_HOME//g' | sed 's/ //g'`
export service_name=`grep service_name database.txt | sed 's/service_name//g' | sed 's/ //g'`


sudo su<<EOF
cat /opt/oracle/mgmt_agent/agent_inst/config/security/resource/agent.ocid | sed 's/agent=//g'> agent.txt
chown oracle:oinstall agent.txt
EOF

cat <<EOF>database_entity.json
{
	"agentId": "`cat agent.txt`",
	"compartmentId": "\$ANALYTICS_COMPARTMENT",
	"entityTypeName": "Oracle Database Instance",
	"namespace": "\$ANALYTICS_NAMESPACE",
EOF

cat <<-EOF>>database_entity.json
	"hostname": "$hostname_ip",
	"name": "dbcs_$hostname_ip",
EOF


cat <<-EOF>>database_entity.json
"properties": {
	"AUDIT_FILE_DEST": "$AUDIT_FILE_DEST",
	"DIAGNOSTIC_DEST": "$DIAGNOSTIC_DEST",
	"adr_home": "$adr_home",
	"audit_dest": "$DIAGNOSTIC_DEST/admin/$sid/adump",
	"host_name" : "$hostname_ip",
	"oracle_home": "$ORACLE_HOME",
	"port": "1521",
	"service_name": "$service_name",
	"sid": "$sid"
	}
}
EOF

cat database_entity.json


cat<<-EOF>linux_entity.json
{
  "agentId": "`cat agent.txt`",
  "compartmentId": "\$ANALYTICS_COMPARTMENT",
  "entityTypeName": "omc_host_linux",
  "freeformTags": {
    "Creator": "Eugene Simos",
    "Project": "analytics HOL"
  },
  "hostname": "$hostname_ip",
  "name": "linux_$hostname_ip",
  "namespace": "\$ANALYTICS_NAMESPACE",
  "timezoneRegion": "Europe/Helsinki"
}
EOF

cat linux_entity.json


