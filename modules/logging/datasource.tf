data "oci_objectstorage_namespace" "log_namespace" {

  #Optional
  compartment_id = var.oci_provider.tenancy_id
}


data "template_file" "object_rule" {
  template = file("${path.module}/object_rule.tpl")
  vars = {
    target_log_group_compartment_OCID = var.logging.compartment_id
    bucket_name                       = var.logging.log_bucket_name
    ###serviceconnector_compartment_OCID = var.logging.compartment_id
  }
}
