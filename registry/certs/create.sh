#!/bin/sh
cd "${0%/*}"

openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout domain.key \
  -x509 -days 365 -out domain.crt \
  -subj "/C=US/ST=Illinois/L=Chicago/O=AnyLogic North America, LLC/OU=Org/CN=local.cloud.registry"
