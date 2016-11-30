This README gives an overview of how to build and contribute to the documentation of [Gearpump](https://github.com/apache/incubator-gearpump).

The documentation is included with the source of Gearpump in order to ensure that you always
have docs corresponding to your checked out version.

# Requirements

We use Markdown to write and Jekyll to translate the documentation to static HTML. To install
Jekyll, you need to install the software as follows:

For redhat linux systems:
    `sudo yum install ruby ruby-devel nodejs python-pip`
    `sudo gem install jekyll`
    `sudo gem install kramdown`
    `sudo gem install html-proofer`
    `sudo pip Pygments`

Kramdown is needed for Markdown processing and the Python based Pygments is used for syntax
highlighting.

# How to contribute

## Step1: Update the documents for specific Gearpump version if needed
The documents for specific Gearpump version can be updated under [Gearpump docs](https://github.com/apache/incubator-gearpump/tree/master/docs).
After it is updated, check [How to Build](https://github.com/apache/incubator-gearpump/tree/master/docs#how-to-build) to generate documents for that specific version.

## Step2: Upload the generated documents in step 1 to [/release](https://github.com/apache/incubator-gearpump-site/tree/asf-site/releases) folder.

## Step3: Update the documents for the general site under this repo.

## Step4: Test the build

Command `jekyll build` can be used to make the build.

Command `jekyll serve --watch` can be used to for development. Jekyll will start a web server at
`localhost:4000` and watch the docs directory for updates. You can use this mode to experiment changes and check the UI locally. 

## Step5: Commit to this repo.
If everything looks fine, make a PR to contribute the code changes to this repo.

# Markdown format description

The documentation pages are written in
[Markdown](http://daringfireball.net/projects/markdown/syntax). It is possible to use the
[GitHub flavored syntax](http://github.github.com/github-flavored-markdown) and intermix plain html.

In addition to Markdown, every page contains a Jekyll front matter, which specifies the title of the
page and the layout to use. The title is used as the top-level heading for the page.

    ---
    title: "Title of the Page"
    ---

Furthermore, you can access variables found in `docs/_config.yml` as follows:

    {{ site.NAME }}

This will be replaced with the value of the variable called `NAME` when generating
the docs.

All documents are structed with headings. From these heading, a page outline is
automatically generated for each page.

```
# Level-1 Heading  <- Used for the title of the page
## Level-2 Heading <- Start with this one
### Level-3 heading
#### Level-4 heading
##### Level-5 heading
```

Please stick to the "logical order" when using the headlines, e.g. start with level-2 headings and
use level-3 headings for subsections, etc. Don't use a different ordering, because you don't like
how a headline looks.

