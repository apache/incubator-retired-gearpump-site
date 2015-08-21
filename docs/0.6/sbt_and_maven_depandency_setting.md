
# Maven dependencies

## Snapshot package

The snapshot contains the latest code in master branch.

Latest version: 0.2.4-SNAPSHOT

**Note:** There maybe delay in updating this document, you can still find the snapshot version by checking https://github.com/gearpump/gearpump/blob/master/version.sbt

```xml
<repositories>
<repository>
  <id>sonatype-nexus-releases</id>
  <name>Sonatype Nexus Snapshots</name>
  <url>https://oss.sonatype.org/content/repositories/snapshots</url>
</repository>
</repositories>

<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.2.4-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.2.4-SNAPSHOT</version>
</dependency>
</dependencies>
```

## Release package

This contains latest release. 
**Note:** There maybe delay in updating this document, you can still find the latest stable version by checking https://github.com/gearpump/gearpump/releases .

Latest version: 0.2.3

```xml
<repositories>
<repository>
<id>releases-oss.sonatype.org</id>
<name>Sonatype Releases Repository</name>
<url>http://oss.sonatype.org/content/repositories/releases/</url>
</repository>
</repositories>
<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-rest_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-external-kafka_2.11</artifactId>
<version>0.2.3</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-experiments-distributedshell_2.11</artifactId>
<version>0.2.3</version>
</dependency>
</dependencies>
```