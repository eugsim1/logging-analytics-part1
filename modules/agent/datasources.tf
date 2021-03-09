data "oci_management_agent_management_agents" "logging_management_agents" {
  #Required
  compartment_id = var.oci_provider.compartment_ocid
}



data "oci_management_agent_management_agent_install_keys" "logging_management_agent_install_keys" {
  #Required
  compartment_id = var.oci_provider.compartment_ocid
}


data "oci_management_agent_management_agent_plugins" "logging_management_agent_plugins" {
  #Required
  compartment_id = var.oci_provider.compartment_ocid
}


data "oci_management_agent_management_agent_images" "logging_management_agent_images" {
  #Required
  compartment_id = var.oci_provider.compartment_ocid
}
