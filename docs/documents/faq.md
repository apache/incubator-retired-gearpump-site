## FAQ

#### Why we name it GearPump?

The name GearPump is a reference the engineering term "Gear Pump", which is a super simple pump that consists of only two gears, but is very powerful at streaming water from left to right.

#### Why not using akka persistence to store the checkpoint file?

1. We only checkpoint file to disk when necessary.(not record level) 
2. We have custom checkpoint file format

#### Have you considered the akka stream API for the high level DSL?

We are looking into a hands of candidate for what a good DSL should be. Akka stream API is one of the candidates.

####Why wrapping the Task, instead of using the Actor interface directly? 

1. It is more easy to conduct Unit test 
2. We have custom logic and messages to ensure the data consistency, like flow control, like message loss detection. 
3. As the Gearpump interface evolves rapidly. for now, we want to conservative in exposing more powerful functions so that we doesn't tie our hands for future refactory, it let us feel safe.

#### What is the open source plan for this project?
The ultimate goal is to make it an Apache project.
