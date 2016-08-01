---
layout: global
displayTitle: Apache Gearpump
title: Overview 
description: Apache Gearpump GEARPUMP_VERSION documentation homepage
---

![gearpump-logo](/favicon.ico) 
[![Release](https://img.shields.io/badge/Latest%20Release-v{{ site.GEARPUMP_VERSION }}-blue.svg)](http://www.gearpump.io/downloads.html) 

**Apache Gearpump** is a real-time big data streaming engine. The name Gearpump is a reference to the engineering term "gear pump" which is a super simple pump that consists of only two gears, but is very powerful at streaming water. Different to other streaming engines, Gearpump's engine is event/message based. Per initial benchmarks we are able to process 18 million messages per second (message length is 100 bytes) with a 8ms latency on a 4-node cluster. 


## The Highlights

* Extremely high throughput and low latency stream processing
* Configurable message delivery guarantee (at least once, exactly once)
* Application hot re-deployment
* Comprehensive Dashboard for application monitoring
* Native Storm Application compatibility
* Native Samoa Application compatibility
* Friendly and extensible APIs

## Getting Started

* Download [the latest stable release](downloads.html) and run Gearpump on your machine
* Checkout [the documentation](releases/latest/index.html) to find a setup guide for all deployment options

## Apache Incubation Disclaimer
Apache Gearpump is an effort undergoing incubation at [The Apache Software Foundation (ASF)](http://www.apache.org/) sponsored by the Apache Incubator PMC. Incubation is required of all newly accepted projects until a further review indicates that the infrastructure, communications, and decision making process have stabilized in a manner consistent with other successful ASF projects. While incubation status is not necessarily a reflection of the completeness or stability of the code, it does indicate that the project has yet to be fully endorsed by the ASF.

Apache Gearpump (incubating) is available under [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

![incubator-logo](/img/incubator-logo.png)
