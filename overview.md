---
layout: global
displayTitle: Gearpump Overview
title: Overview 
description: Gearpump GEARPUMP_VERSION documentation homepage
---
[![Release](https://img.shields.io/badge/Latest%20Release-v{{ site.GEARPUMP_VERSION }}-blue.svg)](http://www.gearpump.io/download.html)   [![Demo site](https://img.shields.io/badge/Demo%20Site-online-green.svg)](http://demo.gearpump.io/login.html)

Gearpump is a real-time big data streaming engine.
It is inspired by recent advances in the [Akka](http://akka.io/) framework and a desire to improve on existing streaming frameworks.
Gearpump is event/message based and featured as low latency handling, high performance, exactly once semantics,
dynamic topology update, [Apache Storm](https://storm.apache.org/) compatibility, etc.

![logo](img/logo2.png)

The	name	Gearpump	is	a	reference to	the	engineering term "gear	pump,"	which	is	a	super simple
pump	that	consists of	only	two	gears,	but	is	very	powerful at	streaming water.

![UI](/img/dashboard.gif)

### Gearpump Technical Highlights
Gearpump is a modern big data real-time streaming engine which has many unique features:

* Extremely high performance
* Low latency
* Configurable message delivery guarantee (at least once, exactly once).
* Highly extensible
* Dynamic DAG
* Storm compatibility
* Samoa compatibility
* widely IoT connectivity
* Both high level and low level API


### Gearpump Performance
Per initial benchmarks we are able to process 18 million messages/second (100 bytes per message) with a 8ms latency on a 4-node cluster.

![bashboard](img/dashboard.png)

### Gearpump and Akka
Gearpump is a 100% Akka based platform. We model big data streaming within the Akka actor hierarchy.
![arctor hierarchy](img/actor_hierarchy.png)
Gearpump
