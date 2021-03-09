
output "test_logging_namespaces" {
  value = data.oci_log_analytics_namespaces.test_logging_namespaces
}


/*
output "logging_management_agent_available_histories"   {
value = data.oci_management_agent_management_agent_available_histories.logging_management_agent_available_histories
}
*/

output "logging_log_groups" {
  value = data.oci_logging_log_groups.logging_log_groups
}


output "log_analytics_compartment_id" {
  value = oci_identity_compartment.log_analytics_compartment.id
}