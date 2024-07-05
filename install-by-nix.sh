#!/usr/bin/env bash

packages=$(cat devbox.json | jq -r -c '.packages | keys' | tr -d '[]"' | tr , ' ')

for i in ${packages}; do
  nix profile install 'nixpkgs#'$i
done

