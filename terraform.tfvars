ad = 1
### bastion
bastion_hostname_label = "bastionanalytics"
bastion_timezone       = "Europe/Helsinki"
bastion_upgrade        = "false"
use_bastion            = "true"
ip_adress_backend      = "10.1.1.10"

### vcn
vnc_display_name     = "analytics"
privreg_display_name = "analyticsprivreg"
pubreg_display_name  = "analyticspubreg"
vnc_cidr_block       = "10.1.0.0/16"
privreg_cidr_block   = "10.1.4.0/24"
pubsb2_cidr_block    = "10.1.3.0/24"
lb_pub_cidr_block    = "10.1.5.0/24"
pubreg_cidr_block    = "10.1.1.0/24"
pubsb1_cidr_block    = "10.1.2.0/24"

#### compute nodes
use_compute    = false
ssh_public_key = "wls-wdt-testkey-pub.txt"
bastion_shape  = "VM.Standard.E3.Flex"

display_name            = "webserver"
need_provisioning       = false
instance_shape          = "VM.Standard.E3.Flex"
instance_ocpus          = "1"
instance_memory_in_gbs  = "4"
bastion_user            = "opc"
bastion_ssh_private_key = "wls-wdt-testkey-priv.txt"
instance_count          = 1
### dbcs nodes
is_dbcs_public = "true"

##### logging-analytics ###

oci_identity_group_description                                    = "log analytics group"
oci_identity_policy_description                                   = "log_analytics_policy"
oci_identity_compartment_log_analytics_compartment_compartment_id = "ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya"
oci_identity_compartment_log_analytics_description                = "Main Anamytics compartment"
oci_identity_compartment_log_name                                 = "LoggingAnalytics"

oci_identity_compartment_user_analytics_compartment_description = "User Analytics compartment"
oci_identity_policy_loggingAnalytics_policy_name                = "LoggingAnalytics"
oci_identity_policy_loggingAnalytics_description                = "LoggingAnalytics  policy"
oci_identity_user_analytics_user_count                          = "4" ### creates only compartments 
oci_identity_user_analytics_user_description                    = "HOL analytics user"




oci_identity_compartment_AGENT_compartment_compartment_id                                                      = "ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya"
oci_identity_compartment_AGENT_compartment_description                                                         = "AGENT Analytics compartment"
oci_identity_compartment_AGENT_compartment_name                                                                = "AGENT_LoggingAnalytics"
oci_identity_policy_AGENT_ADMINS_policy_name                                                                   = "AGENT_ADMINS_policy"
oci_identity_policy_AGENT_ADMINS_description                                                                   = "AGENT_ADMINS policy"
oci_identity_dynamic_group_AGENT_dynamic_group_description                                                     = "dynamic group for loggin analytics"
oci_identity_dynamic_group_AGENT_dynamic_name                                                                  = "ManagementAgentAdmins"
oci_identity_policy_dyn_loggingAnalytics_policy_name                                                           = "AGENT_dynamic_group_policy"
oci_identity_policy_dyn_loggingAnalytics_policy_description                                                    = "AGENT_dynamic_group  policy"
oci_management_agent_management_agent_install_key_AGENT_management_agent_install_key_allowed_key_install_count = "200"
oci_management_agent_management_agent_install_key_AGENT_management_display_name                                = "AGENT_Linux"
oci_management_agent_management_agent_install_key_AGENT_management_time_expires                                = "2021-06-06T23:59:59.398Z"



oci_logging_log_category                             = "all"
oci_logging_log_service                              = "flowlogs"
oci_logging_log_source_type                          = "OCISERVICE"
oci_logging_log_display_name                         = "lbpubreg_all"
oci_logging_log_is_enabled                           = "true"
oci_logging_log_log_type                             = "SERVICE"
oci_logging_log_retention_duration                   = "30"
log_bucket_name                                      = "loggin_bucket"
oci_sch_service_connector_description                = "vcn connector descritpion"
oci_sch_service_connector_display_name               = "connectrot display name"
oci_sch_service_connector_batch_rollover_size_in_mbs = "15"
oci_sch_service_connector_batch_rollover_time_in_ms  = "60000"