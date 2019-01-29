#!/bin/bash
dcos security org service-accounts keypair private-key.pem public-key.pem
dcos security org service-accounts create -p public-key.pem -d 'service account' $1
dcos security secrets create-sa-secret private-key.pem $1 $1/sa
dcos security org users grant $1 dcos:mesos:master:framework:role:$1-role create
dcos security org users grant $1 dcos:mesos:master:task:user:root create
dcos security org users grant $1 dcos:mesos:agent:task:user:root create
dcos security org users grant $1 dcos:mesos:master:reservation:role:$1-role create
dcos security org users grant $1 dcos:mesos:master:reservation:principal:$1 delete
dcos security org users grant $1 dcos:mesos:master:volume:role:$1-role create
dcos security org users grant $1 dcos:mesos:master:volume:principal:$1 delete
dcos security org users grant $1 dcos:secrets:default:/$1/* full
dcos security org users grant $1 dcos:secrets:list:default:/$1 read
dcos security org users grant $1 dcos:adminrouter:ops:ca:rw full
dcos security org users grant $1 dcos:adminrouter:ops:ca:ro full
dcos security org users grant $1 dcos:mesos:master:framework:role:slave_public/$1-role create
dcos security org users grant $1 dcos:mesos:master:framework:role:slave_public/$1-role read
dcos security org users grant $1 dcos:mesos:master:reservation:role:slave_public/$1-role create
dcos security org users grant $1 dcos:mesos:master:volume:role:slave_public/$1-role create
dcos security org users grant $1 dcos:mesos:master:framework:role:slave_public read
dcos security org users grant $1 dcos:mesos:agent:framework:role:slave_public read
