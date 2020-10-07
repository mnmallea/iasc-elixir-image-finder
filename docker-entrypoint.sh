#!/bin/bash

# https://github.com/nickjj/docker-web-framework-examples/issues/1#issuecomment-397656224

set -e

# Copies built lockfile to app folder
cp /elixir/mix.lock /var/app/mix.lock

exec "$@"
