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

# Some useful colors.
if [[ -z "${color_start-}" ]]; then
  declare -r color_start="\033["
  declare -r color_red="${color_start}0;31m"
  declare -r color_green="${color_start}0;32m"
  declare -r color_yellow="${color_start}0;33m"
  declare -r color_blue="${color_start}0;34m"
  declare -r color_magenta="${color_start}0;35m"
  declare -r color_teal="${color_start}0;36m"
  declare -r color_white="${color_start}0;37m"
  declare -r color_norm="${color_start}0m"
fi
