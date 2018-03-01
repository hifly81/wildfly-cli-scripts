#!/bin/bash

subsystem=$1
resource_sample_name=Example

function print_resource () {
 echo "$1" | sed -n "/$2/{:a;N;/}/!ba;s/[[:space:]]//g;s/,/\n/g;s/.*$2:\|}.*//g;p}" | tail -1
}

if [ $subsystem = "datasource" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=datasources/data-source="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

if [ $subsystem = "xadatasource" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=datasources/xa-data-source="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

if [ $subsystem = "jms" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=resource-adapters/resource-adapter="${resource_sample_name}"/admin-objects="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

if [ $subsystem = "property" ];
then
  rel=$(./jboss-cli.sh -c "/system-property="${resource_sample_name}":read-resource-description")
  print_resource "$rel" attributes
fi

if [ $subsystem = "mail" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=mail/mail-session="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

if [ $subsystem = "log-periodic-rotating" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=logging/periodic-rotating-file-handler="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

if [ $subsystem = "log-periodic-size-rotating" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=logging/periodic-size-rotating-file-handler="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

if [ $subsystem = "log-size-rotating" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=logging/size-rotating-file-handler="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

if [ $subsystem = "log" ];
then
  rel=$(./jboss-cli.sh -c "/subsystem=logging/logger="${resource_sample_name}":read-resource-description")
  print_resource "$rel" $2
fi

