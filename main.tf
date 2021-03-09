#### Eugene Simos
####
####
####
####
#### How to use these scripts 
#### create a terraform.tfvars file with the appropriate values
#### The log_analytics creates the infra settings for a LogAn deployment
#### The Agent module create the infra settings for an Agent Deployment and the Agent Generation file into the config directory
#### The directory module/compute_nodes_provisioning contains ansible script to be used when you need to provision several compute nodes with the Agent
#### the other modules are used to generate OCI artifacts to be used them by the logging module ( we can strip them from now and add them later ?)
####
### generate infra for LogAn
### generate a number of local users and compartments
###
####
module "log_analytics" {
  source       = "./modules/analytics"
  oci_provider = local.oci_provider

  logging_analytics = {                                                                                                                       #
    oci_identity_group_description                                    = var.oci_identity_group_description                                    #"log analytics group"
    oci_identity_policy_description                                   = var.oci_identity_policy_description                                   #"log_analytics_policy"
    oci_identity_compartment_log_analytics_compartment_compartment_id = var.oci_identity_compartment_log_analytics_compartment_compartment_id #"ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya"
    oci_identity_compartment_log_analytics_description                = var.oci_identity_compartment_log_analytics_description                #"Main Anamytics compartment"
    oci_identity_compartment_log_name                                 = var.oci_identity_compartment_log_name                                 #"LoggingAnalytics"

    oci_identity_compartment_user_analytics_compartment_description                        = var.oci_identity_compartment_user_analytics_compartment_description                        #"User Analytics compartment"
    oci_identity_policy_loggingAnalytics_policy_name                                       = var.oci_identity_policy_loggingAnalytics_policy_name                                       #"LoggingAnalytics"
    oci_identity_policy_loggingAnalytics_description                                       = var.oci_identity_policy_loggingAnalytics_description                                       #"LoggingAnalytics  policy"
    oci_identity_user_analytics_user_count                                                 = var.oci_identity_user_analytics_user_count                                                 #"10"
    oci_identity_user_analytics_user_description                                           = var.oci_identity_user_analytics_user_description                                           #"HOL analytics user"
    oci_identity_user_group_membership_Logging-Analytics-Admins_group_membership_count     = var.oci_identity_user_group_membership_Logging-Analytics-Admins_group_membership_count     #"10"
    oci_identity_user_group_membership_Logging-Analytics-SuperAdminsgroup_membership_count = var.oci_identity_user_group_membership_Logging-Analytics-SuperAdminsgroup_membership_count #"10"
    ##oci_identity_ui_password_analytics_user_ui_password_count                              = var.oci_identity_ui_password_analytics_user_ui_password_count                              #"10"
    ##local_file_analytics_user_ui_password_count                                            = var.local_file_analytics_user_ui_password_count                                            #"10"
  }

}

### generate infra for the AGENT
### create local file with the Agent configuration to applied to hosts
###
module "agent" {
  source = "./modules/agent"

  oci_provider = local.oci_provider

  agent = {
    oci_identity_compartment_AGENT_compartment_compartment_id                                                      = var.oci_identity_compartment_AGENT_compartment_compartment_id                                                      #"ocid1.compartment.oc1..aaaaaaaakjdnf7ik2kejcaj73uwx6tsochnlq5olj3vebgbwcf67bjnab3ya"
    oci_identity_compartment_AGENT_compartment_description                                                         = var.oci_identity_compartment_AGENT_compartment_description                                                         #"AGENT Analytics compartment"
    oci_identity_compartment_AGENT_compartment_name                                                                = var.oci_identity_compartment_AGENT_compartment_name                                                                #"AGENT_LoggingAnalytics"
    oci_identity_policy_AGENT_ADMINS_policy_name                                                                   = var.oci_identity_policy_AGENT_ADMINS_policy_name                                                                   #"AGENT_ADMINS_policy"
    oci_identity_policy_AGENT_ADMINS_description                                                                   = var.oci_identity_policy_AGENT_ADMINS_description                                                                   #"AGENT_ADMINS policy"
    oci_identity_dynamic_group_AGENT_dynamic_group_description                                                     = var.oci_identity_dynamic_group_AGENT_dynamic_group_description                                                     #"dynamic group for loggin analytics"
    oci_identity_dynamic_group_AGENT_dynamic_name                                                                  = var.oci_identity_dynamic_group_AGENT_dynamic_name                                                                  #"ManagementAgentAdmins"
    oci_identity_policy_dyn_loggingAnalytics_policy_name                                                           = var.oci_identity_policy_dyn_loggingAnalytics_policy_name                                                           #"AGENT_dynamic_group_policy"
    oci_identity_policy_dyn_loggingAnalytics_policy_description                                                    = var.oci_identity_policy_dyn_loggingAnalytics_policy_description                                                    #"AGENT_dynamic_group  policy"
    oci_management_agent_management_agent_install_key_AGENT_management_agent_install_key_allowed_key_install_count = var.oci_management_agent_management_agent_install_key_AGENT_management_agent_install_key_allowed_key_install_count #"200"
    oci_management_agent_management_agent_install_key_AGENT_management_display_name                                = var.oci_management_agent_management_agent_install_key_AGENT_management_display_name                                #"AGENT_Linux"
    oci_management_agent_management_agent_install_key_AGENT_management_time_expires                                = var.oci_management_agent_management_agent_install_key_AGENT_management_time_expires                                #"2021-06-06T23:59:59.398Z"
  }
}


/* not used for this part

module "network" {
  depends_on = [module.log_analytics]
  source     = "git::https://eugsim1:8a4aba63dd455bcea1585c8568ba646d193044ea@github.com/eugsim1/network.git"

  oci_provider = local.oci_provider
  ad           = data.oci_identity_availability_domain.ad1

  network_settings = {
    vnc_display_name     = var.vnc_display_name     #"analytics"
    vnc_cidr_block       = var.vnc_cidr_block       ##"10.1.0.0/16"
    privreg_cidr_block   = var.privreg_cidr_block   ##"10.1.4.0/24"
    pubsb2_cidr_block    = var.pubsb2_cidr_block    ##"10.1.3.0/24"
    lb_pub_cidr_block    = var.lb_pub_cidr_block    ##"10.1.5.0/24"
    privreg_display_name = var.privreg_display_name ## "analyticsprivreg"
    pubreg_display_name  = var.pubreg_display_name  ## "analyticspubreg"
    pubreg_cidr_block    = var.pubreg_cidr_block    ##"10.1.1.0/24"
    pubsb1_cidr_block    = var.pubsb1_cidr_block    ##"10.1.2.0/24"
    compartment_ocid     = local.oci_general.compartment_ocid
  }
}




module "bastion" {
  depends_on = [module.network]
  count      = var.use_bastion == "true" ? 1 : 0
  source     = "git::https://eugsim1:8a4aba63dd455bcea1585c8568ba646d193044ea@github.com/eugsim1/bastion.git"

  oci_provider = local.oci_provider

  bastion = {
    vcn_id          = module.network.pubreg
    bastion_enabled = true
    ssh_public_key  = var.ssh_public_key
    nsg_ids         = [module.network.network_security_group, module.network.dbcs_security_group_backup]
    bastion_shape   = var.bastion_shape
    hostname_label  = var.bastion_hostname_label #"bastion_dbcs"
    label_prefix    = ""
    defined_tags    = { "Oracle-Tags.ResourceAllocation" = "DataSafe-prep" }
    tags = {
      environment = "dev"
      role        = "bastion"
    }
    shape_config = {
      memory_in_gbs = "4"
      ocpus         = "1"
    }
    bastion_upgrade = var.bastion_upgrade  #false
    timezone        = var.bastion_timezone #"Europe/Helsinki"
  }
  ad_names = data.oci_identity_availability_domain.ad1.name
}

### generates infra for the logging
###
module "logging" {
  source       = "./modules/logging"
  oci_provider = local.oci_provider

  logging = {
    compartment_id                     = module.log_analytics.log_analytics_compartment_id
    oci_logging_log_group_display_name = "logging-analytics-demo"
    defined_tags                       = { "Oracle-Tags.ResourceAllocation" = "Logging-Analytics" }
    freeform_tags = {
      "Project"     = "log_analytics"
      "Role"        = "log_analytics for HOL "
      "Comment"     = "log_analytics setup for HOL "
      "Version"     = "0.0.0.0"
      "Responsible" = "Eugene Simos"
    }
    oci_logging_log_category                             = var.oci_logging_log_category #"all"
    oci_logging_log_resource                             = module.network.pubreg
    oci_logging_log_service                              = var.oci_logging_log_service                              #"flowlogs"
    oci_logging_log_source_type                          = var.oci_logging_log_source_type                          #"OCISERVICE"
    oci_logging_log_display_name                         = var.oci_logging_log_display_name                         #"lbpubreg_all"
    oci_logging_log_is_enabled                           = var.oci_logging_log_is_enabled                           #"true"
    oci_logging_log_log_type                             = var.oci_logging_log_log_type                             #"SERVICE"
    oci_logging_log_retention_duration                   = var.oci_logging_log_retention_duration                   #"30"
    log_bucket_name                                      = var.log_bucket_name                                      #"loggin_bucket"
    oci_sch_service_connector_description                = var.oci_sch_service_connector_description                #"vcn connector descritpion"
    oci_sch_service_connector_display_name               = var.oci_sch_service_connector_display_name               #"connectrot display name"
    oci_sch_service_connector_batch_rollover_size_in_mbs = var.oci_sch_service_connector_batch_rollover_size_in_mbs #"15"
    oci_sch_service_connector_batch_rollover_time_in_ms  = var.oci_sch_service_connector_batch_rollover_time_in_ms  #"60000"
  }

}

*/


/*
module "compute" {
  count      = var.use_compute == true ? 1 : 0
  depends_on = [module.network,  module.bastion]
  source     = "./modules/compute"
  # provider identity parameters  
  oci_provider = local.oci_provider

  availability_domain = data.oci_identity_availability_domain.ad1.name

  compute = {
    subnet_id      = module.network.privreg
    ssh_public_key = var.ssh_public_key
    instance_shape = var.instance_shape
    instance_count = var.instance_count
    display_name   = var.display_name
    tags = {
      environment = "dev"
      role        = "web"
    }
    need_provisioning       = true
    hostname_label          = ""
    label_prefix            = ""
    install_node            = true
    install_nginx           = false
    bastion_public_ip       = module.bastion[0].bastion_public_ip
    bastion_user            = "opc"
    bastion_ssh_private_key = file(var.bastion_ssh_private_key)
    shape_config = {
      memory_in_gbs = "4"
      ocpus         = "1"
    }
  }

  instance_ocpus         = var.instance_ocpus
  instance_memory_in_gbs = var.instance_memory_in_gbs
##  opc_key                = module.keysgen.OPCPrivateKey
##  oracle_key             = module.keysgen.OraclePrivateKey
}



module "loadbalancer" {
  count      = var.use_lb == true ? 1 : 0
  depends_on = [ module.compute, module.network]
  source     = "./modules/loadbalancer"

  # provider identity parameters  
  oci_provider        = local.oci_provider
  availability_domain = data.oci_identity_availability_domain.ad1.name


  loadbalancer = {
    display_name              = var.lb_display_name
    compartment_ocid          = local.oci_provider.compartment_ocid
    shape                     = var.lb_shape
    subnet_ids                = [module.network.pubreg]
    private                   = var.is_lb_private
    nsg_ids                   = null
    defined_tags              = null
    freeform_tags             = null
    ip_mode                   = "IPV4"
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }

  ip_adress_backend = module.compute[0].web_ip_private_instance ##module.compute.web_ip_public_instance
  instance_count    = var.instance_count


  lb_name_bakend_set = var.lb_name_bakend_set
  lb_health_port     = var.lb_health_port

  lb_ca_certificate       = var.lb_ca_certificate
  lb_certificate_name     = var.lb_certificate_name
  lb_certificate_priv_key = var.lb_certificate_priv_key
  lb_public_certificate   = var.lb_public_certificate


  lb_httplistener      = var.lb_httplistener
  lbhttplisterner_port = var.lbhttplisterner_port

  lb_httpslistener = var.lb_httpslistener
}



module "dns" {
  count      = var.use_lb == true ? 1 : 0
  depends_on = [module.bastion, module.compute, module.loadbalancer, module.network]
  source     = "./modules/dns"

  # provider identity parameters  
  oci_provider        = local.oci_provider
  dns_rdata           = module.loadbalancer[0].lb_public_ip
  dns_compartment_id  = var.compartment_ocid
  dns_domain          = var.dns_domain
  dns_zone_name_or_id = var.dns_zone_name_or_id

}




module "database" {
  count      = var.use_dbcs == "true" ? 1 : 0
  depends_on = [module.network ]
  source     = "./modules/db_systems"


  oci_provider        = local.oci_provider
  availability_domain = data.oci_identity_availability_domain.ad1

  dbcs = {
    instance_count          = var.dbcs_instance_count
    is_dbcs_public          = var.is_dbcs_public          #true
    create_dbcs_backup      = var.create_dbcs_backup      #true
    create_data_guard       = var.create_data_guard       #
    database_admin_password = var.database_admin_password #"BEstrO0ng_#12"
	database_user_password = var.database_user_password #"BEstrO0ng_#12"
    #Optional
    database_backup_id                  = ""                               # (Required when source=DB_BACKUP) The backup OCID.
    database_backup_tde_password        = var.database_backup_tde_password ##"BEstrO0ng_#12" # Required when source=DATABASE | DB_BACKUP) The password to open the TDE wallet.
    database_character_set              = var.database_character_set       ##"AL32UTF8"
    database_database_id                = ""                               # (Required when source=DATABASE) The database OCID.
    database_database_software_image_id = ""                               # (Applicable when source=NONE) The database software image OCID

    #Optional
    db_backup_config_auto_backup_enabled = var.db_backup_config_auto_backup_enabled ##"false"    # If set to true, configures automatic backups.
    db_backup_config_auto_backup_window  = "SLOT_ONE"                               # Time window selected for initiating automatic backup for the database system
    #Optional
    backup_destination_details_id            = ""                   #  (Applicable when source=DB_SYSTEM | NONE) The OCID of the backup destination.
    backup_destination_details_type          = ""                   # Required when source=DB_SYSTEM | NONE) Type of the database backup destination.
    db_backup_config_recovery_window_in_days = "1"                  # Number of days between the current and the earliest point of recoverability covered by automatic backups.
    database_db_domain                       = ""                   # he database domain. In a distributed database system, DB_DOMAIN specifies the logical location of the database within the network structure.
    database_db_name                         = var.database_db_name ## "mydbcs" # The display name of the database to be created from the backup
    database_db_workload                     = "OLTP"               # (Applicable when source=NONE) The database workload type.
    ####### --     database_defined_tags = {
    ####### --       "Project"     = "omc"
    ####### --       "Role"        = "Bastion for omc"
    ####### --       "Comment"     = "Bastion setup for omc project"
    ####### --       "Version"     = "0.0.0.0"
    ####### --       "Responsible" = "put the name here"
    ####### --     } 	
    database_defined_tags = { "Oracle-Tags.ResourceAllocation" = "DataSafe-prep" }
    # Applicable when source=DB_SYSTEM | NONE) (Updatable) Defined tags for this resource. 

    database_freeform_tags = {
      "Project"     = "omc"
      "Role"        = "Bastion for omc"
      "Comment"     = "Bastion setup for omc project"
      "Version"     = "0.0.0.0"
      "Responsible" = "put the name here"
    }                                                                                 #Applicable when source=DB_SYSTEM | NONE) (Updatable) Free-form tags for this resource. Each tag is a simple key-value pair with no predefined name, type, or namespace
    database_ncharacter_set                        = var.database_ncharacter_set      ##"AL16UTF16"     # (Applicable when source=NONE) The national character set for the database. The default is AL16UTF16.
    database_pdb_name                              = var.database_pdb_name            ##"pdbName"       # (Applicable when source=NONE) The name of the pluggable database. The name must begin with an alphabetic character and can contain a maximum of eight alphanumeric characters.
    database_tde_wallet_password                   = var.database_tde_wallet_password ##"BEstrO0ng_#12" # (Applicable when source=NONE) The optional password to open the TDE wallet. The password must be at least nine characters and contain at least two uppercase, two lowercase, two numeric, and two special characters.
    database_time_stamp_for_point_in_time_recovery = ""                               # Applicable when source=DATABASE) The point in time of the original database from which the new database is created. If not specifed, the latest

    #Optional
    db_home_database_software_image_id = ""                     # (Applicable when source=NONE) The database software image OCID
    db_home_db_version                 = var.db_home_db_version ##"19.9.0.0" # Required when source=NONE) A valid Oracle Database version. To get a list of supported versions, use the ListDbVersions operation.
    db_home_defined_tags = {
      "Oracle-Tags.ResourceAllocation" = "DataSafe-prep"
    }                                   # (Optional) Defined tags for this resource. Each key is predefined and scoped to a namespace
    db_home_display_name = "mydbcshome" # (Optional) The user-provided name of the Database Home.
    freeform_tags = {
      "Project"     = "omc"
      "Role"        = "Bastion for omc"
      "Comment"     = "Bastion setup for omc project"
      "Version"     = "0.0.0.0"
      "Responsible" = "put the name here"
    }                                                # Free-form tags for this resource. Each tag is a simple key-value pair with no predefined name, type, or namespace. 
    database_hostname        = var.database_hostname ##"myoracledb" # Required) The hostname for the DB system. The hostname must begin with an alphabetic character, and can contain alphanumeric characters and hyphens (-). The maximum length of the hostname is 16 
    database_shape           = var.database_shape    ##"VM.Standard2.1"
    database_ssh_public_keys = [file("wls-wdt-testkey-pub.txt"), ]
    database_subnet_id       = var.is_dbcs_public == "true" ? module.network.pubreg : module.network.privreg ##local.dbcs_subnet_id #module.network.privreg
    #Optional
    database_backup_network_nsg_ids  = [""]                                 # (Optional) (Updatable) A list of the OCIDs of the network security groups (NSGs) that the backup network of this DB system belongs to. Setting this to an empty array after the list is created removes the resource from all NSGs. For more
    database_backup_subnet_id        = ""                                   # he OCID of the backup network subnet the DB system is associated with. Applicable only to Exadata DB systems.
    database_cluster_name            = ""                                   # The cluster name for Exadata and 2-node RAC virtual machine DB systems.
    database_cpu_core_count          = var.database_cpu_core_count          #1
    database_data_storage_percentage = var.database_data_storage_percentage ##"80"                 # Not applicable for virtual machine DB systems. 
    database_data_storage_size_in_gb = var.database_data_storage_size_in_gb ##"256"                # Size (in GB) of the initial data volume that will be created and attached to a virtual machine DB system.
    database_database_edition        = var.database_database_edition        ##"ENTERPRISE_EDITION" # (Required when source=DATABASE | DB_BACKUP | NONE) 

    #Optional
    db_system_options_storage_management = var.db_system_options_storage_management ##"LVM"
    db_system_defined_tags = {
      "Oracle-Tags.ResourceAllocation" = "DataSafe-prep"
    }
    database_disk_redundancy = "NORMAL"                                                                                          #(Applicable when source=DATABASE | DB_BACKUP | NONE) The type of redundancy configured for the DB system. Normal is 2-way 
    database_display_name    = "myoracledb"                                                                                      # The user-friendly name for the DB system. The name does not have to be unique.
    database_domain          = var.is_dbcs_public == "true" ? module.network.pubreg_dns_label : module.network.privreg_dns_label # A domain name used for the DB system. If the Oracle-provided Internet and VCN Resolver is enabled for the specified subnet, the domain name for the subnet is used (do not provide one). 
    database_fault_domains   = [data.oci_identity_fault_domains.dbcs_fault_domains.fault_domains[1].name, ]                      # If you do not specify the Fault Domain, the system selects one for you.
    db_system_freeform_tags = {
      "Project"     = "omc"
      "Role"        = "Bastion for omc"
      "Comment"     = "Bastion setup for omc project"
      "Version"     = "0.0.0.0"
      "Responsible" = "put the name here"
    }
    database_kms_key_id         = ""                       # The OCID of the key container that is used as the master encryption key in database transparent data encryption (TDE) operations.
    database_kms_key_version_id = ""                       # The OCID of the key container version that is used in database transparent data encryption (TDE) operations KMS Key can have multiple key versions. If none is specified, the current key version (latest) of the Key Id is used for the operation. 
    database_license_model      = "BRING_YOUR_OWN_LICENSE" # The Oracle license model that applies to all the databases on the DB system. The default is LICENSE_INCLUDED.

    #Optional
    maintenance_window_details_days_of_week_name  = ""    # (Required when source=NONE) (Updatable) Name of the day of the week.
    maintenance_window_details_hours_of_day       = ["0"] # Applicable when source=NONE) (Updatable) The window of hours during the day when maintenance should be performed. The window is a 4 hour slot. Valid values are
    maintenance_window_details_lead_time_in_weeks = "1"   # (Applicable when source=NONE) (Updatable) Lead time window allows user to set a lead time to prepare for a down time. The lead time is in weeks and valid value is between 1 to 4. 

    #Optional
    maintenance_window_details_months_name    = ""    # Applicable when source=NONE) (Updatable) Months during the year when maintenance should be performed
    maintenance_window_details_preference     = ""    # (Required when source=NONE) (Updatable) The maintenance window scheduling preference.
    maintenance_window_details_weeks_of_month = ["1"] # Applicable when source=NONE) (Updatable) Weeks during the month when maintenance should be performed. Weeks start on the 1st, 8th, 15th, and 22nd days of the month, and have a duration of 7 days
    database_node_count                       = 1
    database_nsg_ids                          = [module.network.network_security_group, module.network.dbcs_security_group_backup] # Optional) (Updatable) A list of the OCIDs of the network security groups (NSGs) that this resource belongs to. Setting this to an empty array after the list is created removes the resource from all NSGs
    database_private_ip                       = ""                                                                                 # (Optional) A private IP address of your choice. Must be an available IP address within the subnet's CIDR. If you don't specify a value, Oracle automatically assigns a private IP address from the subnet. 
    database_source                           = var.database_source                                                                ##"NONE"                                                                             # (Optional) The source of the database: Use NONE for creating a new database. Use DB_BACKUP for creating a new database by restoring from a backup. Use DATABASE for creating a new database from an existing database, including archive redo log data. The default is NONE.
    database_source_db_system_id              = ""                                                                                 # (Required when source=DB_SYSTEM) The OCID of the DB system.
    database_sparse_diskgroup                 = var.database_sparse_diskgroup                                                      ##false                                                                              # (Optional) If true, Sparse Diskgroup is configured for Exadata dbsystem. If False, Sparse diskgroup is not configured.
    database_time_zone                        = var.database_time_zone   ##"Europe/Helsinki"                                                                  # (Optional) The time zone to use for the DB system. For details, see DB System Time Zones.
	bastion_ssh_private_key                   = var.bastion_ssh_private_key
   														   
  }

##  opc_key    = module.keysgen.OPCPrivateKey
##  oracle_key = module.keysgen.OraclePrivateKey


}

*/
/*

module "autonomous" {
 
  source                                = "./modules/db_autonomous"
  autonomous_db_admin_password          = var.autonomous_db_admin_password
  autonomous_database_db_version        = var.autonomous_database_db_version
  autonomous_data_warehouse_db_workload = var.autonomous_data_warehouse_db_workload
  autonomous_database_license_model     = var.autonomous_database_license_model
  autonomous_db_name                    = var.autonomous_db_name
  datasafe_status                       = var.datasafe_status


}

*/