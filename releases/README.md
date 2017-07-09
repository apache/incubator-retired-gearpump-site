This directory is used to store the release documents for each release

directory structure

```
/releases
  |-- latest
  |-- 0.5
  |-- ...
```

For each release, please run command "docs/build_doc.sh" under Gearpump repository, rename `latest` directory to name reflecting previous version number
and copy the whole `docs/site` directory (from gearpump repo, after building) to release and rename `site` directory `latest`. 
