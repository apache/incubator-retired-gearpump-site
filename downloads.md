---
layout: global
---

## Downloads

### Latest Stable Release (v{{ site.GEARPUMP_VERSION }}) 

[Release Notes](https://github.com/gearpump/gearpump/releases)

* [Binary (for Scala 2.11)](https://github.com/gearpump/gearpump/releases/download/{{ site.GEARPUMP_VERSION }}/gearpump-2.11-{{ site.GEARPUMP_VERSION }}.zip)
* [Source code (.zip)](https://github.com/gearpump/gearpump/archive/{{ site.GEARPUMP_VERSION }}.zip)
* [Source code (.tar.gz)](https://github.com/gearpump/gearpump/archive/{{ site.GEARPUMP_VERSION }}.tar.gz)

*Note that as we have upgraded the Akka library to 2.4.x, which has dropped the Scala 2.10 support, we do NOT provide Gearpump build for Scala 2.10 since Gearpump 0.8.0.* 

## Maven Dependencies

To program against this version, you need to add below artifact dependencies to your application's Maven setting:

{% highlight xml %}
<dependencies>
  <dependency>
    <groupId>com.github.intel-hadoop</groupId>
    <artifactId>gearpump-core_2.11</artifactId>
    <version>{{ site.GEARPUMP_VERSION }}</version>
  </dependency>
  <dependency>
    <groupId>com.github.intel-hadoop</groupId>
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
