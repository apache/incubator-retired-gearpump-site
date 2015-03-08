# Streaming Application Developer Guide

We'll use [wordcount](https://github.com/intel-hadoop/gearpump/tree/master/examples/wordcount/src/main/scala/org/apache/gearpump/streaming/examples/wordcount) as an example to illustrate how to write GearPump applications.

## Maven/Sbt Settings

## Define Processor(Task) class and Partitioner class

An application is a Directed Acyclic Graph (DAG) of processors (Please refer to [DAG API](https://github.com/intel-hadoop/gearpump/wiki/DAG-API)) . In the wordcount example, We will firstly define two processors `Split` and `Sum`, and then weave them together. 

### Split processor

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

### Sum Processor

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

## Submit an application

Please check [Application submission tool](commandlinesyntax#gear-app)

## Advanced topics

### Define Custom Message Serializer

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



### Connect with Kafka
