---
layout: global
displayTitle: Frequently Asked Questions
title: FAQ
---

The following questions are frequently asked with regard to the Gearpump project in general. If you have further questions, make sure to consult the documentation or feel free to ask the community.

{: .table .table-condensed .table-hover }
|**[General](#general)**|
| &nbsp; [Why we name it Gearpump?](#why-we-name-it-gearpump)|
| &nbsp; [What's relationship between Gearpump and YARN?](#whats-relationship-between-gearpump-and-yarn)|
| &nbsp; [Relation with Storm and Spark Streaming](#relation-with-storm-and-spark-streaming)|
|**[Technical Internals](#technical-internals)**|
| &nbsp; [Why not using Akka persistence to store the checkpoint file?](#why-not-using-akka-persistence-to-store-the-checkpoint-file)|
| &nbsp; [Have you considered the Akka Stream API for the high level DSL?](#have-you-considered-the-akka-stream-api-for-the-high-level-dsl)|
| &nbsp; [Why wrapping the Task, instead of using the Actor interface directly?](#why-wrapping-the-task-instead-of-using-the-actor-interface-directly)|
| &nbsp; [Why does my task has an extremely high message latency (e.g. 10 seconds)?](#why-does-my-task-has-an-extremely-high-message-latency-eg-10-seconds-)|
|**[Errors](#errors)**|
| &nbsp; [Why I cannot open the Dashboard, even if the Services process has been launched successfully?](#why-i-cannot-open-the-dashboard-even-if-the-services-process-has-been-launched-successfully)|

## General 

### Why we name it Gearpump?

The name Gearpump is a reference the engineering term "Gear Pump", which is a super simple pump that consists of only two gears, but is very powerful at streaming water from left to right.

### What's relationship between Gearpump and YARN?
Gearpump can run on top of YARN as a YARN application. Gearpump's Application Master provides the application management, deployment and scheduling of DAG's after arbitrating and receiving container resources from YARN.

### Relation with Storm and Spark Streaming
Storm and Spark Streaming are proven platforms. There are many production deployments. Compared with them, Gearpump is not than proven and there is no production deployment yet. However, there is no single platform that can cover every use case. Gearpump has its own +1 points in some unique use cases. For instance, for the IOT use cases, Gearpump may be considered convenient because the topology can be deployed to edge device with feature of location transparency. For another example, when users want to upgrade the application online without service interruption, Gearpump may be suitable as it can dynamically modify the computation DAG on the fly. To explore more good use cases that are suitable for Gearpump, please check the section [What is a good use case for Gearpump](usecases.html).

### Why not using Akka persistence to store the checkpoint file?

1. We only checkpoint file to disk when necessary, not at record level.
2. We have custom checkpoint file format.

### Have you considered the Akka Stream API for the high level DSL?

We are looking into a hands of candidate for what a good DSL should be. Akka Stream API is one of the candidates.

### Why wrapping the Task, instead of using the Actor interface directly?

1. It is more easy to conduct Unit test.
2. We have custom logic and messages to ensure the data consistency, like flow control, like message loss detection.
3. As the Gearpump interface evolves rapidly. For now, we want to conservative in exposing more powerful functions so that we doesn't tie our hands for future refactoring, it provides a great flexibility.

### Why does my task has an extremely high message latency (e.g. 10 seconds) ?

Please check whether you are doing blocking jobs (e.g. sleep, IO) in your task. By default, all tasks in an executor share a thread pool. The blocking tasks could use up all the threads while other tasks don't get a chance to run. In that case, you can set `gearpump.task-dispatcher` to `"gearpump.single-thread-dispatcher"` in `gear.conf` such that a unique thread is dedicated to each task.

Generally, we recommend use the default `share-thread-pool-dispatcher` which has better performance and only turn to the `single-thread-dispatcher` when you have to.

## Errors

### Why I cannot open the Dashboard, even if the Services process has been launched successfully?

By default, our Services process binds to a local **IPv6 port**. It's possible that another process on your system has already taken up the same **IPv4 port**. You may check by `lsof -i -P | grep -i "Listen"` if your system is Unix/Linux.
