#!/bin/bash

set -eu

conf_file='/etc/nginx/nginx.conf'

# Stay alive to allow Docker to manage it
echo "daemon off;" >> "${conf_file}"

# Only include .conf files to ignore supplemental files like keys
sed -i 's@sites-enabled/\*@sites-enabled/*.conf@' "${conf_file}"
