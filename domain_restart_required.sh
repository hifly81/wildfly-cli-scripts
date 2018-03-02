#!/bin/bash
#title           :domain_restart_required.sh
#description     :This script will check if the modification of an EAP resource property will require a restart.
#author		 :
#date            :20180402
#version         :0.1
#usage		 :bash domain_restart_required.sh <subsystem> <controller_host> <controller_host_port>
#notes           :jboss cli is required to execute this script and ${JBOSS_HOME}
#==============================================================================

subsystem=$1
resource_sample_name=Example
profile_name=Example
JBOSS_CONTROLLER=$2
JBOSS_CONTR_PORT=$3

CLI_HOME=${JBOSS_HOME}/bin/

if [ $# -ne 3 ]; then
    echo "Usage: ./domain_restart_required.sh datasource|xadatasource|jms-resource-adapter|jms-resource-adapter-connection-definitions|jms-resource-adapter-config-properties|jms-bridge|jms-bridge-connection-factory|property|mail|log-periodic-rotating|log-periodic-size-rotating|log-size-rotating|log jboss_controller jboss_controller_port"
    exit -1
fi

if [ "$1" != "datasource" ] && [ "$1" != "xadatasource" ] && [ "$1" != "jms-resource-adapter" ]  && [ "$1" != "property" ]  && [ "$1" != "mail" ] && [ "$1" != "log-periodic-rotating" ]  && [ "$1" != "log-periodic-size-rotating" ]  && [ "$1" != "log-size-rotating" ] && [ "$1" != "log" ] && [ "$1" != "jms-bridge" ]  && [ "$1" != "jms-bridge-connection-factory" ] && [ "$1" != "jms-resource-adapter-connection-definitions" ] && [ "$1" != "jms-resource-adapter-config-properties" ]
then    
    echo "$1 is not valid"
    exit -1
fi


function print_resource () {
 echo "Trying to find value for property $2 ..." 
 echo "$1" | sed -n "/$2/{:a;N;/}/!ba;s/[[:space:]]//g;s/,/\n/g;s/.*$2:\|}.*//g;p}" | tail -1
}

if [ $subsystem = "datasource" ];
then
  echo "Property to check: (valid are: share-prepared-statements|prepared-statements-cache-size|spy|password|max-pool-size|set-tx-query-timeout|jndi-name|url-delimiter|enabled|connectable|blocking-timeout-wait-millis|statistics-enabled|pool-use-strict-min|validate-on-match|transaction-isolation|jta|valid-connection-checker-class-name|allocation-retry-wait-millis|exception-sorter-properties|background-validation-millis|track-statements|use-fast-fail|flush-strategy|stale-connection-checker-class-name|exception-sorter-class-name|background-validation|check-valid-connection-sql|reauth-plugin-class-name|allow-multiple-users|url-selector-strategy-class-name|user-name|use-ccm|reauth-plugin-properties|driver-name|stale-connection-checker-properties|datasource-class|idle-timeout-minutes|query-timeout|use-java-context|valid-connection-checker-properties|min-pool-size|allocation-retry|security-domain|new-connection-sql|connection-url|use-try-lock|pool-prefill)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT -c "/profile="${profile_name}"/subsystem=datasources/data-source="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "xadatasource" ];
then
    echo "Property to check: (valid are: share-prepared-statements|prepared-statements-cache-size|spy|password|max-pool-size|set-tx-query-timeout|jndi-name|url-delimiter|enabled|blocking-timeout-wait-millis|statistics-enabled|pool-use-strict-min|validate-on-match|transaction-isolation|valid-connection-checker-class-name|allocation-retry-wait-millis|exception-sorter-properties|background-validation-millis|track-statements|use-fast-fail|flush-strategy|stale-connection-checker-class-name|exception-sorter-class-name|background-validation|check-valid-connection-sql|reauth-plugin-class-name|allow-multiple-users|url-selector-strategy-class-name|user-name|use-ccm|reauth-plugin-properties|driver-name|stale-connection-checker-properties|idle-timeout-minutes|query-timeout|use-java-context|valid-connection-checker-properties|min-pool-size|allocation-retry|security-domain|new-connection-sql|use-try-lock|pool-prefill|recovery-password|wrap-xa-resource|same-rm-override|no-recovery|no-tx-separate-pool|recovery-security-domain|interleaving|recovery-plugin-class-name|xa-datasource-class|recovery-plugin-properties|xa-resource-timeout|recovery-username|pad-xid)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT -c "/profile="${profile_name}"/subsystem=datasources/xa-data-source="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "jms-resource-adapter" ];
then
  echo "Property to check: (valid are: class-name|enabled|jndi-name|use-java-context)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT  -c "/profile="${profile_name}"/subsystem=resource-adapters/resource-adapter="${resource_sample_name}"/admin-objects="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "jms-resource-adapter-connection-definitions" ];
then
  echo "Property to check: (valid are: allocation-retry|allocation-retry-wait-millis|background-validation|background-validation-millis|blocking-timeout-wait-millis|capacity-decrementer-class|capacity-decrementer-properties|capacity-incrementer-class|capacity-incrementer-properties|class-name|connectable|enabled|enlistment|enlistment-trace|flush-strategy|idle-timeout-minutes|initial-pool-size|interleaving|jndi-name|max-pool-size|mcp|min-pool-size|no-recovery|no-tx-separate-pool|pad-xid|pool-fair|pool-prefill|pool-use-strict-min|recovery-password|recovery-plugin-class-name|recovery-plugin-properties|recovery-security-domain|recovery-username|same-rm-override|security-application|security-domain|security-domain-and-application|sharable|tracking|use-ccm|use-fast-fail|use-java-context|validate-on-match|wrap-xa-resource|xa-resource-timeout)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT  -c "/profile="${profile_name}"/subsystem=resource-adapters/resource-adapter="${resource_sample_name}"/connection-definitions="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "jms-resource-adapter-config-properties" ];
then
  echo "Property to check: (valid are: attributes)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT  -c "/profile="${profile_name}"/subsystem=resource-adapters/resource-adapter="${resource_sample_name}"/config-properties="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "jms-bridge" ];
then
  echo "Property to check: (valid are: add-messageID-in-header|client-id|failure-retry-interval|max-batch-size|max-batch-time|max-retries|module|paused|quality-of-service|selector|started|subscription-name|source-connection-factory|source-context|source-destination|source-password|source-user|target-connection-factory|target-context|target-destination|target-password|target-user)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT  -c "/profile="${profile_name}"/subsystem=messaging-activemq/jms-bridge="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "jms-bridge-connection-factory" ];
then
  echo "Property to check: (valid are: attributes|block-on-acknowledge|block-on-durable-send|block-on-non-durable-send|cache-large-message-client|call-failover-timeout|call-timeout|client-failure-check-period|client-id|compress-large-messages|confirmation-window-size|connection-load-balancing-policy-class-name|connection-ttl|connectors|consumer-max-rate|consumer-window-size|discovery-group|dups-ok-batch-size|entries|factory-type|failover-on-initial-connection|group-id|ha|max-retry-interval|min-large-message-size|pre-acknowledge|producer-max-rate|producer-window-size|protocol-manager-factory|reconnect-attempts|retry-interval|retry-interval-multiplier|scheduled-thread-pool-max-size|thread-pool-max-size|transaction-batch-size|use-global-pools)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT  -c "/profile="${profile_name}"/subsystem=messaging-activemq/server="${resource_sample_name}"/connection-factory="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi


if [ $subsystem = "property" ];
then
  echo "Property to check: (valid are: attributes)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT  -c "/profile="${profile_name}"/system-property="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "mail" ];
then
  echo "Property to check: (valid are: debug|from|jndi-name)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT -c "/profile="${profile_name}"/subsystem=mail/mail-session="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "log-periodic-rotating" ];
then
  echo "Property to check: (valid are: append|autoflush|enabled|encoding|file|filter|filter-spec|formatter|level|name|named-formatter|suffix)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT -c "/profile="${profile_name}"/subsystem=logging/periodic-rotating-file-handler="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "log-periodic-size-rotating" ];
then
  echo "Property to check: (valid are: append|autoflush|enabled|encoding|file|filter-spec|formatter|level|name|named-formatter|suffix|max-backup-index|rotate-on-boot|rotate-size)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT -c "/profile="${profile_name}"/subsystem=logging/periodic-size-rotating-file-handler="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "log-size-rotating" ];
then
  echo "Property to check: (valid are: append|autoflush|enabled|encoding|file|filter|filter-spec|formatter|level|name|named-formatter|suffix|rotate-on-boot|rotate-size)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT -c "/profile="${profile_name}"/subsystem=logging/size-rotating-file-handler="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi

if [ $subsystem = "log" ];
then
  echo "Property to check: (valid are: filter|filter-spec|handlers|level|use-parent-handlers)"
  read property
  rel=$($CLI_HOME./jboss-cli.sh --connect --controller=$JBOSS_CONTROLLER:$JBOSS_CONTR_PORT -c "/profile="${profile_name}"/subsystem=logging/logger="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $property
fi
