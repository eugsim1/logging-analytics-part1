#### general variables

# Identity and access parameters
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "compartment_ocid" { default = "" }

variable "ad" { default = "" }
variable "ssh_public_key" {}
variable "bastion_shape" {}
variable "use_compute" { default = "" }

variable "instance_count" {}
variable "display_name" {}
variable "need_provisioning" {}
variable "instance_shape" { default = "" }
variable "instance_ocpus" { default = "" }
variable "instance_memory_in_gbs" { default = "" }
variable "ip_adress_backend" { default = "" }
variable "bastion_user" { default = "" }
variable "bastion_ssh_private_key" { default = "" }
variable "bastion_hostname_label" { default = "" }
variable "bastion_timezone" { default = "" }
variable "bastion_upgrade" {}
variable "use_bastion" {}

variable "vnc_display_name" { default = "" }
variable "privreg_display_name" { default = "" }
variable "pubreg_display_name" { default = "" }
variable "vnc_cidr_block" { default = "" }
variable "privreg_cidr_block" { default = "" }
variable "pubsb2_cidr_block" { default = "" }
variable "lb_pub_cidr_block" { default = "" }
variable "pubreg_cidr_block" { default = "" }
variable "pubsb1_cidr_block" { default = "" }

variable "is_dbcs_public" { default = "" }

##variable "managed_agent_id" { default = "" }



variable "oci_identity_group_description" { default = "" }
variable "oci_identity_policy_description" { default = "" }
variable "oci_identity_compartment_log_analytics_compartment_compartment_id" { default = "" }
variable "oci_identity_compartment_log_analytics_description" { default = "" }
variable "oci_identity_compartment_log_name" { default = "" }
#variable "oci_identity_compartment_user_analytics_compartment_count" { default = "" }
variable "oci_identity_compartment_user_analytics_compartment_description" { default = "" }
variable "oci_identity_policy_loggingAnalytics_policy_name" { default = "" }
variable "oci_identity_policy_loggingAnalytics_description" { default = "" }
variable "oci_identity_user_analytics_user_count" { default = "" }
variable "oci_identity_user_analytics_user_description" { default = "" }
variable "oci_identity_user_group_membership_Logging-Analytics-Admins_group_membership_count" { default = "" }
variable "oci_identity_user_group_membership_Logging-Analytics-SuperAdminsgroup_membership_count" { default = "" }
#variable "oci_identity_ui_password_analytics_user_ui_password_count" { default = "" }
#variable "local_file_analytics_user_ui_password_count" { default = "" }



variable "oci_identity_compartment_AGENT_compartment_compartment_id" { default = "" }
variable "oci_identity_compartment_AGENT_compartment_description" { default = "" }
variable "oci_identity_compartment_AGENT_compartment_name" { default = "" }
variable "oci_identity_policy_AGENT_ADMINS_policy_name" { default = "" }
variable "oci_identity_policy_AGENT_ADMINS_description" { default = "" }
variable "oci_identity_dynamic_group_AGENT_dynamic_group_description" { default = "" }
variable "oci_identity_dynamic_group_AGENT_dynamic_name" { default = "" }
variable "oci_identity_policy_dyn_loggingAnalytics_policy_name" { default = "" }
variable "oci_identity_policy_dyn_loggingAnalytics_policy_description" { default = "" }
variable "oci_management_agent_management_agent_install_key_AGENT_management_agent_install_key_allowed_key_install_count" { default = "" }
variable "oci_management_agent_management_agent_install_key_AGENT_management_display_name" { default = "" }
variable "oci_management_agent_management_agent_install_key_AGENT_management_time_expires" { default = "" }



variable "oci_logging_log_category" { default = "" }
#variable "oci_logging_log_resource" { default = "" }
variable "oci_logging_log_service" { default = "" }
variable "oci_logging_log_source_type" { default = "" }
variable "oci_logging_log_display_name" { default = "" }
variable "oci_logging_log_is_enabled" { default = "" }
variable "oci_logging_log_log_type" { default = "" }
variable "oci_logging_log_retention_duration" { default = "" }
variable "log_bucket_name" { default = "" }
variable "oci_sch_service_connector_description" { default = "" }
variable "oci_sch_service_connector_display_name" { default = "" }
variable "oci_sch_service_connector_batch_rollover_size_in_mbs" { default = "" }
variable "oci_sch_service_connector_batch_rollover_time_in_ms" { default = "" }