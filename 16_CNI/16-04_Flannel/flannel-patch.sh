#! /bin/bash

# Copyright 2021 Cloudera, Inc.
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

# Title: run_master.sh
# Author: WKD
# Date: 17MAR22
# Purpose: Run the beeline command in a classroom environment with
# TLS and Kerberos. Show the jdbc string for a cut and paste.

# DEBUG
#set -x
#set -eu
#set >> /tmp/setvar.txt

# VARIABLE
ARCH=$(uname -m)
 case $ARCH in
  armv7*) ARCH="arm";;
  aarch64) ARCH="arm64";;
  x86_64) ARCH="amd64";;
 esac
VERSION=v1.6.2

# Functions
mkdir -p /opt/cni/bin

curl -O -L https://github.com/containernetworking/plugins/releases/download/$VERSION/cni-plugins-linux-$ARCH-$VERSION.tgz

tar -C /opt/cni/bin -xzf cni-plugins-linux-$ARCH-$VERSION.tgz
