# Benchmark

## How do we do benchmark?

1. Set up a node running Graphite, see guide doc/dashboard/README.md. 

2. Set up a 4-nodes Gearpump cluster with 10GbE network which have 3 Workers on each node. In our test environment, each node has 128GB memory and Intel? Xeon? 32-core processor E5-2680 2.70GHz. Make sure the metrics is enabled in Gearpump, check [guide](https://github.com/intel-hadoop/gearpump/wiki/Metrics-and-Dashboard)

3. Submit a SOL application with 32 SteamProducers and 32 StreamProcessors:
  ```bash
  bin/gear app -jar ./examples/sol/target/pack/lib/gearpump-examples-$VERSION.jar org.apache.gearpump.streaming.examples.sol.SOL -master $HOST:PORT -streamProducer 32 -streamProcessor 32 -runseconds 600
  ```

4. Browser http://$HOST:801/, you should see a grafana dashboard. The HOST should be the node runs Graphite.

5. Copy the config file doc/dashboard/graphana_dashboard, and modify the `host` filed to the actual hosts which runs Gearpump and the `source` and `target` fields. Please note that the format of the value should exactly the same as existing format and you also need to manually add the rest task ID to the value of `All` under `source` and `target` filed since now the number of each task type is 32.

6. In the Grafana web page, click the "search" button and then import the config file mentioned above.

# Metrics

We use codahale metrics library. Gearpump support to use Graphite to visualize the metrics data. Metrics is disabled by default. To use it, you need to configure the `core/src/main/resources/reference.conf`

  ```
  gearpump.metrics.enabled = true         ## Default is false, thus metrics is not enabled.
  gearpump.metrics.graphite.host = "your actual graphite host name or ip"  
  gearpump.metrics.graphite.port = 2003   ## Your graphite port
  gearpump.metrics.sample.rate = 10       ## this means we will sample 1 message for every 10 messages
  ```
  
For guide about how to install and configure Graphite, please check the Graphite website http://graphite.wikidot.com/.	For guide about how to use Grafana, please check guide in [doc/dashboard/readme.md](https://github.com/intel-hadoop/gearpump/blob/master/doc/dashboard/README.md)

Here is how it looks like for grafana dashboard:

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/dashboard.png)
