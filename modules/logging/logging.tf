### https://blogs.oracle.com/managementcloud/how-to-ingest-oci-vcn-flow-logs-into-oci-logging-analytics
### steps for vnc log ingestion
###

locals {
  begin_dyn_rule_AGENT = "ALLOW any-user TO use loganalytics-log-group IN COMPARTMENT ID"
  end_dyn_rule_AGENT   = "'}"
}


resource "oci_logging_log_group" "vnc_log_group" {
  #Required
  compartment_id = var.logging.compartment_id
  display_name   = var.logging.oci_logging_log_group_display_name ##  "logging-analytics-demo"  

  #Optional
  defined_tags  = var.logging.defined_tags ###{ "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = var.logging.freeform_tags

}


resource "oci_logging_log" "vcn_lbpubreg_all" {
  configuration {
    compartment_id = var.logging.compartment_id #oci_identity_compartment.log_analytics_compartment.id
    source {
      category    = var.logging.oci_logging_log_category    # "all"
      resource    = var.logging.oci_logging_log_resource    #"ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaarq5bmkxsjr5arva26sd3kqokm2iv5axec2cytlrydskbnkwhkbaq"
      service     = var.logging.oci_logging_log_service     #"flowlogs"
      source_type = var.logging.oci_logging_log_source_type # "OCISERVICE"
    }
  }
  defined_tags  = var.logging.defined_tags                 ###{ "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  display_name  = var.logging.oci_logging_log_display_name ### "lbpubreg_all"
  freeform_tags = var.logging.freeform_tags

  is_enabled         = var.logging.oci_logging_log_is_enabled ##"true"
  log_group_id       = oci_logging_log_group.vnc_log_group.id
  log_type           = var.logging.oci_logging_log_log_type           #"SERVICE"
  retention_duration = var.logging.oci_logging_log_retention_duration #"30"
}

resource "oci_objectstorage_bucket" "log_bucket" {
  compartment_id = var.logging.compartment_id
  name           = var.logging.log_bucket_name ###"newName"
  namespace      = data.oci_objectstorage_namespace.log_namespace.namespace
}


resource "oci_sch_service_connector" "log_service_connector" {
  compartment_id = var.logging.compartment_id
  defined_tags   = var.logging.defined_tags
  description    = var.logging.oci_sch_service_connector_description  ##"description2"
  display_name   = var.logging.oci_sch_service_connector_display_name #   "displayName2"

  freeform_tags = var.logging.freeform_tags

  source {
    kind = "logging"

    log_sources {
      compartment_id = var.logging.compartment_id
      log_group_id   = oci_logging_log_group.vnc_log_group.id
      log_id         = oci_logging_log.vcn_lbpubreg_all.id
    }
  }

  target {
    kind                       = "objectStorage"
    bucket                     = oci_objectstorage_bucket.log_bucket.name
    batch_rollover_size_in_mbs = var.logging.oci_sch_service_connector_batch_rollover_size_in_mbs
    batch_rollover_time_in_ms  = var.logging.oci_sch_service_connector_batch_rollover_time_in_ms
  }

  tasks {
    condition = "logContent='20'"
    kind      = "logRule"
  }

  state = "ACTIVE"
}


resource "local_file" "object_rule" {
  depends_on = [data.template_file.object_rule]
  #Required
  content = data.template_file.object_rule.rendered
  ##### --   <<EOT
  ##### --   ${format("analytics%03s",count.index)}
  ##### --   ${oci_identity_ui_password.analytics_user_ui_password[count.index].password}  
  ##### --   EOT
  file_permission = "0700"
  ##filename        = "config/${element(flatten(list(data.oci_core_vnic.test_vnic.*.public_ip_address)), count.index)}/priv.txt"
  filename = "config/object_rule.txt"
}




resource "oci_identity_policy" "dyn_object_rule_bucket_policy" {
  depends_on     = [data.template_file.object_rule]
  name           = "dyn_object_rule_bucket_policy"
  description    = "dyn_object_rule_bucket_policy"
  compartment_id = var.logging.compartment_id ##oci_identity_compartment.AGENT_compartment.id
  #Optional
  defined_tags = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
  freeform_tags = {
    "Project"     = "log_analytics"
    "Role"        = "log_analytics for HOL "
    "Comment"     = "log_analytics setup for HOL "
    "Version"     = "0.0.0.0"
    "Responsible" = "Eugene Simos"
  }
  lifecycle {
    ignore_changes = [
      defined_tags,
      freeform_tags,
    ]
  }

  statements = [data.template_file.object_rule.rendered]
}





##### -- ALLOW any-user TO use loganalytics-log-group IN COMPARTMENT ID target_log_group_compartment_OCID
##### -- WHERE ALL {
##### --     request.principal.type='serviceconnector', 
##### --     target.loganalytics-log-group.id=log_group_OCID, 
##### --     request.principal.compartment.id=serviceconnector_compartment_OCID
##### -- }