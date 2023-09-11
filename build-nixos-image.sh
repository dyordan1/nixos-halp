#!/bin/bash

nix-build \
   -A config.system.build.googleComputeImage \
   -o gce \
   -j 10