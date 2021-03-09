### provider for region "uk-london-1"
## to be used as provider = "oci.uk"
## this section ONLY if we will use multi-region 

provider "oci" {
  region           = "uk-london-1"
  alias            = "uk"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

### normal oci settings mono region
###
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
  ## compartement_ocid = var.compartement_ocid
}

