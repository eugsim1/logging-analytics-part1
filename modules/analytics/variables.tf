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


variable "logging_analytics" {
  type = object({
    oci_identity_group_description                                    = string
    oci_identity_policy_description                                   = string
    oci_identity_compartment_log_analytics_compartment_compartment_id = string
    oci_identity_compartment_log_analytics_description                = string
    oci_identity_compartment_log_name                                 = string
    oci_identity_compartment_user_analytics_compartment_description   = string
    oci_identity_policy_loggingAnalytics_policy_name                  = string
    oci_identity_policy_loggingAnalytics_description                  = string
    oci_identity_user_analytics_user_count                            = string
    oci_identity_user_analytics_user_description                      = string

  })
}



