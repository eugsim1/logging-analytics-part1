## https://docs.oracle.com/en-us/iaas/management-agents/doc/perform-prerequisites-deploying-management-agents.html#GUID-EFD288F4-55C4-4DEF-900D-0DEAA24360A2
###


locals {
  begin_dyn_rule_AGENT = "Any {resource.type='management-agents',resource.compartment.id = '"
  end_dyn_rule_AGENT   = "'}"
}

### Step1 create Agent Group
resource "oci_identity_compartment" "AGENT_compartment" {
  #Required
  compartment_id = var.agent.oci_identity_compartment_AGENT_compartment_compartment_id ##"ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya"
  description    = var.agent.oci_identity_compartment_AGENT_compartment_description    #"AGENT Analytics compartment"
  name           = var.agent.oci_identity_compartment_AGENT_compartment_name           #"AGENT_LoggingAnalytics" 
  enable_delete  = true

  #Optional
  defined_tags = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = {
    "Project"     = "log_analytics"
    "Role"        = "log_analytics for HOL "
    "Comment"     = "log_analytics setup for HOL "
    "Version"     = "0.0.0.0"
    "Responsible" = "Eugene Simos"
  }
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

##Step 2: Create a user group
resource "oci_identity_group" "AGENT_ADMINS_identity_group" {
  depends_on     = [oci_identity_compartment.AGENT_compartment]
  name           = "AGENT_ADMINS"
  description    = "log analytics group"
  compartment_id = var.oci_provider.tenancy_id

  #Optional
  defined_tags = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = {
    "Project"     = "log_analytics"
    "Role"        = "log_analytics for HOL "
    "Comment"     = "log_analytics setup for HOL "
    "Version"     = "0.0.0.0"
    "Responsible" = "Eugene Simos"
  }
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }

}

### create policies
###					 
resource "oci_identity_policy" "AGENT_ADMINS_policy" {
  depends_on     = [oci_identity_group.AGENT_ADMINS_identity_group]
  name           = var.agent.oci_identity_policy_AGENT_ADMINS_policy_name #"AGENT_ADMINS_policy"
  description    = var.agent.oci_identity_policy_AGENT_ADMINS_description #"AGENT_ADMINS policy"
  compartment_id = var.oci_provider.tenancy_id
  #Optional
  defined_tags = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = {
    "Project"     = "log_analytics"
    "Role"        = "log_analytics for HOL "
    "Comment"     = "log_analytics setup for HOL "
    "Version"     = "0.0.0.0"
    "Responsible" = "Eugene Simos"
  }
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }

  statements = [
    "ALLOW GROUP AGENT_ADMINS TO MANAGE management-agents IN  TENANCY",
    "ALLOW GROUP AGENT_ADMINS TO MANAGE management-agent-install-keys IN  TENANCY",
    "ALLOW GROUP AGENT_ADMINS TO READ METRICS IN TENANCY",
    "ALLOW GROUP AGENT_ADMINS TO READ USERS IN TENANCY",
  ]
}



resource "oci_identity_dynamic_group" "AGENT_dynamic_group" {
  depends_on = [oci_identity_compartment.AGENT_compartment]
  #Required
  compartment_id = var.oci_provider.tenancy_id
  description    = var.agent.oci_identity_dynamic_group_AGENT_dynamic_group_description                                                  #"dynamic group for loggin analytics"                                                                                  #var.dynamic_group_description
  matching_rule  = format("%s%s%s", local.begin_dyn_rule_AGENT, oci_identity_compartment.AGENT_compartment.id, local.end_dyn_rule_AGENT) #var.dynamic_group_matching_rule
  name           = var.agent.oci_identity_dynamic_group_AGENT_dynamic_name                                                               #"ManagementAgentAdmins"                                                                                               #var.dynamic_group_name

  #Optional
  defined_tags = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = {
    "Project"     = "log_analytics"
    "Role"        = "log_analytics for HOL "
    "Comment"     = "log_analytics setup for HOL "
    "Version"     = "0.0.0.0"
    "Responsible" = "Eugene Simos"
  }
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

resource "oci_identity_policy" "dyn_loggingAnalytics_policy" {
  depends_on     = [oci_identity_compartment.AGENT_compartment, oci_identity_dynamic_group.AGENT_dynamic_group]
  name           = var.agent.oci_identity_policy_dyn_loggingAnalytics_policy_name        ##"AGENT_dynamic_group_policy"
  description    = var.agent.oci_identity_policy_dyn_loggingAnalytics_policy_description ##"AGENT_dynamic_group  policy"
  compartment_id = var.oci_provider.tenancy_id                                           ##oci_identity_compartment.AGENT_compartment.id
  #Optional
  defined_tags = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = {
    "Project"     = "log_analytics"
    "Role"        = "log_analytics for HOL "
    "Comment"     = "log_analytics setup for HOL "
    "Version"     = "0.0.0.0"
    "Responsible" = "Eugene Simos"
  }
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
  ### doesnt work "ALLOW DYNAMIC-GROUP ManagementAgentAdmins TO USE tag-namespaces in compartment Workshops:AGENT_LoggingAnalytics"
  statements = [
    "allow dynamic-group ManagementAgentAdmins to MANAGE management-agents IN tenancy",
    "allow dynamic-group ManagementAgentAdmins to USE METRICS IN tenancy",
    "allow dynamic-group ManagementAgentAdmins to {LOG_ANALYTICS_LOG_GROUP_UPLOAD_LOGS} in tenancy",
    "allow dynamic-group ManagementAgentAdmins to USE loganalytics-collection-warning in tenancy",
    "ALLOW DYNAMIC-GROUP ManagementAgentAdmins TO USE tag-namespaces in tenancy"
  ]
  #    "ALLOW DYNAMIC-GROUP ManagementAgentAdmins TO MANAGE management-agents IN COMPARTMENT  Workshops:AGENT_LoggingAnalytics",
  #    "ALLOW DYNAMIC-GROUP ManagementAgentAdmins TO USE METRICS IN COMPARTMENT Workshops:AGENT_LoggingAnalytics",

}



resource "oci_management_agent_management_agent_install_key" "AGENT_management_agent_install_key" {
  depends_on     = [oci_identity_compartment.AGENT_compartment]
  compartment_id = oci_identity_compartment.AGENT_compartment.id

  #Optional
  allowed_key_install_count = var.agent.oci_management_agent_management_agent_install_key_AGENT_management_agent_install_key_allowed_key_install_count ##"200"
  display_name              = var.agent.oci_management_agent_management_agent_install_key_AGENT_management_display_name                                ##"AGENT_Linux"
  time_expires              = var.agent.oci_management_agent_management_agent_install_key_AGENT_management_time_expires                                ##"2021-06-06T23:59:59.398Z"
}


data "oci_management_agent_management_agent_install_key" "AGENT__management_agent_install_key" {
  #Required
  management_agent_install_key_id = oci_management_agent_management_agent_install_key.AGENT_management_agent_install_key.id
}




resource "local_file" "AGENT_key" {
  depends_on = [data.oci_management_agent_management_agent_install_key.AGENT__management_agent_install_key]

  file_permission = "0700"
  filename        = "config/agent_config.sh"
  content         = <<EOT
#!/bin/bash
JAVA_VER=$(java -version 2>&1 >/dev/null | egrep "\S+\s+version" | awk '{print $3}' | tr -d '"')
echo "Java Version=>$JAVA_VER"
export hostname_ip=`curl ifconfig.co`

install_agent() {  
sudo su<<EOA
cd /tmp
### jdk install

if [ -z $JAVA_VER ]
then
	wget -c --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u281-b09/89d678f2be164786b292527658ca1605/jdk-8u281-linux-x64.tar.gz
	mkdir -p /usr/lib/jvm
	cd /usr/lib/jvm
	tar -xvzf /tmp/jdk-8u281-linux-x64.tar.gz
	update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_281/bin/java" 0
	update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_281/bin/javac" 0
	update-alternatives --set java /usr/lib/jvm/jdk1.8.0_281/bin/java
	update-alternatives --set javac /usr/lib/jvm/jdk1.8.0_281/bin/javac
	java -version
else
	echo "found java version $JAVA_VER"
fi

wget https://objectstorage.us-ashburn-1.oraclecloud.com/n/idtskf8cjzhp/b/installer/o/Linux-x86_64/latest/oracle.mgmt_agent.rpm
### install
rpm -Uvh oracle.mgmt_agent.rpm  
EOA
cd /tmp
cat<<EOF>/tmp/input.rsp  
managementAgentInstallKey = ${data.oci_management_agent_management_agent_install_key.AGENT__management_agent_install_key.key}
FreeFormTags = [{"Responsible":"Eugene Simos"}, {"Project":"log_analytics"}]
DefinedTags = [{"Oracle-Tags":{"ResourceAllocation":"Logging-Analytics"}}]
CredentialWalletPassword = WElcome142312#
Service.plugin.logan.download=true
Service.plugin.dbaas.download=true
AgentDisplayName =$hostname_ip
EOF
chmod -R ugo+rw /tmp/input.rsp 
sudo /opt/oracle/mgmt_agent/agent_inst/bin/setup.sh opts=/tmp/input.rsp
sudo cat /opt/oracle/mgmt_agent/agent_inst/log/mgmt_agent.log > /tmp/mgmt_agent.log

### add the mgmt_agent to oinstall 
sudo usermod -a -G  oinstall mgmt_agent
### add credential file
cat <<EOF>agent_dbcreds.json
{
    "source": "lacollector.la_database_sql",
    "name": "LCAgentDBCreds.$hostname_ip",
    "type": "DBCreds",
    "usage": "LOGANALYTICS",
    "disabled": "false",
    "properties": [
        {
            "name": "DBUserName",
            "value": "CLEAR[C##LOGAN]"
        },
        {
            "name": "DBPassword",
            "value": "CLEAR[oracle]"
        },
    ]
}
EOF
cat agent_dbcreds.json| sudo -u mgmt_agent /opt/oracle/mgmt_agent/agent_inst/bin/credential_mgmt.sh -o upsertCredentials -s logan
sudo chmod -R go+rx /var/log
sudo rm -rf jdk-8u281-linux-x64.tar.gz
sudo rm -rf /tmp/input.rsp
sudo rm -rf Agent
}

remove_agent() {
sudo su<<EOA
rpm -e oracle.mgmt_agent
rm -rf /opt/oracle/mgmt_agent 
EOA
}

run_action()
{
if [[ $1 = "INSTALL" ]]
   then
    echo "install_agent()"
	install_agent 
elif [[ $1 = "REMOVE" ]]
   then 
    echo "remove_agent()"
	remove_agent 
else 
   echo $1 $2
   echo "unkown error should not occur"	
   exit 0
fi
}

run_action $1
   
EOT

}

/*
 
data "oci_objectstorage_namespace" "agent_namespace" {
  compartment_id = var.oci_provider.tenancy_id
}

resource "oci_objectstorage_bucket" "agent_bucket" {
  depends_on     = [local_file.AGENT_key]
  compartment_id = oci_identity_compartment.AGENT_compartment.id
  name           = "Agent_bucket"
  namespace      = data.oci_objectstorage_namespace.agent_namespace.namespace


  access_type = "NoPublicAccess"

  defined_tags = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = {
    "Project"     = "log_analytics"
    "Role"        = "log_analytics for HOL "
    "Comment"     = "log_analytics setup for HOL "
    "Version"     = "0.0.0.0"
    "Responsible" = "Eugene Simos"
  }

  #kms_key_id = oci_kms_key.test_key.id
  #metadata = var.bucket_metadata
  object_events_enabled = "true"
  storage_tier          = "Standard"
  ######--     retention_rules {
  ######--         display_name = var.retention_rule_display_name
  ######--         duration {
  ######--             #Required
  ######--             time_amount = var.retention_rule_duration_time_amount
  ######--             time_unit = var.retention_rule_duration_time_unit
  ######--         }
  ######--         time_rule_locked = var.retention_rule_time_rule_locked
  ######--     }
  versioning = "Disabled"
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }
}

data "local_file" "agent_config" {
  depends_on = [local_file.AGENT_key]
  filename = "config/agent_config.sh"
}

resource "oci_objectstorage_object" "agent_object" {
  depends_on = [oci_objectstorage_bucket.agent_bucket]

  bucket    = oci_objectstorage_bucket.agent_bucket.name
  content   = data.local_file.agent_config.content
  namespace = data.oci_objectstorage_namespace.agent_namespace.namespace
  object    = "Agent"

  #Optional
  ######--     cache_control = var.object_cache_control
  ######--     content_disposition = var.object_content_disposition
  ######--     content_encoding = var.object_content_encoding
  ######--     content_language = var.object_content_language
  ######--     content_type = var.object_content_type
  ######--     delete_all_object_versions = var.object_delete_all_object_versions
  ######--     metadata = var.object_metadata
  storage_tier = "Standard"
}



resource "oci_objectstorage_preauthrequest" "agent_preauthenticated_request" {
  #Required
  access_type  = "ObjectRead"
  bucket       = oci_objectstorage_bucket.agent_bucket.name
  name         = "agent_preauthenticated_request"
  namespace    = data.oci_objectstorage_namespace.agent_namespace.namespace
  time_expires = timeadd(timestamp(), "100000h")


  #Optional
  object = oci_objectstorage_object.agent_object.object
}



resource "local_file" "agent_preauthenticated_request" {
  filename        = "config/agent_preauthenticated_request.txt"
  file_permission = "600"
  content         = format("%s%s%s%s", "https://objectstorage.", var.oci_provider.region, ".oraclecloud.com", oci_objectstorage_preauthrequest.agent_preauthenticated_request.access_uri)
}
*/
