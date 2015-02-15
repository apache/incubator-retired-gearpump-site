# Master HA

We allow to start master on multiple nodes. For example, if we start master on 5 nodes, then we can at most tolerate 2 master nodes failure. 

1. modify `core/src/main/resources/reference.conf` and set "gearpump.cluster.masters" to a list of master nodes.

  ```
  gearpump {
   ...
  cluster {
    masters = ["node1:3000", "node2:3000", "node3:3000"]
  }
  }
  ```

2. On node1, node2, node3, Start Master
  ```bash
  ## on node1
  bin/master -ip node1 -port 3000
  
  ## on node2
  bin/master -ip node2 -port 3000
  
  ## on node3
  bin/master -ip node3 -port 3000
  ```  

3. You can kill any node, the master HA will take effect. It can take up to 15 seconds for master node to fail-over. You can change the fail-over timeout time by setting `master.akka.cluster.auto-down-unreachable-after`
