#!/bin/bash

set -eu

conf_file='/etc/nginx/nginx.conf'

# Stay alive to allow Docker to manage it
echo -e "\ndaemon off;\n" >> "${conf_file}"

# clean default configurations
rm -f /etc/nginx/conf.d/*
