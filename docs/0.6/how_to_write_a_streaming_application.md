# Streaming Application Developer Guide

We'll use [wordcount](https://github.com/gearpump/gearpump/blob/master/examples/streaming/wordcount/src/main/scala/io/gearpump/streaming/examples/wordcount/) as an example to illustrate how to write GearPump applications.

## Maven/Sbt Settings

Repository and library dependencies can be found at [Maven Setting](/downloads/#maven)

## For java developer

Most contents in this guide also apply for Java developer. There is a template java project at [Java WordCount Project](https://github.com/gearpump/gearpump-java-example)

## Define Processor(Task) class and Partitioner class

An application is a Directed Acyclic Graph (DAG) of processors. In the wordcount example, We will firstly define two processors `Split` and `Sum`, and then weave them together. 

### About message type

User are allowed to send message of type AnyRef(map to Object in java). 
```
case class Message(msg: AnyRef, timestamp: TimeStamp = Message.noTimeStamp)
```

If user want to send primitive types like Int, Long, then he should box it explicitly with asInstanceOf. For example:
```
new Message(3.asInstanceOf[AnyRef])
```

### Split processor

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

### Sum Processor

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

### Partitioner

A processor could be parallelized to a list of tasks. A `Partitioner` defines how the data is shuffled among tasks of Split and Sum. GearPump has already provided two partitioners 

* `HashPartitioner`: partitions data based on the message's hashcode
* `ShufflePartitioner`: partitions data in a round-robin way.

You could define your own partitioner by extending the `Partitioner` trait and overriding the `getPartition` method.

```scala
trait Partitioner extends Serializable {
  def getPartition(msg : Message, partitionNum : Int) : Int
}
```

## Define TaskDescription and AppDescription

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

## Submit application

After all these, you need to package everything into a uber jar and submit the jar to Gearpump Cluster. Please check [Application submission tool](commandlinesyntax.md#gear-app) to command line tool syntax.

## Advanced topics

### Define Custom Message Serializer

We use library [kryo](https://github.com/EsotericSoftware/kryo) and [akka-kryo library](https://github.com/romix/akka-kryo-serialization). If you have special Message type, you can choose to define your own serializer explicitly. If you have not defined your own custom serializer, the system will use Kryo to serialize it at best effort.

When you have determined that you want to define a custom serializer, you can do this in two ways.

#### System Level Serializer

If the serializer is widely used, you can define a global serializer which is avaiable to all applications(or worker or master) in the system.

##### Step1: you first need to develop a java library which contains the custom serializer class. here is an example:

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

##### Step2: Distribute the libraries

Distribute the jar file to lib/ folder of every Gearpump installation in the cluster.

##### Step3: change gear.conf on every machine of the cluster:

```
gearpump {
  serializers {
    "io.gearpump.Message" = "your.serializer.class"
  }
}
```

#### All set!

### Define Application level custom serializer
If all you want is to define an application level serializer, which is only visible to current application AppMaster and Executors(including tasks), you can follow a different approach.

##### Step1: Define your custom Serializer class

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

##### Step2: Define a config file to include the custom serializer definition. For example, we can create a file called: myconf.conf


```
## content of myconf.conf
gearpump {
  serializers {
    "io.gearpump.Message" = "your.serializer.class"
  }
}
```

##### Step3: Add the conf into AppDescription

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

##### Step4: All set!

### Connect with Kafka

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
