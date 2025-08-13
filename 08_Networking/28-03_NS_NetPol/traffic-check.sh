#!/bin/bash

# Copyright 2025 Cloudera, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Disclaimer
# This script is for training purposes only and is to be used only
# in support of approved training. The author assumes no liability
# for use outside of a training environments. Unless required by
# applicable law or agreed to in writing, software distributed under
# the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, either express or implied.

# Title: clean-ingress-controller.sh
# Author: WKD
# Date: 17JUN25
# Purpose: Clean out the ingress controller that was installed manually.
# action menu option.

# DEBUG
#set -x
#set -eu
#set >> /tmp/setvar.txt

# VARIABLE
NUM_ARG=$#
OPTION=$1
APP_IP=10.244.178.51
DB_IP=10.244.210.12
WEB_IP=10.244.210.11
DB_POD=db01-sts-0
WEB_POD=web01-pod
APP_NS=app-ns
DB_NS=db-ns
WEB_NS=web-ns

# FUNCTION

function usage() {
        echo "Usage: $(basename $0) [OPTION]"
        exit
}

function get_help() {
# help page

cat << EOF
SYNOPSIS
        traffic_check.sh [OPTION]

DESCRIPTION
        Run a traffic check against Pods

        -h, --help
                Help page
        -c, --check
                Run the traffic check
        -p, --ping
                Run a ping test for the IP addresses
EOF
	exit
}

function check_arg() {
# Check if arguments exits

        if [ ${NUM_ARG} -ne "$1" ]; then
                usage
        fi
}

function ping_check() {
  local count=2
  local timeout=2

  echo "Run ping test ..."

  for ping_ip in $APP_IP $DB_IP $WEB_IP; do
	if kubectl -n kube-tools exec -it dnsutils -- ping -c $count -W $timeout $ping_ip > /tmp/ping 2>&1 ; then
		echo "  Ping to $ping_ip succesful"
	else
		echo "  ERROR: Ping to $ping_ip failed or timed out"
		return 1
  	fi
  done
}

function install_package() {
  echo "Installing packages..."

  	if kubectl -n $DB_NS exec -it $DB_POD -- sh -c "apt update > /dev/null 2>&1; apt install -y netcat-openbsd > /dev/null 2>&1"; then
		echo "  Install complete on $DB_POD"
	else
		echo "  ERROR: Install failed on $DB_POD"
		return 1
	fi
  	if kubectl -n $WEB_NS exec -it $WEB_POD -- sh -c "apt update > /dev/null 2>&1; apt install -y netcat-openbsd > /dev/null 2>&1"; then
		echo "  Install complete on $WEB_POD"
	else
		echo "  ERROR: Install failed on $WEB_POD"
		return 1
       fi

  echo "Packages installed"
}

function check_command_status() {
   "$@"
   local exit_code=$?

   if [ ${exit_code} -eq 0 ]; then
      echo "Command '$*' succeed."
   else
      echo "ERROR: Command '$*' failed."
   fi
}

function traffic_check_from_app() {
  echo
  echo "* Check traffic from app server to database server"
  check_command_status kubectl -n app-ns exec app01-pod -- sh -c "nc -w 1 $DB_IP 5432"
  echo
  echo "* Check traffic from app server to web server"
  check_command_status kubectl -n app-ns exec app01-pod -- sh -c "nc -w 1 $WEB_IP 80"
}

function traffic_check_from_db() {
  echo
  echo "* Check traffic from database server to app server"
  check_command_status kubectl -n db-ns exec db01-sts-0 -- sh -c "nc -w 1 $APP_IP 3000"
  echo
  echo "* Check traffic from database server to web server"
  check_command_status kubectl -n db-ns exec db01-sts-0 -- sh -c "nc -w 1 $WEB_IP 80"
}

function traffic_check_from_web() {
  echo
  echo "* Check traffic from web server to app server"
  check_command_status kubectl -n web-ns exec web01-pod -- sh -c "nc -w 1 $APP_IP 3000"
  echo
  echo "* Check traffic from web server to database server"
  check_command_status kubectl -n web-ns exec web01-pod -- sh -c "nc -w 1 $DB_IP 5432"
}

function run_option() {
# Case statement for add, delete or list working
# directories for user

        case "${OPTION}" in
                -h | --help)
                        get_help
                        ;;
                -c | --check)
                        traffic_check_from_app
                        traffic_check_from_db
                        traffic_check_from_web
                        ;;
                -p | --ping)
                        ping_check
			install_package
                        ;;
                *)
                        usage
                        ;;
        esac
}

function main() {
	run_option
}

# Main
main "$@"
exit 0
