# How to update http://gearpump.io website for a GearPump release

This guide is for how to update http://gearpump.io website for a GearPump release.
It is *NOT* for how to release GearPump itself.

## Cleanup the old release documentation
Directory `releases/latest` in this repository holds the release documentation
for latest release.

As we are preparing for a new release, you need to rename `latest` to some explicit version,
e.g. `0.5` to indicate this old release documentation is for `0.5` release.

And you may ONLY want to keep several key release documents, you can remove corresponding
obselete releases by removing corresponding version directories under `releases` directory.

## Generate GearPump release documentation (including API doc)

You need to under GearPump source code root directory execute command

```bash
cd docs
./build_doc.sh  2.11  1
```

It will generate all release documents under `_site`.

## Upload the release documentation to http://gearpump.io
You need to upload the generated `_site` directory in previous step to *THIS* repository's `releases/` directory
and rename `_site` directory to `latest`.

## Update http://gearpump.io content
### Update the Gearpump version number in `_config.yml`

### Update `_layouts/global.html` for current link
File `_layouts/global.html` contains the navigation bar for the whole website.
As we updated the release documentation, we need to update the navigation bar to reflect this change.

### Update the `download.md` for download link
File `download.md` contains the download link for GearPump. This also needs to be updated.

### Update other pages for new features and introduction
Please update corresponding pages to reflect GearPump new features.

## Compile HTML pages
You need to run

```bash
jekyll build
```

to generate all the HTML pages. These pages are under `_site` directory.

You can make a local check by

```bash
jekyll serve --watch
```

And use browser to visit http://127.0.0.1:4000 for a dry run. 

## Check in your changes
Please check in all the pages you modified, all the changes you made under `releases` directory,
and jekyll *generated* files under `_site` directory to Git repository.

And then after a *careful check*, please raise a PR.

When PR is merged, the website is updated corresponding automatically.

*NOTE* Here we need to also include `_site` in Git as there is no automatically mechanism for
http://gearpump.io to read from `.md` files.
