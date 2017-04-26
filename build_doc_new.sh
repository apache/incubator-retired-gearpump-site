#!/bin/bash

# generate _site documents
jekyll build

# check html link validality
htmlproofer content \
  --disable-external \
  --url-ignore \#,./../releases/latest/index.html,../../../../releases/latest/index.html
