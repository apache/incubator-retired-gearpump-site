GearPump is a lightweight, real-time, big data streaming engine. It is inspired by recent advances in the Akka framework and a desire to improve on existing streaming frameworks. GearPump draws from a number of existing frameworks including MillWheel, Apache Storm, Spark Streaming, Apache Samza, Apache Tez, and Hadoop YARN while leveraging Akka actors throughout its architecture.

Many of the information in this page can also be found at the technical whitepaper:
[https://typesafe.com/blog/gearpump-real-time-streaming-engine-using-akka](https://typesafe.com/blog/gearpump-real-time-streaming-engine-using-akka)

# DAG

An application is a DAG of processors. Each processor handles messages.

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/dag.png)

At runtime, each processor can be parallelized to a list of tasks; each task is an actor within the data pipeline. Data is passed between tasks. The Partitioner defines how data is transferred.

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/shuffle.png)

We have an easy syntax to express the computation. To represent the DAG above, we define the computation as:

   ```
   Graph(A~>B~>C~>D, A~> C, B~>E~>D)
   ```

`A~>B~>C~>D` is a Path of Processors, and Graph is composed of this Path list. This representation should be cleaner than that of vertex and edge set.


# Gearpump Hierarchy

GearPump models streaming within the Akka actory hierarchy.

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/actor_hierarchy.png)

Everything in the above diagram is an actor. The Actors fall into two categories, Cluster Actors and Application Actors.

###Cluster Actors

* Worker: Maps to a physical worker machine. It is responsible for managing resources and reporting metrics on that machine.

* Master: Heart of the cluster, which manages workers, resources, and applications. The main function is delegated to three child actors: App Manager, Worker Manager, and Resource Scheduler.

###Application Actors

* AppMaster: Responsible for scheduling the tasks to workers and managing the state of the application. Different applications have different AppMaster instances and are isolated.

* Executor: Child of AppMaster, represents a JVM process. Its job is to manage the lifecycle of tasks and recover them in case of failure.

* Task: Child of Executor, does the real job. Every task actor has a global unique address. One task actor can send data to any other task actors. This gives us great flexibility of how the computation DAG is distributed.

All actors in the graph are woven together with actor supervision; actor watching and all errors are handled properly via supervisors. In a master, a risky job is isolated and delegated to child actors, so it¡¯s more robust. In the application, an extra intermediate layer, ¡°Executor,¡± is created so that we can do fine-grained and fast recovery in case of task failure. A master watches the lifecycle of AppMaster and Worker to handle the failures, but the lifecycle of Worker and AppMaster are not bound to a Master Actor by supervision, so that Master node can fail independently. Several Master Actors form an Akka cluster, the Master state is exchanged using the Gossip protocol in a conflict-free consistent way so that there is no single point of failure. With this hierarchy design, we are able to achieve high availability.
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

# Master HA

We allow to start master on multiple nodes. For example, if we start master on 5 nodes, then we can at most tolerate 2 master nodes failure. 

1. modify `core/src/main/resources/reference.conf` and set "gearpump.cluster.masters" to a list of master nodes.

  ```
  gearpump {
   ...
  cluster {
    masters = ["node1:3000", "node2:3000", "node3:3000"]
  }
  }
  ```

2. On node1, node2, node3, Start Master
  ```bash
  ## on node1
  bin/master -ip node1 -port 3000
  
  ## on node2
  bin/master -ip node2 -port 3000
  
  ## on node3
  bin/master -ip node3 -port 3000
  ```  

3. You can kill any node, the master HA will take effect. It can take up to 15 seconds for master node to fail-over. You can change the fail-over timeout time by setting `master.akka.cluster.auto-down-unreachable-after`

# How to Write your own Gearpump Application

We'll use [wordcount](https://github.com/intel-hadoop/gearpump/tree/master/examples/wordcount/src/main/scala/org/apache/gearpump/streaming/examples/wordcount) as an example to illustrate how to write GearPump applications.

An application is a Directed Acyclic Graph (DAG) of processors (Please refer to [DAG API](https://github.com/intel-hadoop/gearpump/wiki/DAG-API)) . In the wordcount example, We will firstly define two processors `Split` and `Sum`, and then weave them together. 

###Split processor

In the Split processor, we simply split a predefined text (the content is simplified for conciseness) and send out each split word to Sum.

```scala
class Split(taskContext : TaskContext, conf: UserConfig) extends TaskActor(taskContext, conf) {

  override def onStart(startTime : StartTime) : Unit = {
    self ! Message("start")
  }

  override def onNext(msg : Message) : Unit = {
    Split.TEXT_TO_SPLIT.lines.foreach { line =>
      line.split(" ").foreach { msg =>
        output(new Message(msg, System.currentTimeMillis()))
      }
    }
    self ! Message("continue", System.currentTimeMillis())
  }
}

object Split {
  val TEXT_TO_SPLIT = "some text"
}
```

Like Split, every processor extends a `TaskActor`.  The `onStart` method is called once before any message comes in; `onNext` method is called to process every incoming message. Note that GearPump employs the message-driven model and that's why Split sends itself a message at the end of `onStart` and `onNext` to trigger next message processing.

###Sum Processor

The structure of Sum processor looks much alike. Sum does not need to send messages to itself since it receives messages from Split. 

```scala
class Sum (taskContext : TaskContext, conf: UserConfig) extends TaskActor(taskContext, conf) {
  import org.apache.gearpump.streaming.ConfigsHelper._

  private val map : mutable.HashMap[String, Long] = new mutable.HashMap[String, Long]()

  private var wordCount : Long = 0
  private var snapShotTime : Long = System.currentTimeMillis()
  private var snapShotWordCount : Long = 0

  private var scheduler : Cancellable = null

  override def onStart(startTime : StartTime) : Unit = {
    import context.dispatcher
    scheduler = context.system.scheduler.schedule(new FiniteDuration(5, TimeUnit.SECONDS),
      new FiniteDuration(5, TimeUnit.SECONDS))(reportWordCount)
  }

  override def onNext(msg : Message) : Unit = {
    if (null == msg) {
      return
    }
    val current = map.getOrElse(msg.msg.asInstanceOf[String], 0L)
    wordCount += 1
    map.put(msg.msg.asInstanceOf[String], current + 1)
  }

  override def onStop() : Unit = {
    scheduler.cancel()
  }

  def reportWordCount() : Unit = {
    val current : Long = System.currentTimeMillis()
    LOG.info(s"Task ${taskContext.taskId} Throughput: ${(wordCount - snapShotWordCount, (current - snapShotTime) / 1000)} (words, second)")
    snapShotWordCount = wordCount
    snapShotTime = current
  }
}
```

Besides counting the sum, we also define a scheduler to report throughput every 5 seconds. The scheduler should be cancelled when the computation completes, which could be accomplished overriding the `onStop` method. The default implementation of `onStop` is a no-op.

###Partitioner

A processor could be parallelized to a list of tasks. A `Partitioner` defines how the data is shuffled among tasks of Split and Sum. GearPump has already provided two partitioners 

* `HashPartitioner`: partitions data based on the message's hashcode
* `ShufflePartitioner`: partitions data in a round-robin way.

You could define your own partitioner by extending the `Partitioner` trait and overriding the `getPartition` method.

```scala
trait Partitioner extends Serializable {
  def getPartition(msg : Message, partitionNum : Int) : Int
}
```

###Weave together

Now, we are able to write our application class, weaving the above components together.

The application class extends `App` and `ArgumentsParser which make it easier to parse arguments and run main functions.

```scala
object WordCount extends App with ArgumentsParser {
  private val LOG: Logger = LogUtil.getLogger(getClass)
  val RUN_FOR_EVER = -1

  override val options: Array[(String, CLIOption[Any])] = Array(
    "master" -> CLIOption[String]("<host1:port1,host2:port2,host3:port3>", required = true),
    "split" -> CLIOption[Int]("<how many split tasks>", required = false, defaultValue = Some(4)),
    "sum" -> CLIOption[Int]("<how many sum tasks>", required = false, defaultValue = Some(4)),
    "runseconds"-> CLIOption[Int]("<how long to run this example, set to -1 if run forever>", required = false, defaultValue = Some(60))
  )

  def application(config: ParseResult) : AppDescription = {
    val splitNum = config.getInt("split")
    val sumNum = config.getInt("sum")
    val partitioner = new HashPartitioner()
    val split = TaskDescription(classOf[Split].getName, splitNum)
    val sum = TaskDescription(classOf[Sum].getName, sumNum)
    val app = AppDescription("wordCount", classOf[AppMaster].getName, UserConfig.empty, Graph(split ~ partitioner ~> sum))
    app
  }

  val config = parse(args)
  val context = ClientContext(config.getString("master"))
  val appId = context.submit(application(config))
  Thread.sleep(config.getInt("runseconds") * 1000)
  context.shutdown(appId)
  context.close()
}
```

We override `options` value and define an array of command line arguments to parse. We want application users to pass in masters' hosts and ports, the parallelism of split and sum tasks, and how long to run the example. We also specify whether an option is `required` and provide `defaultValue` for some arguments.

Given the `ParseResult` of command line arguments, we create `TaskDescription`s for Split and Sum processors, and connect them with `HashPartitioner` using DAG API. The graph is wrapped in an `AppDescrition` , which is finally submit to master.

# Metrics

We use codahale metrics library. Gearpump support to use Graphite to visualize the metrics data. Metrics is disabled by default. To use it, you need to configure the `core/src/main/resources/reference.conf`

  ```
  gearpump.metrics.enabled = true         ## Default is false, thus metrics is not enabled.
  gearpump.metrics.graphite.host = "your actual graphite host name or ip"  
  gearpump.metrics.graphite.port = 2003   ## Your graphite port
  gearpump.metrics.sample.rate = 10       ## this means we will sample 1 message for every 10 messages
  ```
  
For guide about how to install and configure Graphite, please check the Graphite website http://graphite.wikidot.com/.	For guide about how to use Grafana, please check guide in [doc/dashboard/README.md](doc/dashboard/README.md)

Here is how it looks like for grafana dashboard:

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/dashboard.png)

# Serialization

We use library [kryo](https://github.com/EsotericSoftware/kryo) and [akka-kryo library](https://github.com/romix/akka-kryo-serialization). If you have cutomized the Message, you need to define the serializer explicitly.

The configuration for serialization is in gear.conf:

```
gearpump {
  serializers {
    "org.apache.gearpump.Message" = "org.apache.gearpump.streaming.MessageSerializer"
    "org.apache.gearpump.streaming.task.AckRequest" = "org.apache.gearpump.streaming.AckRequestSerializer"
    "org.apache.gearpump.streaming.task.Ack" = "org.apache.gearpump.streaming.AckSerializer"

    ## Use default serializer for this type
    "scala.Tuple2" = ""
  }
}
```

akka-kryo-serialization has built-in support for many data types.

```

# gearpump types
Message
AckRequest
Ack

# akka types
akka.actor.ActorRef

# scala types
scala.Enumeration#Value
scala.collection.mutable.Map[_, _]
scala.collection.immutable.SortedMap[_, _]
scala.collection.immutable.Map[_, _]
scala.collection.immutable.SortedSet[_]
scala.collection.immutable.Set[_]
scala.collection.mutable.SortedSet[_]
scala.collection.mutable.Set[_]
scala.collection.generic.MapFactory[scala.collection.Map]
scala.collection.generic.SetFactory[scala.collection.Set]
scala.collection.Traversable[_]
Tuple2
Tuple3


# java complex types
byte[]
char[]
short[]
int[]
long[]
float[]
double[]
boolean[]
String[]
Object[]
BigInteger
BigDecimal
Class
Date
Enum
EnumSet
Currency
StringBuffer
StringBuilder
TreeSet
Collection
TreeMap
Map
TimeZone
Calendar
Locale

## Primitive types
int
String
float
boolean
byte
char
short
long
double
void
```

# Benchmark

## How do we do benchmark?

1. Set up a node running Graphite, see guide doc/dashboard/README.md. 

2. Set up a 4-nodes Gearpump cluster with 10GbE network which have 3 Workers on each node. In our test environment, each node has 128GB memory and Intel? Xeon? 32-core processor E5-2680 2.70GHz. Make sure the metrics is enabled in Gearpump, check [guide](https://github.com/intel-hadoop/gearpump/wiki/Metrics-and-Dashboard)

3. Submit a SOL application with 32 SteamProducers and 32 StreamProcessors:
  ```bash
  bin/gear app -jar ./examples/sol/target/pack/lib/gearpump-examples-$VERSION.jar org.apache.gearpump.streaming.examples.sol.SOL -master $HOST:PORT -streamProducer 32 -streamProcessor 32 -runseconds 600
  ```

4. Browser http://$HOST:801/, you should see a grafana dashboard. The HOST should be the node runs Graphite.

5. Copy the config file doc/dashboard/graphana_dashboard, and modify the `host` filed to the actual hosts which runs Gearpump and the `source` and `target` fields. Please note that the format of the value should exactly the same as existing format and you also need to manually add the rest task ID to the value of `All` under `source` and `target` filed since now the number of each task type is 32.

6. In the Grafana web page, click the "search" button and then import the config file mentioned above.

# Maven dependencies

## Snapshot package

The snapshot contains the latest code in master branch.

Latest version: 0.2.4-SNAPSHOT

**Note:** There maybe delay in updating this document, you can still find the snapshot version by checking https://github.com/intel-hadoop/gearpump/blob/master/version.sbt

```xml
<repositories>
<repository>
  <id>sonatype-nexus-releases</id>
  <name>Sonatype Nexus Snapshots</name>
  <url>https://oss.sonatype.org/content/repositories/snapshots</url>
</repository>
</repositories>

<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.2.4-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.2.4-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-rest_2.11</artifactId>
<version>0.2.4-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-external-kafka_2.11</artifactId>
<version>0.2.4-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-experiments-distributedshell_2.11</artifactId>
<version>0.2.4-SNAPSHOT</version>
</dependency>
</dependencies>
```

## Release package

This contains latest release. 
**Note:** There maybe delay in updating this document, you can still find the latest stable version by checking https://github.com/intel-hadoop/gearpump/releases .

Latest version: 0.2.3

```xml
<repositories>
<repository>
<id>releases-oss.sonatype.org</id>
<name>Sonatype Releases Repository</name>
<url>http://oss.sonatype.org/content/repositories/releases/</url>
</repository>
</repositories>
<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-rest_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-external-kafka_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-experiments-distributedshell_2.11</artifactId>
<version>0.2.3</version>
</dependency>
</dependencies>
```

# FAQ

Q: Why we name it GearPump

A: The name GearPump is a reference the engineering term ¡°Gear Pump¡±, which is a super simple pump that consists of only two gears, but is very powerful at streaming water from left to right.