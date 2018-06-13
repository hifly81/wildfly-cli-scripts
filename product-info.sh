#!/bin/bash

CLI_HOME=/usr/local/jboss-eap-7.0/bin/
CLI_CONTROLLER=127.0.01:9999

LAUNCH_TYPE=$($CLI_HOME./jboss-cli.sh --connect --controller=$CLI_CONTROLLER --command='/:read-attribute(name=launch-type)' | grep "result" | cut -c17- | sed 's/\"//g')
PRODUCT_VERSION=$($CLI_HOME./jboss-cli.sh --connect --controller=$CLI_CONTROLLER --command='/:read-attribute(name=product-version)' | grep "result" | cut -c17- | sed 's/\"//g')

echo $LAUNCH_TYPE
echo $PRODUCT_VERSION
