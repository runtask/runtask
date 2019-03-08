#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$0")")"
source ./common.bashrc


run sudo -E docker logout
