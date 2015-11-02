#!/bin/bash

# generate _site documents
jekyll build

# check html link validality
htmlproof _site \
  --disable-external \
  --url-ignore \#,../releases/latest/index.html
