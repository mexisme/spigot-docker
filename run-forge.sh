#!/usr/bin/env bash

cd /minecraft
for F in run.sh user_jvm_args.txt libraries eula.txt; do
  [[ -e "$F" ]] || ln -sv /app/"$F"
done

exec ./run.sh
