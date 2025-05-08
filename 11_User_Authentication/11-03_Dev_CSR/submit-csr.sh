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
  name: dana_dev # Change name 
spec:
  # This is an encoded CSR. Change this to the base64-encoded contents of myuser.csr
  signerName: kubernetes.io/kube-apiserver-client
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJRFpqQ0NBYzRDQVFBd0lURVJNQThHQTFVRUF3d0laR0Z1WVY5a1pYWXhEREFLQmdOVkJBb01BMlJsZGpDQwpBYUl3RFFZSktvWklodmNOQVFFQkJRQURnZ0dQQURDQ0FZb0NnZ0dCQU1lZkV6a2JHd1pRTVRFRk1GNXRNMnYzCkFMc2xzd1BBVGNJTTczZ0R6V280Z25MZ3VFUGFWQ2MwNmhrTkdudWFndzdWZFNFeDNkOEc2RTBab1BKdHJnb1YKN2p4cm9MS3pBQmZrQlM1SjhLL1dFc1Q1eTRmMWZidFp4RW8ySjNJY3ZVdkgrQlIvSVFHeG81OFAzbDJFMTM3OQprVC9YVXNDTFpRNVRHdTZ5N3kvSEdyNUhMYVlnUmc5VVBpUWFDd1hvSXV4VWo5b3IwaHFhQU5tTTBJbXcrcVE5CmxmTForODNjNGZlRVgxSWNWUG5XeXphZVNLRkFpWVV1Q1lUSXlXYVc2cGFEdnVSRk1ibXY2MDR5Yy9qWVJIU24KcTE5V3JSOTAyRXRJQUx5YitNWjE3UXZJTlNJT3ZTbUhZZnJ6RlNDV3NqTlhiRlkwNmlyWGQxRGgycW9zT21teQpZMytaTEZ4dytsamRnZnp4eW5wSDd1cFVHNGl2UVdNQ0lBMVdYYkV1UGgzOWs0dUlrRURyUlU1QkhLcDBLMUlTCkc1eWdUVnFrWjlac0ptZFVDTEswYWVvMVVCZnN3MXcveTFQc0wwb3Y3NzdUZVBGbFZ0L1lBaEs1c2ZkSTN2UDcKVG5Dak5xU2xESVdVMUw3SGRSdHVmOWpiejhnSjNScEdNUHF2ejZSUTN3SURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnR0JBRXFpNTA1Q0ZGYm4yNE5FbExWajdieG5kRzlBK0dqTkJsN2tjaExod2RIU1RqUHdzVnJUCmgwbVZOdFd6TnZpL21jNkdlSGJXOG5SYTI3bjNIUUZ6OUs1aDlXUkhtMjdnaUdGZGN2Ykozck1LaThVTUxnOUUKNGMzU1YvWmxsVE1jcFBFTkZPT3BVMEtXWVUyWkdjK3ZvcWpDTzF4aUcxK0VBdXp3WEJ1aDY4S2VMb1lZeXZHbgowZzRqL0wvS1hiUzRJWjVsa05pWjNyUkNzM3kwNSthL1JjaktDaFUrOEdYNkV1QnNuWXZxbHRyWDVadERGcXA1CnNKM3FUSWZmZDRKQ3doNTBPY0JjYWlRWkxiN3hwcDZTNDZWbVQyWXhRdFl5MUVSMXFBV05VY2RtdEhPVHk3dGkKY0lwY3RFQVc1dElPaTI2UDgycDE4QkwzLy84ZEZ3TmtGUmNwejd2UGpINXpBVmhPaTVieTNjR2FlRkNuZWhWaApOTVpSa1dOOWowYlVTVzVhQUE4QTBNNVNMa3lzMUtsdElLM1ZtTytva3JkYXdIV2tmMFVJUmI0Y1AwckRTMmxNClg5L3Q5RGpKNk1qUjJUejVZWGJYUU5aaXd6NkJFaGZubTY4aE9IUU1yYnlyYzBqTmliRCt0K1JiN2UrZDRQKzgKdnk2eVJwT1VEK3llT3c9PQotLS0tLUVORCBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0K
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF
