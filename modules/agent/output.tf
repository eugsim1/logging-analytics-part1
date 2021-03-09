output "logging_management_agents" {
  value = data.oci_management_agent_management_agents.logging_management_agents
}

output "logging_management_agent_install_keys" {
  value = data.oci_management_agent_management_agent_install_keys.logging_management_agent_install_keys
}

output "logging_management_agent_plugins" {
  value = data.oci_management_agent_management_agent_plugins.logging_management_agent_plugins
}

output "logging_management_agent_images" {
  value = data.oci_management_agent_management_agent_images.logging_management_agent_images
}
