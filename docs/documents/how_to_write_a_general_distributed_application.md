# How to Write a General Distributed Application

We'll use [Distributed Shell](https://github.com/intel-hadoop/gearpump/tree/master/examples/distributedshell/src/main/scala/org/apache/gearpump/examples/distributedshell) as an example to illustrate how to do that.

What Distributed Shell do is that user send a shell command to the cluster and the command will the executed on each node, then the result will be return to user.

###Shell Executor
In this kind of distributed application, Task is not needed any more because the Executor can take over that role.

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

###Distributed Shell AppMaster
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

###Weave together
Now its time to launch the application.

```scala
object DistributedShell extends App with ArgumentsParser {
  override val options: Array[(String, CLIOption[Any])] = Array(
    "master" -> CLIOption[String]("<host1:port1,host2:port2,host3:port3>", required = true)
  )

  def application(config: ParseResult) : Application = {
    Application("DistributedShell", classOf[DistShellAppMaster].getName, UserConfig.empty)
  }

  val config = parse(args)
  val context = ClientContext(config.getString("master"))
  implicit val system = context.system
  val appId = context.submit(application(config))
  context.close()
  LOG.info(s"Distributed Shell Application started with appId $appId !")
}
```

The application class extends `App` and `ArgumentsParser which make it easier to parse arguments and run main functions. This part is similar to the streaming applications.

The main class DistributeShell will submit an Application, whose AppMaster is DistShellAppMaster.

After set up the DistributedShell application, user can send shell command to it now.

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
