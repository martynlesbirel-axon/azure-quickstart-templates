#!/bin/bash

CURRENT_USER=$(whoami)
SETUP_SCRIPTS_LOCATION="/opt/azure_jenkins_config/"
CONFIG_AZURE_SCRIPT="config_azure.sh"
CLEAN_STORAGE_SCRIPT="clear_storage_config.sh"
SOURCE_URI="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/azure-jenkins/setup-scripts/"

#download jenkins-cli and secured jenkins config to create new user
wget -O /opt/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar
chmod +x /opt/jenkins-cli.jar
wget -O /opt/config.xml https://arroycsafestorage.blob.core.windows.net/testsafe/config1.xml

echo $1 > /opt/1.txt
echo $2 > /opt/2.txt

sudo mv /var/lib/jenkins/config.xml /var/lib/jenkins/config.xml.back
sudo cp /opt/config.xml /var/lib/jenkins/config.xml

echo "hpsr=new hudson.security.HudsonPrivateSecurityRealm(false); hpsr.createAccount('$1', '$2')" | sudo java -jar /opt/jenkins-cli.jar -s http://localhost:8080 groovy =

#sudo wget -O /var/lib/jenkins/config.xml https://arroycsafestorage.blob.core.windows.net/testsafe/config.xml

sudo service jenkins restart

if [ ! -d "$SETUP_SCRIPTS_LOCATION" ]; then
  sudo mkdir $SETUP_SCRIPTS_LOCATION
fi

# Download config_azure script
sudo wget -O $SETUP_SCRIPTS_LOCATION$CONFIG_AZURE_SCRIPT $SOURCE_URI$CONFIG_AZURE_SCRIPT
sudo chmod +x $SETUP_SCRIPTS_LOCATION$CONFIG_AZURE_SCRIPT

# Download clear_storage_config script
sudo wget -O $SETUP_SCRIPTS_LOCATION$CLEAN_STORAGE_SCRIPT $SOURCE_URI$CLEAN_STORAGE_SCRIPT
sudo chmod +x $SETUP_SCRIPTS_LOCATION$CLEAN_STORAGE_SCRIPT

#azure-cli
sudo npm install -y -g azure-cli

#install jq
sudo apt-get -y update
sudo apt-get -y install jq

#delete any existing config script
old_config_storage_file="/opt/config_storage.sh"
if [ -f $old_config_storage_file ]
then
  sudo rm -f $old_config_storage_file
fi

exit 0

