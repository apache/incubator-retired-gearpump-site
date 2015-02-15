# DAG

An application is a DAG of processors. Each processor handles messages.

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/dag.png)

At runtime, each processor can be parallelized to a list of tasks; each task is an actor within the data pipeline. Data is passed between tasks. The Partitioner defines how data is transferred.

![](https://raw.githubusercontent.com/intel-hadoop/gearpump/master/doc/shuffle.png)

We have an easy syntax to express the computation. To represent the DAG above, we define the computation as:

   ```
   Graph(A~>B~>C~>D, A~> C, B~>E~>D)
   ```

`A~>B~>C~>D` is a Path of Processors, and Graph is composed of this Path list. This representation should be cleaner than that of vertex and edge set.


