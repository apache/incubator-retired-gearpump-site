# User Guide 0.6

For API specification, please check [Scala Doc](http://gearpump.io/api/0.6/index.html).

## Introduction

### What is Gearpump

GearPump is a real-time big data streaming engine using Akka, it can also be used as an underlying platform for other general distributed applications, like a distributed cron job or a distributed log collection. 

Gearpump is inspired by recent advances in the Akka framework and a desire to improve on existing streaming frameworks. Gearpump draws from a number of existing frameworks including MillWheel , Apache Storm , Spark Streaming , Apache Samza , Apache Tez and Hadoop YARN  while leveraging Akka actors throughout its architecture.

![](/img/logo2.png)
 
The name Gearpump is a reference to the engineering term "gear pump," which is a simple water pump that consists of only two gears. We use this name to indicate this engine is "super simple and powerful".

### Technical highlights of Gearpump


Gearpump is a performant, flexible, fault-tolerant, and responsive streaming platform with a lot of nice features, its technical highlights include:

#### Actors everywhere

The Actor model is a concurrency model proposed by Carl Hewitt at 1973. The Actor model is like a micro-service which is cohesive in the inside and isolated from other outside actors. Actors are the cornerstone of Gearpump, they provide facilities to do message passing, error handling, liveliness monitoring. Gearpump uses Actors everywhere; every entity within the cluster that can be treated as a service.

![](/img/actor_hierarchy.png)
 
#### Exactly once Message Processing

Exactly once is defined as: the effect of a message will be calculated only once in the persisted state and computation errors in the history will not be propagated to future computations.

![](/img/exact.png)

#### Topology DAG DSL

User can submit to Gearpump a computation DAG, which contains a list of nodes and edges, and each node can be parallelized to a set of tasks. Gearpump will then schedule and distribute different tasks in the DAG to different machines automatically. Each task will be started as an actor, which is long running micro-service. 

![](/img/dag.png)

#### Flow control

Gearpump has built-in support for flow control. For all message passing between different tasks, the framework will assure the upstream tasks will not flood the downstream tasks. 
![](/img/flowcontrol.png)

#### No inherent end to end latency

Gearpump is a message level streaming engine, which means every task in the DAG will process messages immediately upon receiving, and deliver messages to downstream immediately without waiting. Gearpump doesn't do batching when data sourcing.

#### High Performance message passing

By implementing smart batching strategies, Gearpump is extremely effective in transferring small messages. In one test of 4 machines, the whole cluster throughput can reach 11 million messages per second, with message size of 100 bytes.
![](/img/dashboard.png)

#### High availability, No single point of failure

Gearpump has a careful design for high availability. We have considered message loss, worker machine crash, application crash, master crash, brain-split, and have made sure Gearpump recovers when there errors happen. When there is message loss, lost message will be replayed; when there is worker machine crash or application crash, computation tasks will be rescheduled to new machines. For master high availability, several master nodes will form a Akka cluster, and CRDT (conflict free data type) is used to exchange the state, so as long as there is still a quorum, the master will stay functional. When one master node crash, other master nodes in the cluster will take over and state will be recovered. 

![](/img/ha.png)

#### Dynamic Computation DAG 

GearPump provides a feature which allows the user to dynamically add, remove, or replace a sub graph at runtime, without the need to restart the whole computation topology.

![](/img/dynamic.png)

#### Able to handle out of order messages

For a window operation like moving average on a sliding window, it is important to make sure we have received all messages in that time window so that we can get an accurate result, but how do we handle stranglers or late arriving messages? GearPump solves this problem by tracking the low watermark of timestamp of all messages, so it knows whether we've received all the messages in the time window or not.

![](/img/clock.png)

#### Customizable platform

Different applications have different requirements related to performance metrics, some may want higher throughput, some may require strong eventual data consistency; and different applications have different resource requirements profiles, some may demand high CPU performance, some may require data locality. Gearpump meets these requirements by allowing the user to arbitrate between different performance metrics and define customized resource scheduling strategies. 

#### Built-in Dashboard UI

Gearpump has a built-in dashboard UI to manage the cluster and visualize the applications. The UI uses REST call to connect with backend, so it is easy to embed the UI within other dashboards.

![](/img/dashboard.gif)

#### Data connectors for Kafka and HDFS

Gearpump has built-in data connectors for Kafka and HDFS. For the Kafka connector, we support message replay from a specified timestamp.

### What is a good use case for Gearpump?


We considered Gearpump suitable for your application:

##### 1.  when you are a Scala guru and want to do streaming in Scala, or

##### 2.  when you already use Akka to do streaming, and want more data consistency, performance, and manageability, or

##### 3.  when you have IOT(internet of things) requirements and want to collect data from IOT, or deploy computation to edge devices transparently, or

##### 4.  when you have large in-memory data to maintain and want long running daemons for streaming, or

##### 5.  when you have exactly once message processing requirements but still need low latency, or

##### 6.  when you want to dynamically swap-in/swap-out certain sub-DAGs on a running topology, or

##### 7.  when you require real time streaming with max throughput without worrying about flow control or out of memory error, or

##### 8.  you want to try something new and cool :)

### Relation with YARN
 
Gearpump can run on top of YARN as a YARN application. Gearpump's ApplicationMaster provides the application management , deployment and scheduling of DAG's after arbitrating and receiving container resources from YARN

### Relation with Storm and Spark Streaming

Storm and spark streaming are proven platforms, there are many production deployments. Compared with them, Gearpump is not than proven and there is no production deployment yet. However, there is no single platform that can cover every use case; Gearpump has its own +1 points in some special fields. As an instance, for IOT use cases, Gearpump may be considered convenient because the topology can be deployed to edge device with feature of location transparency. For another example, when users want to upgrade the application online without service interruption, Gearpump may be suitable as it can dynamically modify the computation DAG on the fly. For other special use cases that are suitable for Gearpump, please check section [What is a good use case for Gearpump](0.6/userguide/#what-is-a-good-use-case-for-gearpump)


## Get Started

### Prepare the binary
You can either download pre-build release package or choose to build from source code. 

#### Download Release Binary

If you choose to use pre-build package, then you don't need to build from source code. The release package can be downloaded from: 

##### [http://www.gearpump.io/site/downloads/](downloads/)

#### Build from Source code

If you choose to build the package from source code yourself, you can follow these steps:
  
1). Clone the GearPump repository

```bash
  git clone https://github.com/gearpump/gearpump.git
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
  
```bash
  export JAVA_HOME={path/to/jdk/root/path}
```
  
  On Windows:
  
```bash
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

### Gearpump package structure

You need to flatten the .tar.gz file to use it, on Linux, you can

```bash
## please replace ${version} below with actual version used
tar  -zxvf gearpump-${version}.tar.gz
```

After decompression, the directory structure looks like picture 1.

![](/img/layout.png)
  
Under bin/ folder, there are script files for Linux(bash script) and Windows(.bat script). 

script | function
--------|------------
local | You can start the Gearpump cluster in single JVM(local mode), or in a distributed cluster(cluster mode). To start the cluster in local mode, you can use the local /local.bat helper scripts, it is very useful for developing or troubleshooting. 
master | To start Gearpump in cluster mode, you need to start one or more master nodes, which represent the global resource management center. master/master.bat is launcher script to boot the master node. 
worker | To start Gearpump in cluster mode, you also need to start several workers, with each worker represent a set of local resources. worker/worker.bat is launcher script to start the worker node. 
services | This script is used to start backend REST service and other services for frontend UI dashboard. 

Please check [Command Line Syntax](#command-line-syntax) for more information for each script.

### Run a distributed application in 30 seconds.

To start a demo application, there are three steps,
 
#### Step1: Start the cluster

You can start a local mode cluster in single line

```bash
## start the master and 4 workers in single JVM. The master will listen on 3000
## you can Ctrl+C to kill the local cluster after you finished the startup tutorial. 
bin/local
```

**NOTE:** You can change the default port by changing config "gearpump.cluster.masters" in conf/gear.conf, 

**NOTE: Change the working directory**. Log files by default will be generated under current working directory. So, please "cd" to required working directly before running the shell commands.

**NOTE: Run as Daemon**. You can run it as a background process. For example, use [nohup](http://linux.die.net/man/1/nohup) on linux. 

#### Step2: Submit application
After the cluster is started, you can submit an example wordcount application to the cluster

Open another shell, 

```bash
### To run WordCount example, please substitute $VERSION with actual file version.
bin/gear app -jar examples/gearpump-examples-assembly-$VERSION.jar io.gearpump.streaming.examples.wordcount.WordCount
```

#### Step3: Open the UI and view the status

Now, the application is running, start the UI and check the status:

Open another shell, 

```bash
bin/services
```
You can manage the application in UI [http://127.0.0.1:8090](http://127.0.0.1:8090) or by [Command Line tool](#command-line-syntax).

![](/img/dashboard.gif)

**NOTE:** the UI port setting can be defined in configuration, please check section [Configuration Guide](#configuration-guide)
You see, now it is up and running. 

#### Step4: Congratulation! You have your first application running! 

### Other Application Examples

Besides wordcount, there are several other example applications. Please check the source tree examples/ for detail information.


## Concepts

### System timestamp and Application timestamp

System timestamp denotes the time of backend cluster system. Application timestamp denotes the time at which message is generated. For example, for IOT edge device, the timestamp at which field sensor device creates a message is type of application timestamp, while the timestamp at which that message get received by the backend is type of system time.

### Master, and Worker

Gearpump follow master slave architecture. Every cluster contains one or more Master node, and several worker nodes. Worker node is responsible to manage local resources on single machine, and Master node is responsible to manage global resources of the whole cluster.

![](/img/actor_hierarchy.png)

### Application

Application is what we want to parallel and run on the cluster. There are different application types, for example MapReduce application and streaming application are different application types. Gearpump natively supports Streaming Application types, it also contains several templates to help user to create custom application types, like distributedShell. 

### AppMaster and Executor

In runtime, every application instance is represented by single AppMaster and a list of Executors. AppMaster represent the command and control center of the Application instance, it communicate with user, master, worker, and executor to get the job done. Each executor is a parallel unit for distributed application. Typically AppMaster and Executor will be started as JVM processes on worker nodes. 

### Application Submission Flow

When user submits an application to Master, Master will first find an available worker to start the AppMaster. After AppMaster is started, AppMaster will request Master for more resources (worker) to start executors. The Executor now is only an empty container, after the executors are started, the AppMaster will then distribute real computation tasks to the executor and run them in parallel way.

To submit an application, a Gearpump client specifies a computation defined within a DAG and submits this to an active master. The SubmitApplication message is sent to the Master who then forwards this to an AppManager.

![](/img/submit.png) 
Figure: User Submit Application

The AppManager locates an available worker and launches an AppMaster in a sub-process JVM of the worker. The AppMaster will then negotiate with the Master for Resource allocation in order to distribute the DAG as defined within the Application. The allocated workers will then launch Executors (new JVMs).

![](/img/submit2.png) 
Figure: Launch Executors and Tasks

### Streaming Topology, Processor, and Task

For streaming application type, each application contains a topology, which is a DAG (directed acyclic graph) to describe the data flow. Each node in the DAG is a processor. For example, for word count it contains two processors, Split and Sum. The Split processor splits a line to a list of words, then the Sum processor summarize the frequency of each word. 
An application is a DAG of processors. Each processor handles messages. 
 
![](/img/dag.png)
Figure: Processor DAG

### Streaming Task and Partitioner

For streaming application type, Task is the minimum unit of parallelism. In runtime, each Processor is paralleled to a list of tasks, with different tasks running in different executor. You can define Partitioner to denote the data shuffling rule between upstream processor tasks and downstream processor tasks. 

![](/img/shuffle.png)
Figure: Task Data Shuffling

## Admin Guide

### Pre-requisite

Gearpump cluster can be installed on Windows OS and Linux.
Before installation, you need to decide how many machines are used to run this cluster. For each machine, the requirements are listed in table below.

**  Table: Environment requirement on single machine**

Resource | Requirements
------------ | ---------------------------
Memory       | 2GB free memory is required to run the cluster
Java	       | JRE 6 or above
User permission | Root permission is not required
Network	Ethernet |(TCP/IP)
CPU	| Nothing special
HDFS installation	| Default is not required. You only need to install it when you want to store the application jars in HDFS.
Kafka installation |	Default is not required. You need to install Kafka when you want the at-least once message delivery feature. Currently, the only supported data source for this feature is Kafka 
	
**  Table: The default port used in Gearpump:**

| usage	| Port |	Description |
------------ | ---------------|------------
  Dashboard UI	| 8090	| Web UI. 
Dashboard web socket service |	8091 |	UI backend web socket service for long connection.
Master port |	3000 |	Every other role like worker, appmaster, executor, user use this port to communicate with Master.

### How to Install


The installation package can be downloaded from [Download Address](/downloads/). You are suggested to unzip the package to same directory path on every machine you planned to install Gearpump.
To install Gearpump, you at least need to change the configuration in conf/gear.conf. 

Config	| Default value	| Description	
------------ | ---------------|------------
base.akka.remote.netty.tcp.hostname	| 127.0.0.1	 | Host or IP address of current machine. The ip/host need to be reachable from other machines in the cluster.	
Gearpump.cluster.masters |	["127.0.0.1:3000"] |	List of all master nodes, with each item represents host and port of one master. 
gearpump.worker.slots	 | 100 | how many slots this worker has
		
Besides this, there are other optional configurations related with logs, metrics, transports, ui. You can refer to [Configuration Guide](#configuration-guide) for more details.

### Start the Cluster Daemons

Gearpump can be started in single JVM, single machine, or a cluster of machines.

#### Local Mode

In local mode, master node and worker node will be started in single JVM. 

For example:
```bash
bin/local
```

**NOTE**: on Linux, you can use "nohup command &" to start command as background process.

**NOTE**: on windows: use local.bat instead.

#### Distributed Mode

In distributed mode, you can start master and worker in different JVM. 

##### To start master:
```bash
bin/master -ip xx -port xx
```

The ip and port will be checked against setting under conf/gear.conf, so you need to make sure they are consistent with settings in gear.conf.

**NOTE**: for high availability, please check [Master HA Guide](#master-ha-guide)

##### To start worker: 
```bash
bin/worker
```

### Start UI

```bash
bin/services
```

After UI is started, you can browser http://127.0.0.1:8090 to view the cluster status.

![](/img/dashboard.gif)

**NOTE:** The UI port can be configured in gear.conf. Check [Configuration Guide](#configuration-guide) for information.

### Submit an new Application

You can use command bin/gear app to submit To check the syntax:

```bash
bin/gear app -jar xx.jar MainClass <arg1> <arg2> ...
```

### Manage the applications

After the application is started, you can view the status of application in UI. In the UI, you can allowed to shutdown the application. 

![](/img/dashboard_3.png)

**NOTE**: Besides UI, there is also command line tools to manage the application, please check [Command line tools](#command-line-syntax) for information.

### Security

Every application have a submitter user. We will separate the application from different user, like different log folder for different applications. However, for now there is no authentication or authorization in place to protect against unauthorized access. 


## Streaming Application Developer Guide

We'll use [wordcount](https://github.com/gearpump/gearpump/blob/master/examples/streaming/wordcount/src/main/scala/io/gearpump/streaming/examples/wordcount/) as an example to illustrate how to write GearPump applications.

### Maven/Sbt Settings

Repository and library dependencies can be found at [Maven Setting](/downloads/#maven)

### For java developer

Most contents in this guide also apply for Java developer. There is a template java project at [Java WordCount Project](https://github.com/gearpump/gearpump-java-example)

### Define Processor(Task) class and Partitioner class

An application is a Directed Acyclic Graph (DAG) of processors. In the wordcount example, We will firstly define two processors `Split` and `Sum`, and then weave them together. 

#### About message type

User are allowed to send message of type AnyRef(map to Object in java). 
```
case class Message(msg: AnyRef, timestamp: TimeStamp = Message.noTimeStamp)
```

If user want to send primitive types like Int, Long, then he should box it explicitly with asInstanceOf. For example:
```
new Message(3.asInstanceOf[AnyRef])
```

#### Split processor

In the Split processor, we simply split a predefined text (the content is simplified for conciseness) and send out each split word to Sum.

Scala:
```scala
class Split(taskContext : TaskContext, conf: UserConfig) extends Task(taskContext, conf) {
  import taskContext.output

  override def onStart(startTime : StartTime) : Unit = {
    self ! Message("start")
  }

  override def onNext(msg : Message) : Unit = {
    Split.TEXT_TO_SPLIT.lines.foreach { line =>
      line.split("[\\s]+").filter(_.nonEmpty).foreach { msg =>
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

#### Sum Processor

The structure of Sum processor looks much alike. Sum does not need to send messages to itself since it receives messages from Split. 

Scala:
```scala
class Sum (taskContext : TaskContext, conf: UserConfig) extends Task(taskContext, conf) {
  private[wordcount] val map : mutable.HashMap[String, Long] = new mutable.HashMap[String, Long]()

  private[wordcount] var wordCount : Long = 0
  private var snapShotTime : Long = System.currentTimeMillis()
  private var snapShotWordCount : Long = 0

  private var scheduler : Cancellable = null

  override def onStart(startTime : StartTime) : Unit = {
    scheduler = taskContext.schedule(new FiniteDuration(5, TimeUnit.SECONDS),
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
    if (scheduler != null) {
      scheduler.cancel()
    }
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

#### Partitioner

A processor could be parallelized to a list of tasks. A `Partitioner` defines how the data is shuffled among tasks of Split and Sum. GearPump has already provided two partitioners 

* `HashPartitioner`: partitions data based on the message's hashcode
* `ShufflePartitioner`: partitions data in a round-robin way.

You could define your own partitioner by extending the `Partitioner` trait and overriding the `getPartition` method.

```scala
trait Partitioner extends Serializable {
  def getPartition(msg : Message, partitionNum : Int) : Int
}
```

### Define TaskDescription and AppDescription

Now, we are able to write our application class, weaving the above components together.

The application class extends `App` and `ArgumentsParser which make it easier to parse arguments and run main functions.

```scala
object WordCount extends App with ArgumentsParser {
  private val LOG: Logger = LogUtil.getLogger(getClass)
  val RUN_FOR_EVER = -1

  override val options: Array[(String, CLIOption[Any])] = Array(
    "split" -> CLIOption[Int]("<how many split tasks>", required = false, defaultValue = Some(1)),
    "sum" -> CLIOption[Int]("<how many sum tasks>", required = false, defaultValue = Some(1))
  )

  def application(config: ParseResult) : StreamApplication = {
    val splitNum = config.getInt("split")
    val sumNum = config.getInt("sum")
    val partitioner = new HashPartitioner()
    val split = Processor[Split](splitNum)
    val sum = Processor[Sum](sumNum)
    val app = StreamApplication("wordCount", Graph[Processor[_ <: Task], Partitioner](split ~ partitioner ~> sum), UserConfig.empty)
    app
  }

  val config = parse(args)
  val context = ClientContext()
  val appId = context.submit(application(config))
  context.close()
}

```

We override `options` value and define an array of command line arguments to parse. We want application users to pass in masters' hosts and ports, the parallelism of split and sum tasks, and how long to run the example. We also specify whether an option is `required` and provide `defaultValue` for some arguments.

Given the `ParseResult` of command line arguments, we create `TaskDescription`s for Split and Sum processors, and connect them with `HashPartitioner` using DAG API. The graph is wrapped in an `AppDescrition` , which is finally submit to master.

### Submit application

After all these, you need to package everything into a uber jar and submit the jar to Gearpump Cluster. Please check [Application submission tool](#gear-app) to command line tool syntax.

### Advanced topics

#### Define Custom Message Serializer

We use library [kryo](https://github.com/EsotericSoftware/kryo) and [akka-kryo library](https://github.com/romix/akka-kryo-serialization). If you have special Message type, you can choose to define your own serializer explicitly. If you have not defined your own custom serializer, the system will use Kryo to serialize it at best effort.

When you have determined that you want to define a custom serializer, you can do this in two ways.

##### System Level Serializer

If the serializer is widely used, you can define a global serializer which is avaiable to all applications(or worker or master) in the system.

###### Step1: you first need to develop a java library which contains the custom serializer class. here is an example:

```scala
class MessageSerializer extends Serializer[Message] {
  override def write(kryo: Kryo, output: Output, obj: Message) = {
    output.writeLong(obj.timestamp)
    kryo.writeClassAndObject(output, obj.msg)
  }

  override def read(kryo: Kryo, input: Input, typ: Class[Message]): Message = {
    var timeStamp = input.readLong()
    val msg = kryo.readClassAndObject(input)
    new Message(msg.asInstanceOf[java.io.Serializable], timeStamp)
  }
}
```

###### Step2: Distribute the libraries

Distribute the jar file to lib/ folder of every Gearpump installation in the cluster.

###### Step3: change gear.conf on every machine of the cluster:

```
gearpump {
  serializers {
    "io.gearpump.Message" = "your.serializer.class"
  }
}
```

##### All set!

#### Define Application level custom serializer
If all you want is to define an application level serializer, which is only visible to current application AppMaster and Executors(including tasks), you can follow a different approach.

###### Step1: Define your custom Serializer class

You should include the Serializer class in your application jar. Here is an example to define a custom serializer:

```scala
class MessageSerializer extends Serializer[Message] {
  override def write(kryo: Kryo, output: Output, obj: Message) = {
    output.writeLong(obj.timestamp)
    kryo.writeClassAndObject(output, obj.msg)
  }

  override def read(kryo: Kryo, input: Input, typ: Class[Message]): Message = {
    var timeStamp = input.readLong()
    val msg = kryo.readClassAndObject(input)
    new Message(msg.asInstanceOf[java.io.Serializable], timeStamp)
  }
}
```

###### Step2: Define a config file to include the custom serializer definition. For example, we can create a file called: myconf.conf


```
### content of myconf.conf
gearpump {
  serializers {
    "io.gearpump.Message" = "your.serializer.class"
  }
}
```

###### Step3: Add the conf into AppDescription

Let's take WordCount as an example:

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

    //=======================================
    // Attention!
    //=======================================
    val app = AppDescription("wordCount", UserConfig.empty, Graph(split ~ partitioner ~> sum),
      ClusterConfigSource("/path/to/myconf.conf"))
    
    app
  }

  val config = parse(args)
  val context = ClientContext(config.getString("master"))
  implicit val system = context.system
  val appId = context.submit(application(config))
  Thread.sleep(config.getInt("runseconds") * 1000)
  context.shutdown(appId)
  context.close()
}

```

Maybe you have noticed, we have add a custom config to the Application

```scala
//=======================================
    // Attention!
    //=======================================
    val app = AppDescription("wordCount", UserConfig.empty, Graph(split ~ partitioner ~> sum),
      ClusterConfigSource("/path/to/myconf.conf"))
```

###### Step4: All set!

#### Connect with Kafka

It is easy to use Kafka as data source, the major class is KafkaSource, here is an example to use it:

```scala
// Full source code can be found at: https://github.com/gearpump/gearpump/blob/master/examples/streaming/kafka/src/main/scala/io/gearpump/streaming/examples/kafka/KafkaStreamProducer.scala

class KafkaStreamProducer(taskContext : TaskContext, conf: UserConfig)
  extends Task(taskContext, conf) {

  ...

  // define a kafka source
  // Tutorial about how to set the kafkaConfig can be found at: https://github.com/gearpump/gearpump/tree/master/examples/streaming/kafka
  
  private val source: TimeReplayableSource = new KafkaSource(taskContext.appName, taskId, taskParallelism,
    kafkaConfig, msgDecoder)

    private var startTime: TimeStamp = 0L

  override def onStart(newStartTime: StartTime): Unit = {
    startTime = newStartTime.startTime
    LOG.info(s"start time $startTime")
    
    // set which timestamp to start reading messages
    // Consider there may be stale messages and not follow exact time order, 
    source.setStartTime(startTime)
    self ! Message("start", System.currentTimeMillis())

    }

  override def onNext(msg: Message): Unit = {

    // do the actual read. Filter message whose timestmap is smaller than startTime
    // in case there are some stale (out of order) message in the Kafka queue.
    source.pull(batchSize).foreach{msg => filter.filter(msg, startTime).map(output)}

    self ! Message("continue", System.currentTimeMillis())
  }

  override def onStop(): Unit = {
    LOG.info("closing kafka source...")

    // stop the kafka source
    source.close()
  }
}
```

A full example can be found at: [Kafka Example](https://github.com/gearpump/gearpump/tree/master/examples/streaming/kafka)


## Non-Streaming Application Developer Guide

We'll use [Distributed Shell](https://github.com/gearpump/gearpump/tree/master/examples/distributedshell/src/main/scala/io/gearpump/examples/distributedshell) as an example to illustrate how to do that.

What Distributed Shell do is that user send a shell command to the cluster and the command will the executed on each node, then the result will be return to user.

### Maven/Sbt Settings

Repository and library dependencies can be found at [Maven Setting](/downloads/#maven)


### Define Executor Class

```scala
class ShellExecutor(executorContext: ExecutorContext, userConf : UserConfig) extends Actor{
  import executorContext._

  override def receive: Receive = {
    case ShellCommand(command, args) =>
      val process = Try(s"$command $args" !!)
      val result = process match {
        case Success(msg) => msg
        case Failure(ex) => ex.getMessage
      }
      sender ! ShellCommandResult(executorId, result)
  }
}
```

So ShellExecutor just receive the ShellCommand and try to execute it and return the result to the sender, which is quite simple.

### Define AppMaster Class
For a non-streaming application, you have to write your own AppMaster.

Here is a typical user defined AppMaster, please note that some trivial codes are omitted.

```scala
class DistShellAppMaster(appContext : AppMasterContext, app : Application) extends ApplicationMaster {
  protected var currentExecutorId = 0

  override def preStart(): Unit = {
    ActorUtil.launchExecutorOnEachWorker(masterProxy, getExecutorJvmConfig, self)
  }

  override def receive: Receive = {
    case ExecutorSystemStarted(executorSystem) =>
      import executorSystem.{address, worker, resource => executorResource}
      val executorContext = ExecutorContext(currentExecutorId, worker.workerId, appId, self, executorResource)
      val executor = context.actorOf(Props(classOf[ShellExecutor], executorContext, app.userConfig)
          .withDeploy(Deploy(scope = RemoteScope(address))), currentExecutorId.toString)
      executorSystem.bindLifeCycleWith(executor)
      currentExecutorId += 1
    case StartExecutorSystemTimeout =>
      masterProxy ! ShutdownApplication(appId)
      context.stop(self)
    case msg: ShellCommand =>
      Future.fold(context.children.map(_ ? msg))(new ShellCommandResultAggregator) { (aggregator, response) =>
        aggregator.aggregate(response.asInstanceOf[ShellCommandResult])
      }.map(_.toString()) pipeTo sender
  }

  private def getExecutorJvmConfig: ExecutorSystemJvmConfig = {
    val config: Config = Option(app.clusterConfig).map(_.getConfig).getOrElse(ConfigFactory.empty())
    val jvmSetting = Util.resolveJvmSetting(config.withFallback(context.system.settings.config)).executor
    ExecutorSystemJvmConfig(jvmSetting.classPath, jvmSetting.vmargs,
      appJar, username, config)
  }
}
```

So when this DistShellAppMaster started, first it will request resources to launch one executor on each node, which is done in method `preStart`

Then the DistShellAppMaster's receive handler will handle the allocated resource to launch the `ShellExecutor` we want. If you want to write your application, you can just use this part of code. The only thing needed is replacing the Executor class.

There may be a situation that the resource allocation failed which will bring the message `StartExecutorSystemTimeout`, the normal pattern to handle that is just what we do: shut down the application.

The real application logic part is in `ShellCommand` message handler, which is specific to different applications. Here we distribute the shell command to each executor and aggregate the results to the client.

For method `getExecutorJvmConfig`, you can just use this part of code in your own application.

### Define Application
Now its time to launch the application.

```scala
object DistributedShell extends App with ArgumentsParser {
  private val LOG: Logger = LogUtil.getLogger(getClass)

  override val options: Array[(String, CLIOption[Any])] = Array.empty

  LOG.info(s"Distributed shell submitting application...")
  val context = ClientContext()
  val appId = context.submit(Application[DistShellAppMaster]("DistributedShell", UserConfig.empty))
  context.close()
  LOG.info(s"Distributed Shell Application started with appId $appId !")
}
```

The application class extends `App` and `ArgumentsParser which make it easier to parse arguments and run main functions. This part is similar to the streaming applications.

The main class DistributeShell will submit an Application to Master, whose AppMaster is DistShellAppMaster.

### Define an optional Client class

Now, we can define a Client class to talk with AppMaster to pass our commands to it.

```scala
object DistributedShellClient extends App with ArgumentsParser  {
  implicit val timeout = Constants.FUTURE_TIMEOUT
  import scala.concurrent.ExecutionContext.Implicits.global
  private val LOG: Logger = LoggerFactory.getLogger(getClass)

  override val options: Array[(String, CLIOption[Any])] = Array(
    "master" -> CLIOption[String]("<host1:port1,host2:port2,host3:port3>", required = true),
    "appid" -> CLIOption[Int]("<the distributed shell appid>", required = true),
    "command" -> CLIOption[String]("<shell command>", required = true),
    "args" -> CLIOption[String]("<shell arguments>", required = true)
  )

  val config = parse(args)
  val context = ClientContext(config.getString("master"))
  val appid = config.getInt("appid")
  val command = config.getString("command")
  val arguments = config.getString("args")
  val appMaster = context.resolveAppID(appid)
  (appMaster ? ShellCommand(command, arguments)).map { reslut =>
    LOG.info(s"Result: $reslut")
    context.close()
  }
}
```

In the DistributedShellClient, it will resolve the appid to the real appmaster(the applicaton id will be printed when launching DistributedShell).

Once we got the AppMaster, then we can send ShellCommand to it and wait for the result.

### Submit application

After all these, you need to package everything into a uber jar and submit the jar to Gearpump Cluster. Please check [Application submission tool](#gear-app) to command line tool syntax.

## Gearpump Internals

### Actor Hiearachy?
 
![](/img/actor_hierarchy.png) 

Everything in the diagram is an actor; they fall into two categories, Cluster Actors and Application Actors. 

#### Cluster Actors

  **Worker**: Maps to a physical worker machine. It is responsible for managing resources and report metrics on that machine.
  
  **Master**: Heart of the cluster, which manages workers, resources, and applications. The main function is delegated to three child actors, App Manager, Worker Manager, and Resource Scheduler. 

#### Application Actors:

  **AppMaster**: Responsible to schedule the tasks to workers and manage the state of the application. Different applications have different AppMaster instances and are isolated. 
  
  **Executor**: Child of AppMaster, represents a JVM process. Its job is to manage the life cycle of tasks and recover the tasks in case of failure. 
  
  **Task**: Child of Executor, does the real job. Every task actor has a global unique address. One task actor can send data to any other task actors. This gives us great flexibility of how the computation DAG is distributed.

  All actors in the graph are weaved together with actor supervision, and actor watching and every error is handled properly via supervisors. In a master, a risky job is isolated and delegated to child actors, so it's more robust. In the application, an extra intermediate layer "Executor" is created so that we can do fine-grained and fast recovery in case of task failure. A master watches the lifecycle of AppMaster and worker to handle the failures, but the life cycle of Worker and AppMaster are not bound to a Master Actor by supervision, so that Master node can fail independently.  Several Master Actors form an Akka cluster, the Master state is exchanged using the Gossip protocol in a conflict-free consistent way so that there is no single point of failure. With this hierarchy design, we are able to achieve high availability. 

### Application Clock and Global Clock Service

Global clock service will track the minimum time stamp of all pending messages in the system. Every task will update its own minimum-clock to global clock service; the minimum-clock of task is decided by the minimum of:

  - Minimum time stamp of all pending messages in the inbox. 
  - Minimum time stamp of all un-acked outgoing messages. When there is message loss, the minimum clock will not advance. 
  - Minimum clock of all task states. If the state is accumulated by a lot of input messages, then the clock value is decided by the oldest message's timestamp. The state clock will advance by doing snapshots to persistent storage or by fading out the effect of old messages.

![](/img/clock.png)

The global clock service will keep track of all task minimum clocks effectively and maintain a global view of minimum clock. The global minimum clock value is monotonically increasing; it means that all source messages before this clock value have been processed. If there is message loss or task crash, the global minimum clock will stop.

### How do we optimize the message passing performance?

For streaming application, message passing performance is extremely important. For example, one streaming platform may need to process millions of messages per second with millisecond level latency. High throughput and low latency is not that easy to achieve. There are a number of challenges:

#### First Challenge: Network is not efficient for small messages

In streaming, typical message size is very small, usually less than 100 bytes per message, like the floating car GPS data. But network efficiency is very bad when transferring small messages. As you can see in below diagram, when message size is 50 bytes, it can only use 20% bandwidth. How to improve the throughput?

![](/img/through_vs_message_size.png) 

#### Second Challenge: Message overhead is too big

For each message sent between two actors, it contains sender and receiver actor path. When sending over the wire, the overhead of this ActorPath is not trivial. For example, the below actor path takes more than 200 bytes. 

```javascript
akka.tcp://system1@192.168.1.53:51582/remote/akka.tcp/2120193a-e10b-474e-bccb-8ebc4b3a0247@192.168.1.53:48948/remote/akka.tcp/system2@192.168.1.54:43676/user/master/Worker1/app_0_executor_0/group_1_task_0#-768886794
```

#### How do we solve this?

We implement a custom Netty transportation layer with Akka extension. In the below diagram, Netty Client will translate ActorPath to TaskId, and Netty Server will translate it back. Only TaskId will be passed on wire, it is only about 10 bytes, the overhead is minimized. Different Netty Client Actors are isolated; they will not block each other.

![](/img/netty_transport.png)

For performance, effective batching is really the key! We group multiple messages to a single batch and send it on the wire. The batch size is not fixed; it is adjusted dynamically based on network status. If the network is available, we will flush pending messages immediately without waiting; otherwise we will put the message in a batch and trigger a timer to flush the batch later.

### How do we do flow Control?

Without flow control, one task can easily flood another task with too many messages, causing out of memory error. Typical flow control will use a TCP-like sliding window, so that source and target can run concurrently without blocking each other. 

![](/img/flow_control.png) 
Figure: Flow control, each task is "star" connected to input tasks and output tasks

The difficult part for our problem is that each task can have multiple input tasks and output tasks. The input and output must be geared together so that the back pressure can be properly propagated from downstream to upstream. The flow control also needs to consider failures, and it needs to be able to recover when there is message loss.
Another challenge is that the overhead of flow control messages can be big. If we ack every message, there will be huge amount of ack'd messages in the system, degrading streaming performance. The approach we adopted is to use explicit AckRequest message. The target tasks will only ack back when they receive the AckRequest message, and the source will only send AckRequest when it feels necessary. With this approach, we can largely reduce the overhead.

### How do we detect message loss?

For example, for web ads, we may charge for every click, we don't want to miscount.  The streaming platform needs to effectively track what messages have been lost, and recover as fast as possible.

![](/img/messageLoss.png) 
Figure: Message Loss Detection

We use the flow control message AckRequest and Ack to detect message loss. The target task will count how many messages has been received since last AckRequest, and ack the count back to source task. The source task will check the count and find message loss.
This is just an illustration, the real case is more difficulty, we need to handle zombie tasks, and in-the-fly stale messages.

### How Gearpump know what messages to replay?

In some applications, a message cannot be lost, and must be replayed. For example, during the money transfer, the bank will SMS us the verification code. If that message is lost, the system must replay it so that money transfer can continue. We made the decision to use **source end message storage** and **time stamp based replay**.

![](/img/replay.png) 
Figure: Replay with Source End Message Store

Every message is immutable, and tagged with a timestamp. We have an assumption that the timestamp is approximately incremental (allow small ratio message disorder). 

We assume the message is coming from a replay-able source, like Kafka queue; otherwise the message will be stored at customizable source end "message store". When the source task sends the message downstream, the timestamp and offset of the message is also check-pointed to offset-timestamp storage periodically. During recovery, the system will first retrieve the right time stamp and offset from the offset-timestamp storage, then it will replay the message store from that time stamp and offset. A Timestamp Filter will filter out old messages in case the message in message store is not strictly time-ordered. 

### Master High Availability

In a distributed streaming system, any part can fail. The system must stay responsive and do recovery in case of errors.
 
![](/img/ha.png) 
Figure: Master High Availability

We use Akka clustering to implement the Master high availability. The cluster consists of several master nodes, but no worker nodes. With clustering facilities, we can easily detect and handle the failure of master node crash. The master state is replicated on all master nodes with the Typesafe akka-data-replication  library, when one master node crashes, another standby master will read the master state and take over. The master state contains the submission data of all applications. If one application dies, a master can use that state to recover that application. CRDT LwwMap  is used to represent the state; it is a hash map that can converge on distributed nodes without conflict. To have strong data consistency, the state read and write must happen on a quorum of master nodes.

### How we do handle failures?

With Akka's powerful actor supervision, we can implement a resilient system relatively easy. In Gearpump, different applications have a different AppMaster instance, they are totally isolated from each other. For each application, there is a supervision tree, AppMaster->Executor->Task. With this supervision hierarchy, we can free ourselves from the headache of zombie process, for example if AppMaster is down, Akka supervisor will ensure the whole tree is shutting down. 
 
There are multiple possible failure scenarios

![](/img/failures.png) 
Figure: Possible Failure Scenarios and Error Supervision Hierarchy 

#### What happen when Master Crash?

When Master crash, other standby masters will be notified, they will resume the master state, and take over control. Worker and AppMaster will also be notified, They will trigger a process to find the new active master, until the resolution complete. If AppMaster or Worker cannot resolve a new Master in a time out, they will make suicide and kill themselves.

#### What happen When worker crash?

When worker crash, the Master will get notified and stop scheduling new computation to this worker. All supervised executors on current worker will be killed, AppMaster can treat it as recovery of executor crash like [What happen when executor crash?](#what-happen-when-executor-crash)

#### What happen when AppMaster Crash?

If a AppMaster crashes, Master will schedule a new resource to create a new AppMaster Instance elsewhere, and then the AppMaster will handle the recovery inside the application. For streaming, it will recover the latest min clock and other state from disk, request resources from master to start executors, and restart the tasks with recovered min clock.

#### What happen when executor crash?

If an Executor Crashes, its supervisor AppMaster will get notified, and request a new resource from the active master to start a new executor, to run the tasks which were located on the crashed executor.

#### What happen when task crash?

If a task throws an exception, its supervisor executor will restart that Task.

When "at least once" message delivery is enabled, it will trigger the message replaying in the case of message loss. First AppMaster will read the latest minimum clock from the global clock service(or clock storage if the clock service crashes), then AppMaster will restart all the task actors to get a fresh task state, then the source end tasks will replay messages from that minimum clock.

### How exactly once work?

For some applications, it is extremely important to do "exactly once" message delivery. For example, for a real-time billing system, we will not want to bill the customer twice. The goal of "exactly once" message delivery is to make sure:
  The error doesn't accumulate, today's error will not be accumulated to tomorrow.
  Transparent to application developer
We use global clock to synchronize the distributed transactions. We assume every message from the data source will have a unique timestamp, the timestamp can be a part of the message body, or can be attached later with system clock when the message is injected into the streaming system. With this global synchronized clock, we can coordinate all tasks to checkpoint at same timestamp. 
 
![](/img/checkpointing.png)
Figure: Checkpointing and Exactly-Once Message delivery

Workflow to do state checkpointing:
  
1. The coordinator asks the streaming system to do checkpoint at timestamp Tc.
2. For each application task, it will maintain two states, checkpoint state and current state. Checkpoint state only contains information before timestamp Tc. Current state contains all information.
3. When global minimum clock is larger than Tc, it means all messages older than Tc has been processed; the checkpoint state will no longer change, so we will then persist the checkpoint state to storage safely.
4. When there is message loss, we will start the recovery process. 
5. To recover, load the latest checkpoint state from store, and then use it to restore the application status.
6. Data source replays messages from the checkpoint timestamp. 
  
The checkpoint interval is determined by global clock service dynamically. Each data source will track the max timestamp of input messages. Upon receiving min clock updates, the data source will report the time delta back to global clock service. The max time delta is the upper bound of the application state timespan. The checkpoint interval is bigger than max delta time: 

![](/img/checkpoint_equation.png)

![](/img/checkpointing_interval.png) 
Figure: How to determine Checkpoint Interval

After the checkpoint interval is notified to tasks by global clock service, each task will calculate its next checkpoint timestamp autonomously without global synchronization.

![](/img/checkpoint_interval_equation.png)

For each task, it contains two states, checkpoint state and current state. The code to update the state is shown in listing below.
 
```python
TaskState(stateStore, initialTimeStamp):
  currentState = stateStore.load(initialTimeStamp)
  checkpointState = currentState.clone
  checkpointTimestamp = nextCheckpointTimeStamp(initialTimeStamp) 
onMessage(msg):
  if (msg.timestamp < checkpointTimestamp):
    checkpointState.updateMessage(msg)
  currentState.updateMessage(msg)  
  maxClock = max(maxClock, msg.timeStamp)

onMinClock(minClock):
  if (minClock > checkpointTimestamp):
    stateStore.persist(checkpointState)
    checkpointTimeStamp = nextCheckpointTimeStamp(maxClock)
    checkpointState = currentState.clone

onNewCheckpointInterval(newStep):
  step = newStep  
nextCheckpointTimeStamp(timestamp):
  checkpointTimestamp = (1 + timestamp/step) * step
``` 

List 1: Task Transactional State Implementation

### What is dynamic graph, and how it works?

The DAG can be modified dynamically. We want to be able to dynamically add, remove, and replace a sub-graph. 

![](/img/dynamic.png) 
Figure: Dynamic Graph, Attach, Replace, and Remove


## Kafka At least once message delivery

The Kafka source example project and tutorials can be found at: 
- [Kafka connector example project](https://github.com/gearpump/gearpump/tree/master/examples/streaming/kafka)
- [Connect with Kafka source](#connect-with-kafka)

In this doc, we will talk about how the at least once message delivery works.

We will use the WordCount example of [source tree](https://github.com/gearpump/gearpump/tree/master/examples/streaming/kafka)  to illustrate.

### How the kafka WordCount DAG looks like:

It contains three processors:
![](/img/kafka_wordcount.png)

- KafkaStreamProducer(or KafkaSource) will read message from kafka queue.
- Split will split lines to words
- Sum will summarize the words to get a count for each word.

### How to read data from Kafka

We use KafkaSource, please check [Connect with Kafka source](#connect-with-kafka) for the introduction.

Please note that we have set a startTimestamp for the KafkaSource, which means KafkaSource will read from Kafka queue starting from messages whose timestamp is near startTimestamp.

### What happen where there is Task crash or message loss?
When there is message loss, the AppMaster will first pause the global clock service so that the global minimum timestamp no longer change, then it will restart the Kafka source tasks. Upon restart, Kafka Source will start to replay. It will first read the global minimum timestamp from AppMaster, and start to read message from that timestamp.

### What method KafkaSource used to read messages from a start timestamp? As we know Kafka queue doesn't expose the timestamp information.

Kafka queue only expose the offset information for each partition. What KafkaSource do is to maintain its own mapping from Kafka offset to  Application timestamp, so that we can map from a application timestamp to a Kafka offset, and replay Kafka messages from that Kafka offset.

The mapping between Application timestmap with Kafka offset is stored in a distributed file system or as a Kafka topic.


## Command Line Syntax

**NOTE:** on windows platform, please use window shell .bat script instead. bash script doesn't work well in cygwin/mingw.
The commands can be found at: "bin/" folder of release binary.

### local

Used to start the cluster in local cluster.
Syntax:
```bash
Usage:
local
```

It will start the local at port configured in conf/gear.conf

### master

Used to start Gearpump master nodes, you can start one or more master nodes. 

Syntax:
```bash
master -ip <master ip address> -port  <master port>
-ip  (required:true)
-port  (required:true)
```

The ip and port settings will be checked against config in gear.conf

### worker

Used to start worker nodes. You usually will start several workers, with one worker on one machine. 

Syntax:
```bash
###  It will load config from gear.conf, no command line arguments should be provided.
worker
```

### services
Used to start the dashboard UI server.

syntax:
```bash
services
```

### gear app
Used to submit a application jar to the Gearpump Cluster. 

Syntax:
```bash
Usage:
gear app -namePrefix <application name prefix> -jar <application>.jar <mainClass <remain arguments>>
-namePrefix  (required:false, default:)
-jar  (required:true)
```

### gear info
Used to list running application information

Syntax:
```bash
C:\myData\gearpump\target\pack\bin>gear info
Usage:
gear info
```

### gear kill
Used to kill an application

Syntax:
```bash
gear kill -appid <application id>
-appid  (required:true)
```

### gear shell
Used to start a scala shell

Syntax:
```bash
C:\myData\gearpump\target\pack\bin>gear shell
Usage:
gear shell
```

## Rest API

### GET api/v1.0/appmaster/&lt;appId&gt;?detail=&lt;true|false&gt;
Query information of an specific application of Id appId

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/appmaster/2
```
Sample Response:
```
{
  "status": "active",
  "appId": 2,
  "appName": "wordCount",
  "appMasterPath": "akka.tcp://app2-executor-1@127.0.0.1:62525/user/daemon/appdaemon2/$c",
  "workerPath": "akka.tcp://master@127.0.0.1:3000/user/Worker1",
  "submissionTime": "1425925651057",
  "startTime": "1425925653433",
  "user": "foobar"
}
```


### DELETE api/v1.0/appmaster/&lt;appId&gt;
shutdown application appId

### GET api/v1.0/appmaster/&lt;appId&gt;/stallingtasks
Query list of unhealthy tasks of an specific application of Id appId

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/appmaster/2/stallingtasks
```
Sample Response:
```
{
  "tasks": [
    {
      "processorId": 0,
      "index": 0
    }
  ]
}
```

### GET api/v1.0/appmasters
Query information of all applications

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/appmasters
```
Sample Response:
```
{
  "appMasters": [
    {
      "status": "active",
      "appId": 1,
      "appName": "dag",
      "appMasterPath": "akka.tcp://app1-executor-1@127.0.0.1:62498/user/daemon/appdaemon1/$c",
      "workerPath": "akka.tcp://master@127.0.0.1:3000/user/Worker1",
      "submissionTime": "1425925483482",
      "startTime": "1425925486016",
      "user": "foobar"
    }
  ]
}
```

### GET api/v1.0/config/app/&lt;appId&gt;
Query the configuration of specific application appId

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/config/app/1
```
Sample Response:
```
{
    "gearpump" : {
        "appmaster" : {
            "extraClasspath" : "",
            "vmargs" : "-server -Xms512M -Xmx1024M -Xss1M -XX:MaxPermSize=128m -XX:+HeapDumpOnOutOfMemoryError -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseParNewGC -XX:NewRatio=3"
        },
        "cluster" : {
            "masters" : [
                "127.0.0.1:3000"
            ]
        },
        "executor" : {
            "extraClasspath" : "",
            "vmargs" : "-server -Xms512M -Xmx1024M -Xss1M -XX:MaxPermSize=128m -XX:+HeapDumpOnOutOfMemoryError -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseParNewGC -XX:NewRatio=3"
        },
        "jarstore" : {
            "rootpath" : "jarstore/"
        },
        "log" : {
            "application" : {
                "dir" : "logs"
            },
            "daemon" : {
                "dir" : "logs"
            }
        },
        "metrics" : {
            "enabled" : true,
            "graphite" : {
                "host" : "127.0.0.1",
                "port" : 2003
            },
            "logfile" : {},
            "report-interval-ms" : 15000,
            "reporter" : "akka",
            "retainHistoryData" : {
                "hours" : 72,
                "intervalMs" : 3600000
            },
            "retainRecentData" : {
                "intervalMs" : 15000,
                "seconds" : 300
            },
            "sample-rate" : 10
        },
        "netty" : {
            "base-sleep-ms" : 100,
            "buffer-size" : 5242880,
            "fulsh-check-interval" : 10,
            "max-retries" : 30,
            "max-sleep-ms" : 1000,
            "message-batch-size" : 262144
        },
        "netty-dispatcher" : "akka.actor.default-dispatcher",
        "scheduling" : {
            "scheduler-class" : "io.gearpump.cluster.scheduler.PriorityScheduler"
        },
        "serializers" : {
            "[B" : "",
            "[C" : "",
            "[D" : "",
            "[F" : "",
            "[I" : "",
            "[J" : "",
            "[Ljava.lang.String;" : "",
            "[S" : "",
            "[Z" : "",
            "io.gearpump.Message" : "io.gearpump.streaming.MessageSerializer",
            "io.gearpump.streaming.task.Ack" : "io.gearpump.streaming.AckSerializer",
            "io.gearpump.streaming.task.AckRequest" : "io.gearpump.streaming.AckRequestSerializer",
            "io.gearpump.streaming.task.LatencyProbe" : "io.gearpump.streaming.LatencyProbeSerializer",
            "io.gearpump.streaming.task.TaskId" : "io.gearpump.streaming.TaskIdSerializer",
            "scala.Tuple1" : "",
            "scala.Tuple2" : "",
            "scala.Tuple3" : "",
            "scala.Tuple4" : "",
            "scala.Tuple5" : "",
            "scala.Tuple6" : "",
            "scala.collection.immutable.$colon$colon" : "",
            "scala.collection.immutable.List" : ""
        },
        "services" : {
            # gear.conf: 112
            "host" : "127.0.0.1",
            # gear.conf: 113
            "http" : 8090,
            # gear.conf: 114
            "ws" : 8091
        },
        "task-dispatcher" : "akka.actor.pined-dispatcher",
        "worker" : {
            # reference.conf: 100
            # # How many slots each worker contains
            "slots" : 100
        }
    }
}

```

### GET api/v1.0/config/worker/&lt;workerId&gt;
Get the configuration of specific worker workerId

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/config/worker/123456
```
Sample Response:
```
{
  "akka": {
    "loglevel": "INFO"
    "log-dead-letters": "off"
    "log-dead-letters-during-shutdown": "off"
    "actor": {
      "provider": "akka.remote.RemoteActorRefProvider"
    }
    "cluster": {
      "roles": ["worker"]
    }
    "remote" {
      "log-remote-lifecycle-events": "off"
    }
  }
}
```

### GET api/v1.0/config/master
Get the configuration of all masters 

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/config/master
```
Sample Response:
```
{
  "extensions": [
    "akka.contrib.datareplication.DataReplication$"
  ]
  "akka": {
    "loglevel": "INFO"
    "log-dead-letters": "off"
    "log-dead-letters-during-shutdown": "off"
    "actor": {
      ## Master forms a akka cluster
      "provider": "akka.cluster.ClusterActorRefProvider"
    }
    "cluster": {
      "roles": ["master"]
      "auto-down-unreachable-after": "15s"
    }
    "remote": {
      "log-remote-lifecycle-events": "off"
    }
  }
}
```

### GET api/v1.0/master
Get information of masters

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/master
```
Sample Response:
```
{
  "masterDescription": {
    "leader": [
      "master@127.0.0.1",
      3000
    ],
    "cluster": [
      [
        "127.0.0.1",
        3000
      ]
    ],
    "aliveFor": "642941",
    "logFile": "/Users/foobar/gearpump/logs",
    "jarStore": "jarstore/",
    "masterStatus": "synced",
    "homeDirectory": "/Users/foobar/gearpump"
  }
}
```

### GET api/v1.0/metrics/app/&lt;appId&gt;/&lt;metrics path&gt;
Query metrics information of a specific application appId
Filter metrics with path metrics path

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/metrics/app/3/app3.processor2
```
Sample Response:
```
{
  "appId": 3,
  "path": "app3.processor2",
  "metrics": []
}
```

### GET api/v1.0/workers/&lt;workerId&gt;
Get information of specific worker

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/workers/1096497833
```
Sample Response
```
{
  "workerId": 1096497833,
  "state": "active",
  "actorPath": "akka.tcp://master@127.0.0.1:3000/user/Worker0",
  "aliveFor": "77042",
  "logFile": "/Users/foobar/gearpump/logs",
  "executors": [],
  "totalSlots": 100,
  "availableSlots": 100,
  "homeDirectory": "/Users/foobar/gearpump"
}
```

The worker list can be returned by query api/v1.0/workers Rest service.

### GET api/v1.0/workers
Get information of all workers.

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/workers
```
Sample Response:
```
[
  {
    "workerId": 307839464,
    "state": "active",
    "actorPath": "akka.tcp://master@127.0.0.1:3000/user/Worker0",
    "aliveFor": "18445",
    "logFile": "/Users/foobar/gearpump/logs",
    "executors": [],
    "totalSlots": 100,
    "availableSlots": 100,
    "homeDirectory": "/Users/foobar/gearpump"
  },
  {
    "workerId": 485240986,
    "state": "active",
    "actorPath": "akka.tcp://master@127.0.0.1:3000/user/Worker1",
    "aliveFor": "18445",
    "logFile": "/Users/foobar/gearpump/logs",
    "executors": [],
    "totalSlots": 100,
    "availableSlots": 100,
    "homeDirectory": "/Users/foobar/gearpump"
  }
]
```

### GET api/v1.0/version
Query the version of gearpump

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/version
```
Sample Response:
```
0.3.6-SNAPSHOT
```

### GET api/v1.0/websocket/url
Query the url of web socket

Example:
```bash
curl http://127.0.0.1:8090/api/v1.0/websocket/url
```
Sample Response:
```
{
  "url": "ws://127.0.0.1:8091"
}
```



## Configuration Guide

The configuration can be changed at conf/gear.conf.
If you change the configuration, you need to restart the daemon process(master, worker) to make the change effective.

config item | default value | description
---------------|--------|---------------
gearpump.hostname | "127.0.0.1" | hostname of current machine. If you are using local mode, then set this to 127.0.0.1, if you are using cluster mode, make sure this hostname can be accessed by other machines.
gearpump.cluster.masters | ["127.0.0.1:3000"] | Config to set the master nodes of the cluster. If there are multiple master in the list, then the master nodes runs in HA mode.  ### For example, you may start three master, on node1: bin/master -ip node1 -port 3000, on node2: bin/master -ip node2 -port 3000, on node3: bin/master -ip node3 -port 3000, then you need to set the cluster.masters = ["node1:3000","node2:3000","node3:3000"]
gearpump.task-dispatcher | "akka.actor.pined-dispatcher" | default dispatcher for task actor
gearpump.metrics.enabled | false | flag to enable the metrics system
gearpump.metrics.sample-rate | 10 | We will take one metric out of ${sample.rate}
gearpump.metrics.report-interval-ms | 15000 | we will report once every 15 seconds
gearpump.metrics.reporter  | "logfile" | available value: "graphite", "akka", "logfile" which write the metrics data to different places.
gearpump.metrics.graphite.host | "127.0.0.1" | when set the reporter = "graphite", the target graphite host.
gearpump.metrics.graphite.port | 2003 | when set the reporter = "graphite", the target graphite port
gearpump.retainHistoryData.hours | 72 | max hours of history data to retain, Note: Due to implementation limitation(we store all history in memory), please don't set this to too big which may exhaust memory.
gearpump.retainHistoryData.intervalMs | 3600000 |  # time interval between two data points for history data (unit: ms) Usually this value is set to a big value so that we only store coarse-grain data
gearpump.retainRecentData.seconds | 300 | max seconds of recent data to retain, tHis is for the fine-grain data
gearpump.retainRecentData.intervalMs | 15000 | time interval between two data points for recent data (unit: ms)
gearpump.log.daemon.dir | "logs" | The log directory for daemon processes(relative to current working directory)
gearpump.log.application.dir | "logs" | The log directory for applications(relative to current working directory)
gearpump.serializers | a map | custom serializer for streaming application
gearpump.worker.slots | 100 | How many slots each worker contains
gearpump.appmaster.vmargs | "" | JVM arguments for AppMaster
gearpump.appmaster.extraClasspath | "" | JVM default class path for AppMaster
gearpump.executor.vmargs | "" | JVM arguments for executor
gearpump.executor.extraClasspath | "" | JVM default class path for executor
gearpump.jarstore.rootpath | "jarstore/" |   Define where the submitted jar file will be stored at. This path follows the hadoop path schema, For HDFS, use hdfs://host:port/path/; For FTP, use ftp://host:port/path; If you want to store on master nodes, then use local directory. jarstore.rootpath = "jarstore/" will points to relative directory where master is started. jarstore.rootpath = "/jarstore/" will points to absolute directory on master server
gearpump.scheduling.scheduler-class | | Default value is "io.gearpump.cluster.scheduler.PriorityScheduler". Class to schedule the applications. 
gearpump.services.host | 127.0.0.1 | dashboard UI host address
gearpump.services.port | 8090 | dashboard UI host port
gearpump.services.ws | 8091 | web socket service port for long connection.
gearpump.netty.buffer-size | 5242880
gearpump.netty.max-retries | 30
gearpump.netty.base-sleep-ms | 100
gearpump.netty.max-sleep-ms | 1000
gearpump.netty.message-batch-size | 262144
gearpump.netty.fulsh-check-interval | 10



## Master HA Guide

To support HA, we allow to start master on multiple nodes. They will form a quorum to decide consistency. For example, if we start master on 5 nodes and 2 nodes are down, then the cluster is still consistent and functional.

Here is the steps to enable the HA mode:

### 1. Configure. 

#### Select master machines

Distribute the package to all nodes. Modify `conf/gear.conf` on all nodes. You MUST configure

```bash
gearpump.hostname
```
to make it point to your hostname(or ip), and 

```bash
gearpump.cluster.masters
``` 
to a list of master nodes. For example, if I have 3 master nodes (node1, node2, and node3),  then the ```gearpump.cluster.masters``` can be set as 
 
```bash
  gearpump.cluster {
    masters = ["node1:3000", "node2:3000", "node3:3000"]
  }
```

#### Configure distributed storage to store application jars.
In `conf/gear.conf`, For entry gearpump.jarstore.rootpath, please choose the storage folder for application jars. You need to make sure this jar storage is high availability. We support two storage system:
 
  1). HDFS
  You need to configure the gearpump.jarstore.rootpath like this
  
```bash
  hdfs://host:port/path/
```
  
  2). Shared NFS folder
  First you need to map the NFS directory to local directory(same path) on all machines of master nodes. 
Then you need to set the gearpump.jarstore.rootPath like this:
  
```bash
  file:///your_nfs_mapping_directory
```

  3). If you don't set this value, we will use the local directory of master node. 
  NOTE! This is not HA guarantee in this case, which means when one application goes down, we are not able to recover it.
  
### 2. Start Daemon. 

On node1, node2, node3, Start Master
  
```bash
  ## on node1
  bin/master -ip node1 -port 3000
  
  ## on node2
  bin/master -ip node2 -port 3000
  
  ## on node3
  bin/master -ip node3 -port 3000
```  

### 3. Done! 

Now you have a high available HA cluster. You can kill any node, the master HA will take effect. 

**NOTE**: It can take up to 15 seconds for master node to fail-over. You can change the fail-over timeout time by adding config in gear.conf `master.akka.cluster.auto-down-unreachable-after=10s` or smaller value

## IDE setup

### Intellij IDE Setup

1. In Intellij, download scala plugin.  We are using scala version 2.11
2. Open menu "File->Open" to open Gearpump root project, then choose the Gearpump source folder. 
3. All set.

### Eclipse IDE Setup

I will show how to do this in eclipse LUNA.

There is a sbt-eclipse plugin to generate eclipse project files, but seems there are some bugs, and some manual fix is still required. Here is the steps that works for me:

1. Install latest version eclipse luna
2. Install latest scala-IDE http://scala-ide.org/download/current.html   I use update site address: http://download.scala-ide.org/sdk/lithium/e44/scala211/stable/site
3. Open a sbt shell under the root folder of Gearpump. enter "eclipse", then we get all eclipse project file generated.
4. Use eclipse import wizard. File->Import->Existing projects into Workspace, make sure to tick the option "Search for nested projects"
5. Then it may starts to complain about encoding error, like "IO error while decoding". You need to fix the eclipse default text encoding by changing configuration at "Window->Preference->General->Workspace->Text file encoding" to UTF-8.
6. Then the project gearpump-external-kafka may still cannot compile. The reason is that there is some dependencies missing in generated .classpath file by sbt-eclipse. We need to do some manual fix. Right click on project icon of gearpump-external-kafka in eclipse, then choose menu "Build Path->Configure Build Path". A window will popup. Under the tab "projects", click add, choose "gearpump-streaming"
7. All set. Now the project should compile OK in eclipse.


## FAQ

##### Why we name it GearPump?

The name GearPump is a reference the engineering term "Gear Pump", which is a super simple pump that consists of only two gears, but is very powerful at streaming water from left to right.

##### Why not using akka persistence to store the checkpoint file?

1. We only checkpoint file to disk when necessary.(not record level) 
2. We have custom checkpoint file format

##### Have you considered the akka stream API for the high level DSL?

We are looking into a hands of candidate for what a good DSL should be. Akka stream API is one of the candidates.

##### Why wrapping the Task, instead of using the Actor interface directly? 

1. It is more easy to conduct Unit test 
2. We have custom logic and messages to ensure the data consistency, like flow control, like message loss detection. 
3. As the Gearpump interface evolves rapidly. for now, we want to conservative in exposing more powerful functions so that we doesn't tie our hands for future refactory, it let us feel safe.

##### What is the open source plan for this project?
The ultimate goal is to make it an Apache project.
