rm -rf .terraform .terraform.lock.hcl
terraform fmt -recursive
terraform init

### rotate keys
rm -rf wls-*
#ssh-keygen -b 4096 -t rsa -f wls-wdt-testkey -q -N ""
## replace the keys to my own format
#mv wls-wdt-testkey     wls-wdt-testkey-priv.txt
#mv wls-wdt-testkey.pub wls-wdt-testkey-pub.txt
#cp wls-wdt-testkey-pub.txt wls-wdt-testkey-priv.txt.pub
