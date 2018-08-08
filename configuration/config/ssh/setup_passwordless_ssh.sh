#!/bin/bash

# Copyright 2015 Insight Data Science
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# must be called from top level

# check input arguments
if [ "$#" -ne 4 ]; then
  echo "Please specify master and worker dnses, both public and private!" && exit 1
fi

CONFIGURATOR_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${CONFIGURATOR_ROOT}/util.sh

MASTER_DNS=$1
WORKER_DNSES=$2
MASTER_PRIVATE_HOSTNAME=$3
WORKERS_PRIVATE_HOSTNAMES=$4

HOSTNAMES=("$MASTER_PRIVATE_HOSTNAME" "$WORKERS_PRIVATE_HOSTNAMES")

# Enable passwordless SSH from local to master
if ! [ -f ~/.ssh/id_rsa ]; then
  ssh-keygen -f ~/.ssh/id_rsa -t rsa -P ""
fi
cat ~/.ssh/id_rsa.pub | run_cmd_on_node ${MASTER_DNS} 'cat >> ~/.ssh/authorized_keys'

# Enable passwordless SSH from master to slaves
SCRIPT=${CONFIGURATOR_ROOT}/config/ssh/setup_ssh.sh
ARGS="${WORKER_DNSES}"
run_script_on_node ${MASTER_DNS} ${SCRIPT} ${ARGS}

# Add NameNode, DataNodes, and Secondary NameNode to known hosts
SCRIPT=${CONFIGURATOR_ROOT}/config/ssh/add_to_known_hosts.sh
ARGS="${MASTER_DNS} ${HOSTNAMES}"
run_script_on_node ${MASTER_DNS} ${SCRIPT} ${ARGS}
