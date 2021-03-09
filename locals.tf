locals {

  oci_general = {
    compartment_ocid    = var.compartment_ocid
    root_compartment_id = var.tenancy_ocid
  }

  oci_provider = {
    fingerprint      = var.fingerprint
    private_key_path = var.private_key_path
    region           = var.region
    tenancy_id       = var.tenancy_ocid
    user_id          = var.user_ocid
    compartment_ocid = var.compartment_ocid
  }

  ##  dbcs_subnet_id = var.is_dbcs_public == "true" ? module.network.pubreg : module.network.privreg

}  