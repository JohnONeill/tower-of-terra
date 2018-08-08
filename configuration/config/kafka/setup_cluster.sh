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

# check input arguments
if [ "$#" -ne 2 ]; then
    echo "Please specify cluster name!" && exit 1
fi

CONFIGURATOR_ROOT=$(dirname ${BASH_SOURCE})/../..
source ${CONFIGURATOR_ROOT}/util.sh

MASTER_DNS=$1
WORKER_DNSES=$2
PUBLIC_DNSES=("$MASTER_DNS" "$WORKER_DNSES")

single_script="${CONFIGURATOR_ROOT}/config/kafka/setup_single.sh"

# Install and configure nodes for kafka
BROKER_ID=0
for dns in ${PUBLIC_DNSES[@]}; do
  args="$BROKER_ID $dns ${PUBLIC_DNSES}"
  run_script_on_node ${dns} ${single_script} ${args} &
  BROKER_ID=$(($BROKER_ID+1))
done

wait

echo "Kafka configuration complete!"
