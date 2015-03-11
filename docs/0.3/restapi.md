# Rest API

## GET appmaster/<appId>?detail=&lt;true|false&gt;
Query information of an specific application of Id appId

Example:
```bash
curl http://127.0.0.1:8090/appmaster/2
```
Sample Response:
```
{
  "status": "active",
  "appId": 2,
  "appName": "wordCount",
  "appMasterPath": "akka.tcp://app2-executor-1@127.0.0.1:62525/user/daemon/appdaemon2/$c",
  "workerPath": "akka.tcp://master@127.0.0.1:3000/user/Worker1",
  "submissionTime": "1425925651057",
  "startTime": "1425925653433",
  "user": "foobar"
}
```


## DELETE appmaster/&lt;appId&gt;
shutdown application appId

## GET appmasters
Query information of all applications

Example:
```bash
curl http://127.0.0.1:8090/appmasters
```
Sample Response:
```
{
  "appMasters": [
    {
      "status": "active",
      "appId": 1,
      "appName": "dag",
      "appMasterPath": "akka.tcp://app1-executor-1@127.0.0.1:62498/user/daemon/appdaemon1/$c",
      "workerPath": "akka.tcp://master@127.0.0.1:3000/user/Worker1",
      "submissionTime": "1425925483482",
      "startTime": "1425925486016",
      "user": "foobar"
    }
  ]
}
```

## GET config/app/&lt;appId&gt;
Query the configuration of specific application appId

Example:
```bash
curl http://127.0.0.1:8090/appmaster/1
```
Sample Response:
```
{
  "status": "active",
  "appId": 1,
  "appName": "dag",
  "appMasterPath": "akka.tcp://app1-executor-1@127.0.0.1:62670/user/daemon/appdaemon1/$c",
  "workerPath": "akka.tcp://master@127.0.0.1:3000/user/Worker1",
  "submissionTime": "1425926523047",
  "startTime": "1425926525533",
  "user": "foobar"
}

```

## GET master
Get information of masters

Example:
```bash
curl http://127.0.0.1:8090/master
```
Sample Response:
```
{
  "masterDescription": {
    "leader": [
      "master@127.0.0.1",
      3000
    ],
    "cluster": [
      [
        "127.0.0.1",
        3000
      ]
    ],
    "aliveFor": "642941",
    "logFile": "/Users/foobar/gearpump/logs",
    "jarStore": "jarstore/",
    "masterStatus": "synced",
    "homeDirectory": "/Users/foobar/gearpump"
  }
}
```

## GET metrics/app/&lt;appId&gt;/&lt;metrics path&gt;
Query metrics information of a specific application appId
Filter metrics with path metrics path

Example:
```bash
curl http://127.0.0.1:8090/metrics/app/3/app3.processor2
```
Sample Response:
```
{
  "appId": 3,
  "path": "app3.processor2",
  "metrics": []
}
```

## GET workers/&lt;workerId&gt;
Get information of specific worker

Example:
```bash
curl http://127.0.0.1:8090/workers/1096497833
```
Sample Response
```
{
  "workerId": 1096497833,
  "state": "active",
  "actorPath": "akka.tcp://master@127.0.0.1:3000/user/Worker0",
  "aliveFor": "77042",
  "logFile": "/Users/foobar/gearpump/logs",
  "executors": [],
  "totalSlots": 100,
  "availableSlots": 100,
  "homeDirectory": "/Users/foobar/gearpump"
}
```

The worker list can be returned by query master/ Rest service.

## GET workers
Get information of all workers.

Example:
```bash
curl http://127.0.0.1:8090/workers
```
Sample Response:
```
[
  {
    "workerId": 307839464,
    "state": "active",
    "actorPath": "akka.tcp://master@127.0.0.1:3000/user/Worker0",
    "aliveFor": "18445",
    "logFile": "/Users/foobar/gearpump/logs",
    "executors": [],
    "totalSlots": 100,
    "availableSlots": 100,
    "homeDirectory": "/Users/foobar/gearpump"
  },
  {
    "workerId": 485240986,
    "state": "active",
    "actorPath": "akka.tcp://master@127.0.0.1:3000/user/Worker1",
    "aliveFor": "18445",
    "logFile": "/Users/foobar/gearpump/logs",
    "executors": [],
    "totalSlots": 100,
    "availableSlots": 100,
    "homeDirectory": "/Users/foobar/gearpump"
  }
]
```





