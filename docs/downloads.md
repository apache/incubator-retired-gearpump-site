# Downloads

## Latest Release version

release 0.6.1.4  [Release notes](https://github.com/gearpump/gearpump/releases)

### scala 2.11
[![](img/download.jpg)](https://github.com/gearpump/gearpump/releases/download/0.6.1.4/gearpump-pack-2.11.5-0.6.1.4.zip)

### scala 2.10
[![](img/download.jpg)](https://github.com/gearpump/gearpump/releases/download/0.6.1.4/gearpump-pack-2.10.5-0.6.1.4.zip)


## To Build Latest snapshot version

## Read [tutorial to get started](0.6/getstarted/)

## Maven

### For stable release version
This contains latest release. 
**Note:** There maybe delay in updating this document, you can still find the latest stable version by checking https://github.com/gearpump/gearpump/releases .

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

<repository>
    <id>vincent</id>
    <name>vincent</name>
    <url>http://dl.bintray.com/fvunicorn/maven</url>
</repository>

<repository>
    <id>non</id>
    <name>non</name>
    <url>http://dl.bintray.com/non/maven</url>
</repository>

<repository>
    <id>non</id>
    <name>non</name>
    <url>http://dl.bintray.com/non/maven</url>
</repository>

<repository>
    <id>maven-repo</id>
    <name>maven-repo</name>
    <url>http://repo.maven.apache.org/maven2</url>
</repository>

<repository>
    <id>maven1-repo</id>
    <name>maven1-repo</name>
    <url>http://repo1.maven.org/maven2</url>
</repository>

<repository>
    <id>maven2-repo</id>
    <name>maven2-repo</name>
    <url>http://mvnrepository.com/artifact</url>
</repository>

</repositories>

```

Dependencies:
```xml
<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.6.1.4</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.6.1.4</version>
</dependency>
</dependencies>
```

### For Snapshot version

The snapshot contains the latest code in master branch.

**Note:** There maybe delay in updating this document, you can still find the snapshot version by checking https://github.com/gearpump/gearpump/blob/master/version.sbt

Repo:
```xml
<repositories>
<repository>
  <id>sonatype-nexus-releases</id>
  <name>Sonatype Nexus Snapshots</name>
  <url>https://oss.sonatype.org/content/repositories/snapshots</url>

</repository>

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

<repository>
    <id>vincent</id>
    <name>vincent</name>
    <url>http://dl.bintray.com/fvunicorn/maven</url>
</repository>

<repository>
    <id>non</id>
    <name>non</name>
    <url>http://dl.bintray.com/non/maven</url>
</repository>

<repository>
    <id>non</id>
    <name>non</name>
    <url>http://dl.bintray.com/non/maven</url>
</repository>

<repository>
    <id>maven-repo</id>
    <name>maven-repo</name>
    <url>http://repo.maven.apache.org/maven2</url>
</repository>

<repository>
    <id>maven1-repo</id>
    <name>maven1-repo</name>
    <url>http://repo1.maven.org/maven2</url>
</repository>

<repository>
    <id>maven2-repo</id>
    <name>maven2-repo</name>
    <url>http://mvnrepository.com/artifact</url>
</repository>

</repositories>

```

Dependencies:
```xml
<dependencies>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-core_2.11</artifactId>
<version>0.6.2-SNAPSHOT</version>
</dependency>
<dependency>
<groupId>com.github.intel-hadoop</groupId>
<artifactId>gearpump-streaming_2.11</artifactId>
<version>0.6.2-SNAPSHOT</version>
</dependency>
</dependencies>
```
