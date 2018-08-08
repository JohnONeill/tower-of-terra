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

CONFIG_ROOT=$(dirname "${BASH_SOURCE}")

source ${CONFIGURATOR_ROOT}/colors.sh

REM_USER=${REM_USER:=ubuntu}

function run_script_on_node {
  local public_dns=$1; shift
  local script="$1"; shift
  local argin="$@"
  ssh -A -o "StrictHostKeyChecking no" ${REM_USER}@${public_dns} 'bash -s' < "${script}" "${argin}"
}

function get_dependencies {
  while read line; do
    KEY_RAW=$(echo $line | awk '{print $1}')
    KEY=${KEY_RAW%?}
    VALUE=$(echo $line | awk '{print $2}')
    if [ "$KEY" == "$TECHNOLOGY" ]; then
      if [ -z $VALUE ]; then
        DEP=()
        echo ${DEP}
        break
      else
        DEP_RAW=${VALUE//,/ }
        DEP=($DEP_RAW)
        echo ${DEP[@]}
      fi
    fi
  done < ${CONFIGURATOR_ROOT}/dependencies.txt
}

function install_tech {
  MODE=$1
  if [ -z "${DEP}" ]; then
    echo "Installing ${TECHNOLOGY} on ${MASTER_DNS} and ${WORKER_DNSES}"
    ${CONFIGURATOR_ROOT}/install/cluster_download ${MASTER_DNS} ${WORKER_DNSES} ${TECHNOLOGY} ${MODE}
    ${CONFIGURATOR_ROOT}/config/${TECHNOLOGY}/setup_cluster.sh ${MASTER_DNS} ${WORKER_DNSES}
  else
    echo 'IN ELSE'
    INSTALLED=$(check_remote_folder ${MASTER_DNS} ${DEP_ROOT_FOLDER}${DEP})
    if [ "${INSTALLED}" = "installed" ]; then
      DEP=(${DEP[@]:1})
      echo ${DEP}
      install_tech ${MODE}
    else
      echo "${DEP} is not installed in ${DEP_ROOT_FOLDER}"
      echo "Please install ${DEP} and then proceed with ${TECHNOLOGY}"
      echo "configurator install ${MASTER_DNS} ${TECHNOLOGY}"
      exit 1
    fi
  fi
}

function run_cmd_on_file {
  local filename=$1; shift
  local cmd="$@";

  if [ -f ${filename} ]; then
    eval ${cmd}
  fi

}

function fetch_public_dns_of_node_in_cluster {
  local cluster_name=$1
  local cluster_num=$2
  local filename=${CONFIGURATOR_ROOT}/tmp/${cluster_name}/public_dns
  local cmd='sed -n "${cluster_num}{p;q;}" ${filename}'
  run_cmd_on_file ${filename} ${cmd}
}

function check_cluster_exists {
  local cluster_name=$1
  if [ ! -d ${CONFIGURATOR_ROOT}/tmp/${cluster_name} ]; then
    echo "cluster does not exist locally"
    echo "run configurator fetch <cluster-name> first"
    exit 1
  fi

  local public_dns=$(fetch_cluster_public_dns ${cluster_name})
  local instance_ids=($(get_instance_ids_with_public_dns ${public_dns}))

  if [ ${#instance_ids[@]} -eq 0 ]; then
    echo "cluster does not exist on AWS"
    echo "run configurator fetch <cluster-name>"
    exit 1
  fi
}

function check_remote_folder {
  local remote_dns=$1
  local dependency_path=$2
  ssh -A -o "StrictHostKeyChecking no" ${REM_USER}@${remote_dns} bash -c "'
    if [ -d ${dependency_path} ]; then
      echo "installed"
    else
      echo "missing"
    fi
    '"
}

function fetch_cluster_worker_public_dns {
  local cluster_name=$1
  local filename=${CONFIG_ROOT}/tmp/${cluster_name}/public_dns
  local cmd='tail -n +2 ${filename}'
  run_cmd_on_file ${filename} ${cmd}
}

function service_action {
  case ${INSTALL_PATH} in
    folder)
      INSTALLED=$(check_remote_folder ${MASTER_DNS} ${ROOT_FOLDER}${TECHNOLOGY})
      ;;

    file)
      INSTALLED=$(check_remote_file ${MASTER_DNS} ${ROOT_FOLDER}${TECHNOLOGY})
      ;;
  esac

  if [ "${INSTALLED}" = "installed" ]; then
    case ${ACTION} in
      start)
        ${CONFIG_ROOT}/service/${TECHNOLOGY}/start_service.sh ${MASTER_DNS} ${WORKER_DNSES}
        ;;
      *)
        echo -e "Invalid action for ${TECHNOLOGY}"
        exit 1
    esac
  else
    echo "${TECHNOLOGY} is not installed in ${ROOT_FOLDER}"
    exit 1
  fi
}

function run_cmd_on_node {
  local public_dns=$1; shift
  local cmd="$@"
  ssh -A -o "StrictHostKeyChecking no" ${REM_USER}@${public_dns} ${cmd}
}
