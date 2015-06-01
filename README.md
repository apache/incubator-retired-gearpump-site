# This is the source code for gearpump.io

## How to contribute to the gearpump.io site 

*NOTE:* Please don't change files under site/ directly! As they will be overriden when you do ```mkdocs build```

1. Install mkdocs version 0.11.1, as specified in http://www.mkdocs.org/#installation but use this command: 
```pip install https://pypi.python.org/packages/source/m/mkdocs/mkdocs-0.11.1.tar.gz#md5=947e8997e932578ac64c24de2a4440d6``` 
if you already have a higher version of mkdocs, uninstall it first by ```pip uninstall mkdocs``` (note: Please use linux if possible, there is some encoding issue which require manual fix on Windows)
2. Make changes under /docs
3. Test the changes locally, by ```mkdocs serve```
4. Generate the site files ```mkdocs build```, it will render the markdown file as html file and save the result to  site/
5. Make a PR
6. After it is merged, check http://www.gearpump.io to see the result.
