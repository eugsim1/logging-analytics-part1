###

###  USE ANSIBLE automation TO DEPLOY Logging Analytics Agents to any host

This directory contains files/scripts used to provision Oci compute nodes - can be also other linux on premices nodes - with the OCI Logging Analytics Agent

For the purpose of the demo, an OCI compartment is configured with a terraform script to provide the Agent Configuration, and generate a local shell script.

The details of the dynamic generation of this script is given to this terraform repo :
  https://github.com/eugsim1/logging-analytics-tf-infra in the module agent.

This shell script is generated from the `resource "local_file" "AGENT_key"` section of the agent.tf script.

The script installs :
1- JDK 1.8 in the target host

2- Downloads the agent rpm

3-Installs the agent with a sudo oracle user

The same script has also the capability to clean remove an installed OCI Logging Analytics Agent

This script is provisioned by Ansible



To run these scripts  we need to install Ansible to a linux host, 

If you need to deploy your Agent to your OCI Compute Nodes/ Databases we probably need also to install the OCI CLI command and execute some scripts to collect your target Linux servers, and provide also the private keys as and extra argument to the ansible configuration file

For a demo purpose a simple OCI CLI example is provided called `provision_agent_servers.sh`

#### this script create the ansible hosts files for the agent provisionings
####
#### collect IP from compute instances
#### get the ocids
`cd  /home/oracle/terraform-excercises/oci-certification/logging-analytics/modules/compute_nodes_provisioning`
`oci compute instance list \`
`--profile DBSEC \`
`--compartment-id ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta |  jq -r '.data[] | .id' > compute_instances_ocids.txt`

### `create a <ansible hosts file>`
### `from the vnics of a compartement`
### `we excpect tha the private key is called wls-wdt-testkey  and it will be on the same directory as the <ansible host file> otherwise the printf should be modified`
`rm -rf ansible_hosts.txt`
`echo "[servers]" > ansible_hosts.txt`
`input="compute_instances_ocids.txt"`
`while IFS= read -r line`
`do`
`echo "comp =>$name compute node ocid=>$line"`
`Public_ip=oci compute instance list-vnics \
--profile DBSEC \
--compartment-id ocid1.compartment.oc1..aaaaaaaaoctz26zocbcicfpxxmxbmmzyxa4kbweepqkeg6akuwqjuehw4bta \
--instance-id  $line |  jq -r '.data[] |"\(."public-ip")" '`
`printf "%s ansible_user=opc ansible_ssh_private_key_file=wls-wdt-testkey\n" $Public_ip >> ansible_hosts.txt`
`done < "$input"` 





The private keys are generated per session demo, as well as the servers, there is no possibility to try this scripts beyond the scope of a targeted demo.

the private keys, the public IP , and any other information here are generated and already deleted no chance to access any server to Oracle OCI layout