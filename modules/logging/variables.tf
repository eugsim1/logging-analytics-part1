# Identity and access parameters

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


variable "logging" {
  type = object({
    compartment_id                                       = string
    oci_logging_log_group_display_name                   = string
    defined_tags                                         = map(any)
    freeform_tags                                        = map(any)
    oci_logging_log_category                             = string
    oci_logging_log_resource                             = string
    oci_logging_log_service                              = string
    oci_logging_log_source_type                          = string
    oci_logging_log_display_name                         = string
    oci_logging_log_is_enabled                           = string
    oci_logging_log_log_type                             = string
    oci_logging_log_retention_duration                   = string
    log_bucket_name                                      = string
    oci_sch_service_connector_description                = string
    oci_sch_service_connector_display_name               = string
    oci_sch_service_connector_batch_rollover_size_in_mbs = string
    oci_sch_service_connector_batch_rollover_time_in_ms  = string
  })
}