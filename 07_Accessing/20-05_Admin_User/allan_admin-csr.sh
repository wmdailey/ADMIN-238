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
  name: allan_admin-csr 
spec:
  # This is an encoded CSR. Change this to the base64-encoded contents for other users
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ2REQ0NBVndDQVFBd0x6RVVNQklHQTFVRUF3d0xZV3hzWVc1ZllXUnRhVzR4RnpBVkJnTlZCQW9NRG1GawpiV2x1Y3pwdFlYTjBaWEp6TUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUEya3RrCmxSemkyVnRONW5pVmNkdTZLc2YwSlBkL1EzOVI2aVFUQmwxS01vbmMxdkFrRHFhY3FXM0xBR0JQSFc1SlEwblkKT0xMd0k3UTVSWTZEZkhFRWsyMzZpZjBaOGN6cTBLdTMvMXhrU0R1aCt2aG1qY1k2aGxFdDJaVlBGS29SdXB1ZwpVR1dUS0V1bkdLMnNvSGZSakw4djJ1RGdtMTV4UzhqV3BvNXMrNk9XdDFaSlpndXlQZjZFaGNFNUZqbjAvcCtmCjJ0NnROczZFMUlYZVNCMUpUckJoSFFkRytTMUpKSkM5OGtob3lnRDh4NjdkL3VKSyttWkM2T1ZWUzl4N1RLWGsKREVmcW1UdjJGOTBySTRGUExrWHNzd3M0UllZc0NlNTgvYkpoczk2MWxrcHRxK0lqK1l3RnhyUVFZWVkvclpxZQpYbGlHTjF4d1ZoMjc3MlZ0andJREFRQUJvQUF3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUpHOGRIMFAvajJxCjZSaXRXemxYcU1KaVBiSHp3aG9vekZMdGkyT1VBbzBjL1BTOUxnclRNOVhpZDlSbHE5Y1lKWTR3T0x3bkVXa2kKcFE1NUh5WEVENVJYcTZTSHg2bmxsdzQ5czFhRWxGUjdNL1h5TVV6WlBaYjZsdzVYekY2WVZZL3lJUmJsQUpDMwpRMmpFRDVPcFdvOXF6RndiWVgyRmZvRWl4ZGh6YlJhTEFGT0ZONWRRWVBjWVJtK0Jpb1RwK2E4Qlp4cWNkMlJ1ClY0ejdvT2dtbGYxam1KMFIxaXNZRVNkamlyeHlpejlXZmJTUWEzeHYwbWIxa1M5T3NlYjVLeWgwU0lKdmcrblcKZnhmb055NW5RNCtaZitTS2RxcTZaVG55L1ovT3RneFVMR2wwNEh2VUc5SGRtRVVzTllsc09PY2xTTGRCNGlqeAorcENqbDRYQWhvdz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF
