#!/usr/bin/env bash

# This script template is expected to be populated during the setup of a
# OpenShift  bastion. It runs on host startup.

# Install packages required to setup OpenShift.
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion
yum update -y

# Allow the ec2-user to sudo without a tty, which is required when we run post
# install scripts on the server.
echo Defaults:ec2-user \!requiretty >> /etc/sudoers
