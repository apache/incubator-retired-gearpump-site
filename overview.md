---
layout: global
displayTitle: Apache Gearpump
title: Overview 
description: Apache Gearpump GEARPUMP_VERSION documentation homepage
---
[![Release](https://img.shields.io/badge/Latest%20Release-v{{ site.GEARPUMP_VERSION }}-blue.svg)](http://www.gearpump.io/downloads.html) [![Demo site](https://img.shields.io/badge/Demo%20Site-click%20to%20visit-green.svg)](http://demo.gearpump.io)

**Apache Gearpump** is a real-time big data streaming engine. The name Gearpump is a reference to the engineering term "gear pump" which is a super simple pump that consists of only two gears, but is very powerful at streaming water. Different to other streaming engines, Gearpump's engine is event/message based. Per initial benchmarks we are able to process 18 million messages per second (message length is 100 bytes) with a 8ms latency on a 4-node cluster. 

![Logo](img/logo2.png)

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