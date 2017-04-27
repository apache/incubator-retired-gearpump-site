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
