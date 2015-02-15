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

All actors in the graph are woven together with actor supervision; actor watching and all errors are handled properly via supervisors. In a master, a risky job is isolated and delegated to child actors, so it's more robust. In the application, an extra intermediate layer, "Executor," is created so that we can do fine-grained and fast recovery in case of task failure. A master watches the lifecycle of AppMaster and Worker to handle the failures, but the lifecycle of Worker and AppMaster are not bound to a Master Actor by supervision, so that Master node can fail independently. Several Master Actors form an Akka cluster, the Master state is exchanged using the Gossip protocol in a conflict-free consistent way so that there is no single point of failure. With this hierarchy design, we are able to achieve high availability.
