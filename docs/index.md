## Welcome to Gearpump 

[![](img/download.jpg)](/downloads/downloads/)

GearPump is a lightweight real-time big data streaming engine. It is inspired by recent advances in the [Akka](https://github.com/akka/akka) framework and a desire to improve on existing streaming frameworks.

The	name	GearPump	is	a	reference to	the	engineering term "gear	pump,"	which	is	a	super simple
pump	that	consists of	only	two	gears,	but	is	very	powerful at	streaming water.

![](img/logo2.png)


![](img/dashboard.gif)


We model streaming within the Akka actor hierarchy.

![](img/actor_hierarchy.png)

Per initial benchmarks we are able to process 11 million messages/second (100 bytes per message) with a 17ms latency on a 4-node cluster.

![](img/dashboard.png)

### Get Started
[![](img/download.jpg)](/downloads/downloads/)
#### - [Get Started Tutorial](0.3/getstarted.md)
#### - [Highlights](0.3/introduction.md)