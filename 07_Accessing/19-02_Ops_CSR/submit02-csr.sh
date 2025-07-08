#!/bin/bash

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
  name: omar_ops # Change name 
spec:
  # This is an encoded CSR. Change this to the base64-encoded contents of myuser.csr
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJRFpqQ0NBYzRDQVFBd0lURVJNQThHQTFVRUF3d0liMjFoY2w5dmNITXhEREFLQmdOVkJBb01BMjl3Y3pDQwpBYUl3RFFZSktvWklodmNOQVFFQkJRQURnZ0dQQURDQ0FZb0NnZ0dCQU14a2t1dXg4WjBoMk0rdnZENU0za1M4Ck9JTThDZDZFdEZObDgxNjFTaFViNldNTHpXNHdNVEVTeGNRUEQ3dElxUHpLQjBzK085ejRmcCtrT0N1M0taMi8KVlUxTFc4NzVkMVBGempWc3paaHF3YWlEMjFkdWxQd0pUN3VVOE1paWYyUEFJWU43UjNJRmhCck5ZZVcwNXpYRwpTK1o5bDJnWVFkWUh1Y2YyTlJ6NUt3VWZkSys4RU5LMUlBWWV2UndiVjFqUGRUTGlXSlFCTmZ3bXV2VW5GSk9aCmRjcjhDWU83all5bTc1RmZYYTFLM1hBL2thb1hMTWpFZi9YZ1ZrQjhRQlU1RXNLWU5Gd3pWYjRFSitBOVB1bEkKbVNwSGZwWmozcDJtVXdiYjBCdW9oVHhtOUs0emdRSEJiZjl6UlNFS3hoVG53MHRFd0luR0RuY2IzWnJ2TllBYQpjcE85ZGZvVGE3amdpWmJKOFFQdiszRXBPWFFNWjh5enJpemhYU2tOZW91eEZ2eXpEUEx5MncrTk5vaEI3ZWVMCkFQaVlYZEVUN2JBN2Z0WVlzQ1lxek5KV20wSFNNd2lubFdrSkUvZmNFWkhRRU9MWklCVkhIQTMwZHBJa1pIOHQKYkd3RWpYemdPRFlxU3JtRXNiL1dMckJUOVlLZTNNdTF6ckVoVFNpaFJ3SURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnR0JBRERqT1ZjMFhBU25tZ1A4UWpPOEd6RTVVSFhTNzZ0cmhjV1k1Wnora1FrR04vZS9wNTJCCnlDVDU1WGNMOUNKalZMcFVBdFhDazlNdW53TWtNTmF6d0NGU3kxclRRYlN6eVlZUXYxU0h3WUhBdGp6RXhHZTYKNVZGK0xsUXN6bC9FejZFb25RY3NiL2duM3FFaDF3MS9Vb3dUZFpjOWduUG9GY2h3TWxVM0ZwVk5NQWpHR0licgpoUjRKazNEYm9CMlcxYWFFellwUXRqZ1hibVdDTmM3dnZhbTY4Lzgvdkh6dFFxTjhoSHltTDFsL0o0dXMzdjEyCkdaUjMzelBnMnNiWDRDMjQwTHo0dkd5YzdSOFNKaGNScjRCWUZmUVA5QnFXamxOaWI2aU5YUkJkRkNWTVE3ejMKYVFHbE9KRnNYWk0reHBneWlFMXVsMWpXSXBtTmtQaEgvSk9ETXY3QUlyM0h1Z0FON0tDMXg4MFEwbGs5eENQMgpDMVpVSWFQWjUzbUpJWUZuR2tlbG4rOEc2QWR5ZG1UakxyQWdIQTZKbEJYWUtkVXlSeUNqT0JvUTljVXIyWGFaClUyVmpyQWxWU20yMEQ4QVB0S2hyN3FtejAwdXFNeU0wMGQyRElTbzMvdnU1Q3VYdnFERHFncU5tRUtBQ0FmOWIKaDBNSmtESXcxc0doSVE9PQotLS0tLUVORCBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0K
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF
