# Get Started

## Prepare the binary
You can either download pre-build release package or choose to build from source code. 

### Download Release Binary

If you choose to use pre-build package, then you don’t need to build from source code. The release package can be downloaded from: 

#### [http://www.gearpump.io/site/downloads/downloads/](http://www.gearpump.io/site/downloads/downloads/)

### Build from Source code

If you choose to build the package from source code yourself, you can follow these steps:
  
1). Clone the GearPump repository

```bash
  git clone https://github.com/intel-hadoop/gearpump.git
  cd gearpump
```

2). Build package

```bash
  ## Please use scala 2.11
  ## The target package path: target/gearpump-$VERSION.tar.gz
  sbt clean assembly packArchive ## Or use: sbt clean assembly pack-archive
```

  After the build, there will be a package file gearpump-${version}.tar.gz generated under target/ folder.
  
  **NOTE:**
  Please set JAVA_HOME environment before the build.
  
  On linux:
  ``` bash
  export JAVA_HOME={path/to/jdk/root/path}
  ```
  
  On Windows:
  ``` bash
  set JAVA_HOME={path/to/jdk/root/path}
  ```
  
  **NOTE:**
The build requires network connection. If you are behind an enterprise proxy, make sure you have set the proxy in your env before running the build commands. 
For windows:

```bash
Set HTTP_PROXY=http://host:port
set HTTPS_PROXT= http://host:port
```

For Linux:

```bash
export HTTP_PROXY=http://host:port
export HTTPS_PROXT= http://host:port
```

## Gearpump package structure

You need to flatten the .tar.gz file to use it, on Linux, you can

```bash
# please replace ${version} below with actual version used
tar  -zxvf gearpump-${version}.tar.gz
```

After decompression, the directory structure looks like picture 1.

![](img/layout.png)
  
Under bin/ folder, there are script files for Linux(bash script) and Windows(.bat script). 

script | function
--------|------------
local | You can start the Gearpump cluster in single JVM(local mode), or in a distributed cluster(cluster mode). To start the cluster in local mode, you can use the local /local.bat helper scripts, it is very useful for developing or troubleshooting. 
master | To start Gearpump in cluster mode, you need to start one or more master nodes, which represent the global resource management center. master/master.bat is launcher script to boot the master node. 
worker | To start Gearpump in cluster mode, you also need to start several workers, with each worker represent a set of local resources. worker/worker.bat is launcher script to start the worker node. 
services | This script is used to start backend REST service and other services for frontend UI dashboard. 

Please check [Command Line Syntax](commandlinesyntax.md) for more information for each script.

Run a distributed application in 30 seconds.
---------------

To start a demo application, there are three steps,
 
### Step1: Start the cluster

You can start a local mode cluster in single line

```bash
# start the master and 4 workers in single JVM. The master will listen on 3000
# you can Ctrl+C to kill the local cluster after you finished the startup tutorial. 
bin/local –ip  127.0.0.1 –port 3000 –workers 4
```

**NOTE: Change the working directory**. Log files by default will be generated under current working directory. So, please "cd" to required working directly before running the shell commands.

**NOTE: Run as Daemon**. You can run it as a background process. For example, use [nohup](http://linux.die.net/man/1/nohup) on linux. 

### Step2: Submit application
After the cluster is started, you can submit an example wordcount application to the cluster

Open another shell, 

```bash
## To run WordCount example, please substitute $VERSION with actual file version.
bin/gear app -jar examples/gearpump-examples-assembly-$VERSION.jar org.apache.gearpump.streaming.examples.wordcount.WordCount -master 127.0.0.1:3000
```

### Step3: Open the UI and view the status

Now, the application is running, start the UI and check the status:

Open another shell, 

```bash
bin/services –master 127.0.0.1:3000
```
You can manage the application in UI [http://127.0.0.1:8090](http://127.0.0.1:8090) or by [Command Line tool](commandlinesyntax.md).

![](img/dashboard.gif)

**NOTE:** the UI port setting can be defined in configuration, please check section [Configuration Guide](0.3/configuration_guide)
You see, now it is up and running. 

### Step4: Congratulation! You have your first application running! 

Other Application Examples
----------

Besides wordcount, there are several other example applications. Please check the source tree examples/ for detail information.
