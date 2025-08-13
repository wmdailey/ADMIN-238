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

# MAIN
kubectl -n app-ns delete pod app01-pod 
kubectl -n app-ns delete svc app01-svc
kubectl -n db-ns delete sts db01-sts 
kubectl -n db-ns delete cm db01-cm
kubectl -n db-ns delete svc db01-svc
kubectl -n web-ns delete pod web01-pod
kubectl -n web-ns delete svc web01-svc
kubectl -n app-ns delete netpol app01-netpol
kubectl -n db-ns delete netpol db01-netpol
kubectl -n web-ns delete netpol web01-netpol
kubectl delete ns app-ns db-ns web-ns

echo "Finished"
