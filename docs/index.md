** This site is still under development, the contents will updated in a few days **

## Welcome to Gearpump

GearPump is a lightweight real-time big data streaming engine. It is inspired by recent advances in the [Akka](https://github.com/akka/akka) framework and a desire to improve on existing streaming frameworks.

The	name	GearPump	is	a	reference to	the	engineering term “gear	pump,”	which	is	a	super simple
pump	that	consists of	only	two	gears,	but	is	very	powerful at	streaming water.

![](img/logo.png)

We model streaming within the Akka actor hierarchy.

![](img/actor_hierarchy.png)

Per initial benchmarks we are able to process 11 million messages/second (100 bytes per message) with a 17ms latency on a 4-node cluster.

![](img/dashboard.png)

For steps to reproduce the performance test, please check [Performance benchmark](https://github.com/intel-hadoop/gearpump/wiki#how-do-we-do-benchmark)


GearPump is a lightweight, real-time, big data streaming engine. It is inspired by recent advances in the Akka framework and a desire to improve on existing streaming frameworks. GearPump draws from a number of existing frameworks including MillWheel, Apache Storm, Spark Streaming, Apache Samza, Apache Tez, and Hadoop YARN while leveraging Akka actors throughout its architecture.

Many of the information in this page can also be found at the technical whitepaper:
[https://typesafe.com/blog/gearpump-real-time-streaming-engine-using-akka](https://typesafe.com/blog/gearpump-real-time-streaming-engine-using-akka)

## Why we do this?

## Which area is it best applied for?

## What is the key highlights?

