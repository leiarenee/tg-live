#!/bin/bash
set -e
cd infrastructure/dynamic
pwd
terragrunt run-all apply $@
