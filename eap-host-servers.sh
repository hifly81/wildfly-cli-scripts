#!/bin/bash
#title           :eap-host-servers.sh
#description     :This script lists the servers for each host controller
#author		 :
#date            :20180613
#version         :0.1
#usage		 :bash eap-host-servers.sh
#notes           :jboss cli is required to execute this script and ${JBOSS_HOME}
#==============================================================================

CLI_HOME=<cli_home>
CLI_CONTROLLER=<wilfly host and port controller>


HOSTS=$($CLI_HOME./jboss-cli.sh --connect --controller=$CLI_CONTROLLER --command=':read-children-names(child-type=host)' | grep "result" -A 9999 | grep -v "result" | sed 's/[\"\,]//g' | head -n -2)
for host in $HOSTS
do
  SERVERS=$($CLI_HOME./jboss-cli.sh --connect --controller=$CLI_CONTROLLER --command='ls host='${host}'/server-config')
  for server in $SERVERS
  do
    SERVER_GROUP=$($CLI_HOME./jboss-cli.sh --connect --controller=$CLI_CONTROLLER --command='/host='${host}'/server-config='${server}':read-attribute(name=group)' | grep "result" | cut -c17- | sed 's/\"//g')
    SERVER_STATE=$($CLI_HOME./jboss-cli.sh --connect --controller=$CLI_CONTROLLER --command='/host='${host}'/server='${server}':read-attribute(name=server-state)' | grep "result" | cut -c17- | sed 's/\"//g')
    echo $host - $server - $SERVER_GROUP - $SERVER_STATE
  done
done
