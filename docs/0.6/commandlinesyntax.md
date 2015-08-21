# Command Line Syntax

**NOTE:** on windows platform, please use window shell .bat script instead. bash script doesn't work well in cygwin/mingw.
The commands can be found at: "bin/" folder of release binary.

## local

Used to start the cluster in local cluster.
Syntax:
```bash
Usage:
local
```

It will start the local at port configured in conf/gear.conf

## master

Used to start Gearpump master nodes, you can start one or more master nodes. 

Syntax:
```bash
master -ip <master ip address> -port  <master port>
-ip  (required:true)
-port  (required:true)
```

The ip and port settings will be checked against config in gear.conf

## worker

Used to start worker nodes. You usually will start several workers, with one worker on one machine. 

Syntax:
```bash
##  It will load config from gear.conf, no command line arguments should be provided.
worker
```

## services
Used to start the dashboard UI server.

syntax:
```bash
services
```

## gear app
Used to submit a application jar to the Gearpump Cluster. 

Syntax:
```bash
Usage:
gear app -namePrefix <application name prefix> -jar <application>.jar <mainClass <remain arguments>>
-namePrefix  (required:false, default:)
-jar  (required:true)
```

## gear info
Used to list running application information

Syntax:
```bash
C:\myData\gearpump\target\pack\bin>gear info
Usage:
gear info
```

## gear kill
Used to kill an application

Syntax:
```bash
gear kill -appid <application id>
-appid  (required:true)
```

## gear shell
Used to start a scala shell

Syntax:
```bash
C:\myData\gearpump\target\pack\bin>gear shell
Usage:
gear shell
```