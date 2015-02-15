# Build

## How to Build Gearpump
  ```bash
  ## Build Gearpump
  sbt clean publishLocal assembly packArchive
  ```

  This will generate package folder under target/pack/

##How to test
  ```bash
  ## Build Gearpump
  sbt test
  ```

## How to Package for distribution

  ```bash
  ## Package Gearpump
  sbt assembly clean packArchive
  ```
  This will produce `target/gearpump-$VERSION.tar.gz` which contains the `./bin` and `./lib` files.

## How to Install to /usr/local
  ```bash
  ## Run Build step above
  cd target/pack
  sudo make install PREFIX="/usr/local"
  ```
  This will install scripts to run local, master or shell to `/usr/local/bin` and jars to `/usr/local/lib`.

# How to Run Gearpump

## Local Mode

1. Start Local Cluster in same process
  ```bash
  ## By default, it will create 4 workers
  ./target/pack/bin/local -port 3000
  ```

2. Start an Example

   * Run WordCount example
  ```bash
  ./target/pack/bin/gear app -jar ./examples/wordcount/target/scala-${SCALA_VERSION_MAJOR}/gearpump-examples-wordcount_${SCALA_VERSION_MAJOR}-${VERSION}.jar org.apache.gearpump.streaming.examples.wordcount.WordCount -master 127.0.0.1:3000
  ```

  * Run SOL example
  ```bash
  ./target/pack/bin/gear app -jar ./examples/sol/target/scala-${SCALA_VERSION_MAJOR}/gearpump-examples-sol_${SCALA_VERSION_MAJOR}-${VERSION}.jar org.apache.gearpump.streaming.examples.sol.SOL -master 127.0.0.1:3000
  ```

  * Run complexdag example
  ```bash
  ./target/pack/bin/gear app -jar ./examples/complexdag/target/scala-${SCALA_VERSION_MAJOR}/gearpump-examples-complexdag_${SCALA_VERSION_MAJOR}-${VERSION}.jar org.apache.gearpump.streaming.examples.complexdag.Dag -master 127.0.0.1:3000
  ```

  * [Run Fsio example](https://github.com/intel-hadoop/gearpump/tree/master/examples/fsio)

  * [Run KafkaWordCount example](https://github.com/intel-hadoop/gearpump/blob/master/examples/kafka/README.md)

## Cluster Mode

1. Distribute the package to all nodes. Modify `conf/gear.conf` on all nodes. You MUST configure `akka.remote.netty.tcp.hostname` to make it point to your hostname(or ip), and `gearpump.cluster.masters` to represent a list of master nodes.

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

2. Start Master nodes
 
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

  We support [Master HA](https://github.com/intel-hadoop/gearpump/wiki/Run-Examples#master-ha) and allow master to start on multiple nodes. 

3. Start worker

  Start multiple workers on one or more nodes. 
 
  ```bash
  bin/worker
  ```

4. Submit application jar and run

  You can submit your application to cluster by providing an application jar. For example, for built-in examples, the jar is located at `examples/gearpump-examples-assembly-$VERSION.jar`

  ```bash
  ## To run WordCount example
  bin/gear app -jar examples/gearpump-examples-assembly-$VERSION.jar org.apache.gearpump.streaming.examples.wordcount.WordCount -master node1:3000
  ```
