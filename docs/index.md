# Welcome to Gearpump

GearPump is a lightweight real-time big data streaming engine. It is inspired by recent advances in the [Akka](https://github.com/akka/akka) framework and a desire to improve on existing streaming frameworks.

The	name	GearPump	is	a	reference to	the	engineering term “gear	pump,”	which	is	a	super simple
pump	that	consists of	only	two	gears,	but	is	very	powerful at	streaming water.

![](https://raw.githubusercontent.com/clockfly/gearpump/master/doc/logo/logo.png)

We model streaming within the Akka actor hierarchy.

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/actor_hierarchy.png)

Per initial benchmarks we are able to process 11 million messages/second (100 bytes per message) with a 17ms latency on a 4-node cluster.

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/dashboard.png)

For steps to reproduce the performance test, please check [Performance benchmark](https://github.com/intel-hadoop/gearpump/wiki#how-do-we-do-benchmark)

