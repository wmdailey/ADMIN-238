#!/bin/bash

# Copyright 2024 Cloudera, Inc.
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

# Title: submit_csr.sh
# Author: WKD
# Date: 1MAY25

# DEBUG
# set -x
#set -eu
#set >> /tmp/setvar.txt

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: dana_dev-csr 
spec:
  # This is an encoded CSR. Change this to the base64-encoded contents for other users
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1pqQ0NBVTRDQVFBd0lURVJNQThHQTFVRUF3d0laR0Z1WVY5a1pYWXhEREFLQmdOVkJBb01BMlJsZGpDQwpBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU1CaEdtZkxDbG0yd29YQW1zWTJGcDM1CnpUbE14ZkMzaXVsenJ1aXlPWXBKNGp3MEVNVlpoZjUrMUQvMGZRYVpjR00zRkFpaUQwdjFJYkJFbVQzMnBVY2EKd1phVmxkZ3B3R3dNemVPekVYRHNTRmpENUQrL1E1MEh5ZVpnNXIzNjZMTFozZFVDYU5XbUEzRWVzOCthbFRUWgp6N1lPa243cWo3Wm44dCtONjRZSUM3NXdVcmt3M1BXTEJsNFQxdVZpTXJUVG95dWhWbXpEd0hNUDgvWkVnQ04vCnMxb0tld1ZLK2xCQ0E0QlJkSHFIYkdYRWpGVFU1S1YzL1EyZXdicGFaaFdHQ1ZKMUlXdXRDdUNYUFhmcnV2UEcKRHB0V3B2Tk85d1Zkb0ZJVTVIa2V6bUpPaHJJZ0RkMjNOSjFZODN5L3d2UXJjakIxOCtobjlGSnNRWGRuVDJrQwpBd0VBQWFBQU1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQkk3ek4vY2JteE1TaW9XMk9XV09HeFJlT2I3ekVxCmdtWkQ5WkdmSGYxK0ZHbldnOEVidW1sSUVEbFNZVG51Tmkva202Zy9weG9iN0V0aW1pRFA1R3lwb1U3YVh6eFoKTnc0cDZNS1hGMEJUdFpGRVk0T1EycUJzOWxPS0lHL2JtWmovV1J1bGJRbmtuN1prZDdlR2VRRkFkalB6dWgrdgo1TzBmMXBmak5pYXhpK0toeFlFVWtpL3FhWTF5QTk0S0NyRXd5TGt5VFhsTE5JdFl4Q0xSR3JqY1JReDUrL1FOCmJ1Q2JoN2ZPY3pvZU96NmF6bmFOVDhHTXFHMEZlVmhpYm8vWDVDdEpJRTlxbmZDVXdydDRsdWdVdjBBZStuNW8KaDNCMDhlbVJpNDNLelZoWGJyandNSGc1MEJXNjZweHFoOTBBNC9XdVJncWZCakc2TEk3OEc3ZzYKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF
