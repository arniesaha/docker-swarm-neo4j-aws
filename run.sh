#!/bin/bash
# ref:
# http://blog.scottlowe.org/2016/03/25/docker-swarm-aws-docker-machine/
# https://docs.docker.com/machine/drivers/aws/
# https://docs.docker.com/swarm/provision-with-machine/

set -e
COMMON_OPTS=" --amazonec2-region ap-south-1 --amazonec2-zone b --amazonec2-vpc-id vpc-06b2e83a5226907e5 \
--amazonec2-security-group default --amazonec2-instance-type m4.large"


# WORKER_COMMON_OPTS=" --amazonec2-region ap-south-1 --amazonec2-zone b --amazonec2-vpc-id vpc-06b2e83a5226907e5 \
# --amazonec2-security-group default --amazonec2-instance-type m4.large"

TOKEN_SERVER_COMMON_OPTS=" --amazonec2-region ap-south-1 --amazonec2-zone b --amazonec2-vpc-id vpc-06b2e83a5226907e5 \
--amazonec2-security-group default"



docker-machine rm -f tokenserver
docker-machine rm -f manager0
docker-machine rm -f worker0
docker-machine rm -f worker1

echo "---- creating swarm token server"
docker-machine create -d amazonec2 $TOKEN_SERVER_COMMON_OPTS tokenserver
eval $(docker-machine env tokenserver)
swarm_token=$(docker run swarm create)
echo "-- swarm token is $swarm_token"
SWARM_OPTS=" --swarm --swarm-discovery token://${swarm_token} "
echo "---- creating swarm manager"
docker-machine create -d amazonec2 \
               $COMMON_OPTS \
               $SWARM_OPTS \
               --swarm-master \
               manager0

echo "---- creating swarm workers"

docker-machine create -d amazonec2 \
               $COMMON_OPTS \
               $SWARM_OPTS \
               worker0
docker-machine create -d amazonec2 \
               $COMMON_OPTS \
               $SWARM_OPTS \
               worker1
docker-machine ls

echo "---- to connect to the swarm manager, we will run the following: \
eval $(docker-machine env --swarm manager0)"
eval $(docker-machine env --swarm manager0)

# echo "---- now we run Neo4j Enterprise on manager0"
# docker run --env=NEO4J_ACCEPT_LICENSE_AGREEMENT=yes  --publish=7474:7474 --publish=7687:7687 --volume=$HOME/neo4j-refactor/data:/data --volume=$HOME/neo4j_plugins:/var/lib/neo4j/plugins --ulimit=nofile=40000:40000 -d neo4j:3.3.5-enterprise

echo "---- the container has been started. details of the worker where its running are printed below:"
docker ps -a

MANAGER0_IP=$(docker-machine inspect manager0 -f "{{ .Driver.IPAddress }}")
echo "---- manager0 IP address is at $MANAGER0_IP. "
