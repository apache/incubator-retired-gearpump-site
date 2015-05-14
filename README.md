# This is the source code for gearpump.io

## How to contribute to the gearpump.io site 

*NOTE:* Please don't change files under site/ directly! As they will be overriden when you do ```mkdocs build```

1. Install mkdocs, as specified in http://www.mkdocs.org/#installation  (note: Please use linux if possible, there is some encoding issue which require manual fix on Windows)
2. Make changes under /docs
3. Test the changes locally, by ```mkdocs serve```
4. Generate the site files ```mkdocs build```, it will render the markdown file as html file and save the result to  site/
5. Make a PR
6. After it is merged, check http://www.gearpump.io to see the result.
