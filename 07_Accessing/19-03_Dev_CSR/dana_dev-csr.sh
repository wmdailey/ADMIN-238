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
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1pqQ0NBVTRDQVFBd0lURVJNQThHQTFVRUF3d0laR0Z1WVY5a1pYWXhEREFLQmdOVkJBb01BMlJsZGpDQwpBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQUowVERBYWZDMkRQdVlHQlNGSFVBa2ZtCnlWQzdOV1NhTEJ0aGxiTHpGNWFYd0Qra2xzSFpvcGpXOUV2NnZvMTdBN0lNdXpMWXFMVDJpcUpJMUdmRDY3UmIKMFUvaEJuaEFtSWg5YW1rUmNkQ01pZzFEalRwZVBEazczUE5iMHlUYzFWZEROd28weE82bWp3cXAzaUtLY0YyNApVVUJpcmg1Mlg5Z2RFUnpTUXdYRGFXMGJxUC9oMEN2aytsTDB3MjVrcktDbnQ1S1NVOUduZ25hdGFENTRVY056CmRYV2RIYWplK1IvMlVmRUZuSC9OWGVwakNYNHMvYklCTkM2T1FnRTRPTVZhMUdGVTJhemZMMFBBWG9SZ3NjTWUKWGxTcmpBY0ZtaDhKTnRRWjczZmF1blFOZW9nL2Q5MHUwbk5JODdDbkNKTG5oczM0dVJoVStMZ2YwMENxcHZrQwpBd0VBQWFBQU1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQWw5M0FrcWlmMjFkK3I5cWJzbnBUektMYnpVWm50CmZyQkEzbnZJVEZjVEdGVTNCRkxPSUVveGNpQlpDNm4vRVBtS24zMlJ5QmlQNlNWNWloU24vS3pvZzBuZkRQMS8KaFJnOUh2OFdGMkc1WDIvenJyd0JYeUV5RUZUVDJZVUxOSUdGeTBobXVNNnEzamhBTmdqZEZ0YWlKYklHVmcydApjcm5xVGVMMnhKZFcyTlMrSkcxanEyV2RISVZCcE0wS2tsMW9CUk0rTkt3MnRuSzJPaTBnL1JDdjE3VGgycTNXCkN5UWFpRVhlRyszeVJRMFpKZGlwQm1yK3o4MkJTYklwdEVGY1d3bUNkK2xaYWpWaUsyTkQ3M1RhTGdwV3B5bUMKNGNxdDgxelhRM0poY2poSFdPdFBOS0tZTDhieFNHRXh0SUtvZWFrT09xQmlXNU1xOGlWVEFpa1oKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF
