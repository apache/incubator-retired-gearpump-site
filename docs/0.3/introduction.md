Introduction
================

What is Gearpump
-----------------

GearPump is a real-time big data streaming engine using Akka, it can also be used as an underlying platform for other general distributed applications, like a distributed cron job or a distributed log collection. 

Gearpump is inspired by recent advances in the Akka framework and a desire to improve on existing streaming frameworks. Gearpump draws from a number of existing frameworks including MillWheel , Apache Storm , Spark Streaming , Apache Samza , Apache Tez and Hadoop YARN  while leveraging Akka actors throughout its architecture.

![](/img/logo2.png)
 
The name Gearpump is a reference to the engineering term "gear pump," which is a simple water pump that consists of only two gears. We use this name to indicate this engine is "super simple and powerful".

Technical highlights of Gearpump
-------------

Gearpump is a performant, flexible, fault-tolerant, and responsive streaming platform with a lot of nice features, its technical highlights include:

### Actor everywhere

Actor model is a concurrency model proposed by Carl Hewitt at 1973. Actor is like a micro-service which is cohesive in the inside and isolated from outside actors. Actor is the cornerstone of Gearpump, it provide facilities to do message passing, error handling, liveliness monitoring. Gearpump use Actor everywhere. It use actor to implement everything entity in the cluster that can be treated as a service.

![](/img/actor_hierarchy.png)
 
### Exactly once Message Processing

The exactly once here means, effect of a message will be calculated only once in the persisted state and computation errors in the history will not be propagated to future computations.

![](/img/exact.png)

### Topology DAG DSL

User can submit to Gearpump a computation DAG, which contains a list of nodes and edges, and each node can be parallelized to a set of tasks. Gearpump will then schedule and distribute different tasks in the DAG to different machines automatically. Each task will be started as an actor, which is long running micro-service. 

![](/img/dag.png)

### Flow control

Gearpump has built-in support for flow control. For all message passing between different tasks, the framework will assure the upstream tasks will not flood the downstream tasks. 
![](/img/flowcontrol.png)

### No inherent end to end latency

Gearpump is a message level streaming engine, which means every task in the DAG will process messages immediately upon receiving, and deliver messages to downstream immediately without waiting. Gearpump doesn't do batching when data sourcing.

### High Performance message passing

By implementing smart batching strategies, Gearpump is extremely effective in transferring small messages. In one test of 4 machines, the whole cluster throughput can reach 11 million messages per second, with message size of 100 bytes.
![](/img/dashboard.png)

### High availability, No single point of failure

Gearpump has a careful design for high availability. We have considered message loss, worker machine crash, application crash, master crash, brain-split, and have made sure Gearpump correctly recovers when there errors happen. When there is message loss, lost message will be replayed; when there is worker machine crash or application crash, computation tasks will be rescheduled to new machines. For master high availability, several master nodes will form a Akka cluster, and CRDT (conflict free data type) is used to exchange the state, so as long as there is still a quorum, the master will stay functional. When one master node crash, other master nodes in the cluster will take over and state will be recovered. 

![](/img/ha.png)

### Dynamic Computation DAG 

GearPump provides a feature which allows the user to dynamically add, remove, or replace a sub graph at runtime, without the need to restart the whole computation topology.

![](/img/dynamic.png)

### Able to handle out of order messages

For a window operation like moving average on a sliding window, it is important to make sure we have received all messages in that time window so that we can get an accurate result, but how do we handle stranglers or late arriving messages? GearPump solves this problem by tracking the low watermark of timestamp of all messages, so it knows whether we've received all the messages in the time window or not.

![](/img/clock.png)

### Customizable platform

Different applications have different requirements related to performance metrics, some may want higher throughput, some may require strong eventual data consistency; and different applications have different resource requirements profiles, some may demand high CPU performance, some may require data locality. Gearpump meets these requirements by allowing the user to arbitrate between different performance metrics and define customized resource scheduling strategies. 

### Built-in Dashboard UI

Gearpump has a built-in dashboard UI to manage the cluster and visualize the applications. The UI uses REST call to connect with backend, so it is easy to embed the UI within other dashboards.

![](/img/dashboard.gif)

### Data connectors for Kafka and HDFS

Gearpump has built-in data connectors for Kafka and HDFS. For the Kafka connector, we support message replay from a specified timestamp.

What is a good use case for Gearpump?
--------------------

We considered Gearpump suitable for your application:

#### 1.  when you are a Scala guru and want to do streaming in Scala, or

#### 2.  when you already use Akka to do streaming, and want more data consistency, performance, and manageability, or

#### 3.  when you have IOT(internet of things) requirements and want to collect data from IOT, or deploy computation to edge devices transparently, or

#### 4.  when you have large in-memory data to maintain and want long running daemons for streaming, or

#### 5.  when you have exactly once message processing requirements but still need low latency, or

#### 6.  when you want to dynamically swap-in/swap-out certain sub-DAGs on a running topology, or

#### 7.  when you require real time streaming with max throughput without worrying about flow control or out of memory error, or

#### 8.  you want to try something new and cool :)

Relation with YARN
--------------
 
Gearpump can run on top of YARN as a YARN application. Gearpump's ApplicationMaster provides the application management , deployment and scheduling of DAG's after arbitrating and receiving container resources from YARN

Relation with Storm and Spark Streaming
-----------

Storm and spark streaming are proven platforms, there are many production deployments. Compared with them, Gearpump is not than proven and there is no production deployment yet. However, there is no single platform that can cover every use case; Gearpump has its own +1 points in some special fields. As an instance, for IOT use cases, Gearpump may be considered convenient because the topology can be deployed to edge device with feature of location transparency. For another example, when users want to upgrade the application online without service interruption, Gearpump may be suitable as it can dynamically modify the computation DAG on the fly. For other special use cases that are suitable for Gearpump, please check section [What is a good use case for Gearpump](0.3/introduction/#what-is-a-good-use-case-for-gearpump)

