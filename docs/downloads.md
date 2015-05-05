# Downloads

## Latest Release version

release 0.3.4  [Release notes](https://github.com/intel-hadoop/gearpump/releases)
[![](img/download.jpg)](
https://github.com/intel-hadoop/gearpump/releases/download/0.3.4/gearpump-pack-0.3.4.tar.gz)

## Latest snapshot version

0.3.5-SNAPSHOT [Build from source code](0.3/getstarted/#build-from-source-code)

## Read [tutorial to get started](0.3/getstarted/)

## Maven

### For stable release version
This contains latest release. 
**Note:** There maybe delay in updating this document, you can still find the latest stable version by checking https://github.com/intel-hadoop/gearpump/releases .

Repo:
```xml
<repositories>
<repository>
<id>releases-oss.sonatype.org</id>
<name>Sonatype Releases Repository</name>
<url>http://oss.sonatype.org/content/repositories/releases/</url>
</repository>

<repository>
    <id>akka-data-replication</id>
    <name>Patrik at Bintray</name>
    <url>http://dl.bintray.com/patriknw/maven</url>
</repository>

<repository>
    <id>cloudera</id>
    <name>Cloudera repo</name>
    <url>https://repository.cloudera.com/artifactory/cloudera-repos</url>
</repository>

</repositories>

```

Dependencies:
```xml
<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.3.4</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.3.4</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-external-kafka_2.11</artifactId>
<version>0.3.4</version>
</dependency>
</dependencies>
```

### For Snapshot version

The snapshot contains the latest code in master branch.

**Note:** There maybe delay in updating this document, you can still find the snapshot version by checking https://github.com/intel-hadoop/gearpump/blob/master/version.sbt

Repo:
```xml
<repositories>
<repository>
  <id>sonatype-nexus-releases</id>
  <name>Sonatype Nexus Snapshots</name>
  <url>https://oss.sonatype.org/content/repositories/snapshots</url>

</repository>

<repository>
    <id>akka-data-replication</id>
    <name>Patrik at Bintray</name>
    <url>http://dl.bintray.com/patriknw/maven</url>
</repository>

<repository>
    <id>cloudera</id>
    <name>Cloudera repo</name>
    <url>https://repository.cloudera.com/artifactory/cloudera-repos</url>
</repository>

</repositories>

```

Dependencies:
```xml
<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.3.5-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.3.5-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-external-kafka_2.11</artifactId>
<version>0.3.5-SNAPSHOT</version>
</dependency>
</dependencies>
```
