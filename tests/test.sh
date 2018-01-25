#!/usr/bin/env sh
set -e
set -v

if [ "$1" = "" ]; then
  echo "test missing"
  exit 1
fi

if [ "$2" = "" ]; then
  echo "action missing"
  exit 1
fi

cd $(dirname $0)/$1

  terraform init
  terraform get
  terraform plan
  read
  terraform $2
