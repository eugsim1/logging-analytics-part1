#### general variables 
variable "oci_provider" {
  type = object({
    fingerprint      = string
    private_key_path = string
    region           = string
    tenancy_id       = string
    user_id          = string
    compartment_ocid = string
  })
  description = "oci settings"
  default = {
    fingerprint      = ""
    private_key_path = ""
    region           = ""
    tenancy_id       = ""
    user_id          = ""
    compartment_ocid = ""
  }
}




variable "ad" { default = "" }

variable "managed_agent_id" { default = "" }

variable "agent" {
  type = object({
    oci_identity_compartment_AGENT_compartment_compartment_id = string
    oci_identity_compartment_AGENT_compartment_description    = string
    oci_identity_compartment_AGENT_compartment_name           = string
    oci_identity_policy_AGENT_ADMINS_policy_name              = string
    oci_identity_policy_AGENT_ADMINS_description              = string

    oci_identity_dynamic_group_AGENT_dynamic_group_description = string
    oci_identity_dynamic_group_AGENT_dynamic_name              = string

    oci_identity_policy_dyn_loggingAnalytics_policy_name        = string
    oci_identity_policy_dyn_loggingAnalytics_policy_description = string

    oci_management_agent_management_agent_install_key_AGENT_management_agent_install_key_allowed_key_install_count = string
    oci_management_agent_management_agent_install_key_AGENT_management_display_name                                = string
    oci_management_agent_management_agent_install_key_AGENT_management_time_expires                                = string

  })
}