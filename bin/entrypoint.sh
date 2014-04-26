#!/bin/bash

set -eu

render-templates.sh /etc/nginx/sites-templates /etc/nginx/sites-enabled
exec $@
