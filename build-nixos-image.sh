#!/bin/bash

# Run me from this folder, please.
nix-build -A config.system.build.googleComputeImage -o gce -j 10

img_path=$(echo gce/*.tar.gz)
img_name=${IMAGE_NAME:-$(basename "$img_path")}
img_id=$(echo "$img_name" | sed 's|.raw.tar.gz$||;s|\.|-|g;s|_|-|g')

if ! gsutil ls "gs://${BUCKET_NAME}/$img_name"; then
  gsutil cp "$img_path" "gs://${BUCKET_NAME}/$img_name"

  gcloud compute images create \
    "$img_id" \
    --source-uri "gs://${BUCKET_NAME}/$img_name" \
    --family="dev-nixos"
fi