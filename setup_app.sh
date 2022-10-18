#!/usr/bin/env bash

if [[ $# -eq 2 ]];
then
  module=$1
  app=$2

  mv lib/basic_phx_app lib/${app}
  mv lib/basic_phx_app_web lib/${app}_web
  mv lib/basic_phx_app.ex lib/${app}.ex
  mv lib/basic_phx_app_web.ex lib/${app}_web.ex
  mv test/basic_phx_app_web test/${app}_web
  find ./{assets,config,lib,mix.exs,mix.lock,priv,test} -type f | xargs -n 1 sed -i "s/BasicPhxApp/${module}/g"
  find ./{assets,config,lib,mix.exs,mix.lock,priv,test} -type f | xargs -n 1 sed -i "s/basic_phx_app/${app}/g"
  mix deps.get
  mix format
  mkdir -p .git/hooks
  mv pre-commit.template .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
else
  echo "Usage: ./setup_app.sh {ModuleName} {app_name}"
  exit 1
fi