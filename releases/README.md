This directory is used to store the release documents for each release

directory structure

```
/releases
  |-- latest
  |-- 0.5
  |-- ...
```

For each release, please run the command "docs/build_doc.sh" under Gearpump repository, 
rename `latest` directory to a name reflecting previous version number 
and copy the whole `docs/site` directory (from Gearpump repo, after having it built) to release and rename `site` directory to `latest`.
