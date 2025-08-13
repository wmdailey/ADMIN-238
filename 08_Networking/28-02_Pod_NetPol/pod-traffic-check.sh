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
NS=db-ns
APP_POD=app01-pod
APP_NS=db-ns
APP_IP=0.0.0.0
APP_PORT=8080
DB_POD=db01-pod
DB_NS=db-ns
DB_IP=0.0.0.0
DB_PORT=6379
WEB_POD=web01-pod
WEB_NS=db-ns
WEB_IP=0.0.0.0
WEB_PORT=80

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
                Set IP address and check ports.
        -i, --install
		Install netcat packages
        -t, --traffic
                Test traffic between Pods 
	-s, --setup
		Set up application
EOF
	exit
}

function check_arg() {
# Check if arguments exits

        if [ ${NUM_ARG} -ne "$1" ]; then
                usage
        fi
}

function setup_ns() {

	if [ -e $(pwd)/db-ns.yaml ]; then
		kubectl apply -f db-ns.yaml
	else
		echo "ERROR: file db-ns.yaml not found"
	fi
}

function setup_app() {
	
	if [ -e $(pwd)/k8s/web01-pod.yaml ]; then
		kubectl apply -f k8s/
	else
		echo "ERROR: file app01-pod.yaml not found."
	fi
}

extract_pod_ip() {
	echo "Run port check..."

  	# Get the Pod's IP using kubectl and parse with awk
  	APP_IP=$(kubectl get pod "$APP_POD" -n "$APP_NS" -o wide 2>/dev/null | \
        awk 'NR>1 {print $6}')

  	if [[ -z "$APP_IP" ]]; then
    		echo "  ERROR: Could not find IP Address for Pod '$APP_POD' in namespace '$APP_NS'. Check pod name and namespace." >&2
    		return 1
  	fi

  	echo "  Pod $APP_POD has IP address $APP_IP"

  	# Get the Pod's IP using kubectl and parse with awk
  	DB_IP=$(kubectl get pod "$DB_POD" -n "$DB_NS" -o wide 2>/dev/null | \
        awk 'NR>1 {print $6}')

  	if [[ -z "$DB_IP" ]]; then
    		echo "  ERROR: Could not find IP Address for Pod '$DB_POD' in namespace '$DB_NS'. Check pod name and namespace." >&2
    		return 1
  	fi

  	echo "  Pod $DB_POD has IP address $DB_IP"

  	# Get the Pod's IP using kubectl and parse with awk
  	WEB_IP=$(kubectl get pod "$WEB_POD" -n "$WEB_NS" -o wide 2>/dev/null | \
        awk 'NR>1 {print $6}')

  	if [[ -z "$DB_IP" ]]; then
    		echo "  ERROR: Could not find IP Address for Pod '$WEB_PORT' in namespace '$WEB_NS'. Check pod name and namespace." >&2
    		return 1
	fi

  	echo "  Pod $WEB_POD has IP address $WEB_IP"
}

function port_check() {
	local timeout=2

  echo "Run Port check with netcat ..."

	if kubectl -n $WEB_NS exec -it $WEB_POD -- nc -z -w $timeout $APP_IP $APP_PORT; then
		echo "  Port check to app server succesful"
	else
		echo "  ERROR: Port check to $APP_POD failed or timed out"
		return 1
        fi
	if kubectl -n $APP_NS exec -it $APP_POD -- nc -z -w $timeout $DB_IP $DB_PORT; then
		echo "  Port check to database server succesful"
	else
		echo "  ERROR: Port check to $DB_POD failed or timed out"
		return 1
       fi
	if kubectl -n $APP_NS exec -it $APP_POD -- nc -z -w $timeout $WEB_IP $WEB_PORT; then
		echo "  Port check to web server succesful"
	else
		echo "  ERROR: Port check to $WEB_POD failed or timed out"

		return 1
       fi
}

function install_package() {
  echo "Installing packages..."

  for pod in $APP_POD $DB_POD $WEB_POD; do
  	if kubectl -n $NS exec -it $pod -- sh -c "apt update > /dev/null 2>&1; apt install -y netcat-openbsd > /dev/null 2>&1"; then
		echo "  Install complete on $pod"
	else
		echo "  ERROR: Install failed on $pod"
		return 1
	fi
  done
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
  echo "* Check traffic from APP to DATABASE"
  check_command_status kubectl -n $APP_NS exec $APP_POD -- sh -c "nc -w 1 $DB_IP $DB_PORT"
  echo
  echo "* Check traffic from APP to WEB"
  check_command_status kubectl -n $APP_NS exec $APP_POD -- sh -c "nc -w 1 $WEB_IP $WEB_PORT"
}

function traffic_check_from_db() {
  echo
  echo "* Check traffic from DATABASE to APP"
  check_command_status kubectl -n $DB_NS exec $DB_POD -- sh -c "nc -w 1 $APP_IP $APP_PORT"
  echo
  echo "* Check traffic from DATABASE to WEB"
  check_command_status kubectl -n $DB_NS exec $DB_POD -- sh -c "nc -w 1 $WEB_IP $WEB_PORT"
}

function traffic_check_from_web() {
  echo
  echo "* Check traffic from WEB to APP"
  check_command_status kubectl -n $WEB_NS exec $WEB_POD -- sh -c "nc -w 1 $APP_IP $APP_PORT"
  echo
  echo "* Check traffic from WEB to DATABASE"
  check_command_status kubectl -n $WEB_NS exec $WEB_POD -- sh -c "nc -w 1 $DB_IP $DB_PORT"
}

function run_option() {
# Case statement for add, delete or list working
# directories for user

        case "${OPTION}" in
                -h | --help)
                        get_help
                        ;;
                -c | --check)
			extract_pod_ip
                        port_check
                        ;;
		-i | --install)
			extract_pod_ip
			install_package
			;;
                -t | --traffic)
			extract_pod_ip
                        traffic_check_from_app
                        traffic_check_from_db
                        traffic_check_from_web
                        ;;
		-s | --setup)
			setup_ns
			setup_app
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
