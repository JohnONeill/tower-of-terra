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

CONFIGURATOR_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${CONFIGURATOR_ROOT}/util.sh

if [ "$#" -ne 2 ]; then
    echo "Please specify public dnses (master & workers)!" && exit 1
fi

MASTER_PUBLIC_DNS=$1
WORKERS_PUBLIC_DNS=$2

PUBLIC_DNSES=("$MASTER_PUBLIC_DNS" "$WORKERS_PUBLIC_DNS")

# Install and configure nodes for zookeeper
for dns in ${PUBLIC_DNSES[@]}; do
  echo 'starting'
  echo $dns
  cmd=". ~/.profile; zkServer.sh start"
  run_cmd_on_node ${dns} ${cmd} &
done

wait

echo "Zookeeper Started!"
