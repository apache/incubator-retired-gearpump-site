---
layout: global
title: Gearpump Roadmap
---

## Gearpump 0.7 (plan to release at Nov 7th)
1. Storm compatibility. Support running Storm applications on Gearpump cluster.
1. Improved documentation,
1. Improved quality. With full E2E test.

## Gearpump 0.8 (planned release date: Dec 2015)
1. Support Akka-Streams integration with Gearpump. Support using Akka-Streams DSL to express logic.
1. Dynamic Dag Features
    * support for all operations: add, delete, move, modify
    * operator library import/export
    * dag assembly via UI
1. IoT related
    * Discovery and provisioning
    * Iterative processing
    * Replay
    * Support Gearpump integration with https://github.com/enableiot/iotkit-agent.
1. Kerberos support.
    * Support Gearpump authentication & authorization using Kerberos.
    * Support running Gearpump in secure YARN environment.
    * Support Gearpump connection with Kerberos enabled connectors (e.g. HBase).
