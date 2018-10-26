This simple script provisions a Docker Swarm on AWS using Docker Machine.

## Prerequisites

You need to have an Amazon EC2 account.
Store your EC2 credentials (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`)
in the environment. You can also refer to the
[Docker guide](https://docs.docker.com/machine/drivers/aws/) for details.

Additionally, the common options `COMMON_OPTS` will need to be modified
according to details of your AWS.

## How to run

To execute, you can run `./run.sh`.

##STEPS TO SETUP DOCKER-SWARM WITH NEO4J-ENTERPRISE

1. Run `./run.sh`.

2. eval `"$(docker-machine env manager0)"` - sets the manager node in terminal instance

3. `docker swarm init`
Message we get:

To add a worker to this swarm, run the following command:

    `docker swarm join --token SWMTKN-1-2z7z4mdvw4o4evm7t7ulos6fec0wee1d2hec9z8chtkiy7ehod-84fkm6s6om7s2xf2vijkmejlm 10.0.0.254:2377`

To add a manager to this swarm, run `'docker swarm join-token manager'` and follow the instructions.

4. switch to the other workers like:
eval `"$(docker-machine env worker0)"` - sets the worker node in terminal instance

Run: `docker swarm join --token SWMTKN-1-2z7z4mdvw4o4evm7t7ulos6fec0wee1d2hec9z8chtkiy7ehod-84fkm6s6om7s2xf2vijkmejlm 10.0.0.254:2377`

##Adds the workers to the swarm manager


##Using this:

`docker service create --name neo4j --replicas=3 --publish 7474:7474 --publish 7473:7473 --publish 7687:7687 --env=NEO4J_ACCEPT_LICENSE_AGREEMENT=yes --mount type=bind,source=/home/ubuntu/neo4j-data,target=/data --mount type=bind,src=/home/ubuntu/neo4j-plugins,dst=/var/lib/neo4j/plugins neo4j:3.3.5-enterprise`


##SSH into docker machine:
`docker-machine ssh manager0`

##SSH into container:
`docker exec -it <container name> /bin/bash`

##Copy from local to docker machine:
`docker-machine scp neo4j-plugins/neo4j-spatial-0.25.5-neo4j-3.3.5-server-plugin.jar manager0:/home/ubuntu/plugins/`

##Copy from local to docker container:
`docker cp neo4j-plugins/ 70464be008e1:/var/lib/neo4j/plugins`

##Stop neo4j in a docker container:
`docker exec --interactive 7746515e13d3 bin/neo4j stop`


##Interactive docker mode for neo4j:
`docker run --env=NEO4J_ACCEPT_LICENSE_AGREEMENT=yes  --publish=7474:7474 --publish=7687:7687 --volume=$HOME/data:/data --volume=$HOME/neo4j_plugins:/var/lib/neo4j/plugins --ulimit=nofile=40000:40000 -d -it neo4j:3.3.5-enterprise`

##Dumping Neo4j DB from local docker container to dump file:
`docker run --name=neo4j-dump --mount type=bind,source=$HOME/data,target=/data -it -d neo4j:3.3.5-enterprise neo4j bin/neo4j-admin dump --database=graph.db --to=/graph.db.dump`
