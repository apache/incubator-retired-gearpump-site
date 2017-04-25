---
layout: global
---

## Downloads

### Current {{ site.GEARPUMP_VERSION }} Release (v{{ site.GEARPUMP_VERSION }}) 

[Release Notes](https://issues.apache.org/jira/secure/ReleaseNote.jspa?projectId=12319920&version=12338681)

* [The source and binary tarballs, including signatures, digests, etc.](https://dist.apache.org/repos/dist/release/incubator/gearpump/{{ site.GEARPUMP_VERSION }}-incubating/)

*Note that as we have upgraded the Akka library to 2.4.x, which has dropped the Scala 2.10 support, we do NOT provide Gearpump build for Scala 2.10 since Gearpump 0.8.0.* 

## Maven Dependencies

To program against this version, you need to add below artifact dependencies to your application's Maven setting:

{% highlight xml %}
<dependencies>
  <dependency>
    <groupId>org.apache.gearpump</groupId>
    <artifactId>gearpump-core_2.11</artifactId>
    <version>{{ site.GEARPUMP_VERSION }}</version>
  </dependency>
  <dependency>
    <groupId>org.apache.gearpump</groupId>
    <artifactId>gearpump-streaming_2.11</artifactId>
    <version>{{ site.GEARPUMP_VERSION }}</version>
  </dependency>
</dependencies>
{% endhighlight %}

To ensure above dependencies resolved, you will need to add the following repositories as well.

{% if site.GEARPUMP_VERSION contains "SNAPSHOT" %}
{% highlight xml %}
<repositories>
  <repository>
    <id>apache-repo</id>
    <name>Apache Maven Repo</name>
    <url>https://repository.apache.org/content/repositories/snapshots</url>
  </repository>
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
{% endhighlight %}
{% else %}
{% highlight xml %}
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
{% endhighlight %}
{% endif %}
