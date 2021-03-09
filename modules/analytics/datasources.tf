data "oci_identity_identity_providers" "test_identity_providers" {
  #Required
  compartment_id = var.oci_provider.tenancy_id
  protocol       = "SAML2" ##"var.identity_provider_protocol

  /*    
	#Optional
    name = var.identity_provider_name
    state = var.identity_provider_state
*/
}





data "oci_log_analytics_namespaces" "test_logging_namespaces" {
  compartment_id = var.oci_provider.tenancy_id
}



data "oci_logging_log_groups" "logging_log_groups" {
  #Required
  compartment_id = var.oci_provider.compartment_ocid

  /*  #Optional
  display_name                 = "exampleLogGroup"
  is_compartment_id_in_subtree = "false"
*/
}


######-- /*
######-- data "oci_management_agent_management_agent_available_histories" "logging_management_agent_available_histories" {
######--   #Required
######--   management_agent_id = var.managed_agent_id
######-- 
######--   #Optional
######--   time_availability_status_ended_greater_than      = "2020-01-15T01:01:01.000Z"
######--   time_availability_status_started_less_than       = "2020-09-28T01:01:01.000Z"
######-- }
######-- */