## Getting Started

The latest release binary can be found at: https://github.com/intel-hadoop/gearpump/releases

You can skip step 1 and step 2 if you are using pre-build binaries.

The latest released version can be found at: https://github.com/intel-hadoop/gearpump/releases

1. Clone the GearPump repository

  ```bash
  git clone https://github.com/intel-hadoop/gearpump.git
  cd gearpump
  ```

2. Build package

  Build a package

  ```bash
  
  ## Please use scala 2.11
  ## The target package path: target/gearpump-$VERSION.tar.gz
  sbt clean assembly packArchive ## Or use: sbt clean assembly pack-archive
  ```

3. Configure
  
  Distribute the package to all nodes. Modify `conf/gear.conf` on all nodes. You MUST configure ```akka.remote.netty.tcp.hostname``` to make it point to your hostname(or ip), and `gearpump.cluster.masters` to represent a list of master nodes.

  ```
  ### Put Akka configuration here
  base {

    ##############################
    ### Required to change!!
    ### You need to set the ip address or hostname of this machine
    ###
    akka.remote.netty.tcp.hostname = "127.0.0.1"
  }

  #########################################
  ### This is the default configuration for gearpump
  ### To use the application, you at least need to change gearpump.cluster to point to right master
  #########################################
  gearpump {

    ##############################
    ### Required to change!!
    ### You need to set the master cluster address here
    ###
    ###
    ### For example, you may start three master
    ### on node1: bin/master -ip node1 -port 3000
    ### on node2: bin/master -ip node2 -port 3000
    ### on node3: bin/master -ip node3 -port 3000
    ###
    ### Then you need to set the cluster.masters = ["node1:3000","node2:3000","node3:3000"]
    cluster {
      masters = ["127.0.0.1:3000"]
    }
  }
  ```

4. Start Master nodes
 
  Start the master daemon on all nodes you have configured in `gearpump.cluster.masters`. If you have configured `gearpump.cluster.masters` to:
  
  ```
  gearpump{
     cluster {
      masters = ["node1:3000", "node2:3000"]
    }
  }
  ```
  
  Then start master daemon on ```node1``` and ```node2```.

  ```bash
  ## on node1
  cd gearpump-$VERSION
  bin/master -ip node1 -port 3000
  
  ## on node2
  cd gearpump-$VERSION
  bin/master -ip node1 -port 3000
  ```

  We support [Master HA](https://github.com/intel-hadoop/gearpump/wiki#master-ha) and allow master to start on multiple nodes. 

5. Start worker

  Start multiple workers on one or more nodes. 
 
  ```bash
  bin/worker
  ```

6. Submit application jar and run

  You can submit your application to cluster by providing an application jar. For example, for built-in examples, the jar is located at `examples/gearpump-examples-assembly-$VERSION.jar`

  ```bash
  ## To run WordCount example
  bin/gear app -jar examples/gearpump-examples-assembly-$VERSION.jar org.apache.gearpump.streaming.examples.wordcount.WordCount -master node1:3000
  ```
  Check the wiki pages for more on [build](https://github.com/intel-hadoop/gearpump/wiki#build) and [running examples] in local modes](https://github.com/intel-hadoop/gearpump/wiki#how-to-run-gearpump).