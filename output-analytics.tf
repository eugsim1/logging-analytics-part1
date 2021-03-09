
output "test_logging_namespaces" {
  value = module.log_analytics.test_logging_namespaces
}



/*
output "logging_management_agent_available_histories"   {
value = module.log_analytics.logging_management_agent_available_histories
}
*/

output "logging_log_groups" {
  value = module.log_analytics.logging_log_groups
}