# Kafka At least once message delivery

The Kafka source example project and tutorials can be found at: 
- [Kafka connector example project](https://github.com/intel-hadoop/gearpump/tree/master/examples/streaming/kafka)
- [Connect with Kafka source](how_to_write_a_streaming_application.md#connect-with-kafka)

In this doc, we will talk about how the at least once message delivery works.

We will use the WordCount example of [source tree](https://github.com/intel-hadoop/gearpump/tree/master/examples/streaming/kafka)  to illustrate.

## How the kafka WordCount DAG looks like:

It contains three processors:
![](/img/kafka_wordcount.png)

- KafkaStreamProducer(or KafkaSource) will read message from kafka queue.
- Split will split lines to words
- Sum will summarize the words to get a count for each word.

## How to read data from Kafka

We use KafkaSource, please check [Connect with Kafka source](how_to_write_a_streaming_application.md#connect-with-kafka) for the introduction.

Please note that we have set a startTimestamp for the KafkaSource, which means KafkaSource will read from Kafka queue starting from messages whose timestamp is near startTimestamp.

## What happen where there is Task crash or message loss?
When there is message loss, the AppMaster will first pause the global clock service so that the global minimum timestamp no longer change, then it will restart the Kafka source tasks. Upon restart, Kafka Source will start to replay. It will first read the global minimum timestamp from AppMaster, and start to read message from that timestamp.

## What method KafkaSource used to read messages from a start timestamp? As we know Kafka queue doesn't expose the timestamp information.

Kafka queue only expose the offset information for each partition. What KafkaSource do is to maintain its own mapping from Kafka offset to  Application timestamp, so that we can map from a application timestamp to a Kafka offset, and replay Kafka messages from that Kafka offset.

The mapping between Application timestmap with Kafka offset is stored in a distributed file system or as a Kafka topic.
