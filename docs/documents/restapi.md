# Rest API

## GET appmaster/<appId>?detail=&lt;true|false&gt;
Query information of an specific application of Id appId

Example:
```bash
curl http://127.0.0.1:8090/appmaster/0
```

## DELETE appmaster/&lt;appId&gt;
shutdown application appId

## GET appmasters
Query information of all applications

Example:
```bash
curl http://127.0.0.1:8090/appmasters
```

## GET config/app/&lt;appId&gt;
Query the configuration of specific application appId

Example:
```bash
curl http://127.0.0.1:8090/config/app/0
```

## GET master
Get information of masters

Example:
```bash
curl http://127.0.0.1:8090/master
```

## GET metrics/app/&lt;appId&gt;/&lt;metrics path&gt;
Query metrics information of a specific application appId
Filter metrics with path metrics path

Example:
```bash
curl http://127.0.0.1:8090/metrics/app/0/app0.processor0
```

## GET workers/&lt;workerId&gt;
Get information of specific worker

Example:
```bash
curl http://127.0.0.1:8090/workers/4325324
```
The worker list can be returned by query master/ Rest service.

## GET workers
Get information of all workers.

Example:
```bash
curl http://127.0.0.1:8090/workers
```





