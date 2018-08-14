#!/bin/dash
# Iteratively begin Zookeeper instances, beginning at server #1

ZOOKEEPER_CLUSTER_COUNT=$1
DNS_LIST=$2
ZOOKEEPER_HOME="$3/zookeeper-3.4.13"

for i in `seq $ZOOKEEPER_CLUSTER_COUNT`; do
  if [ $i = 1 ]
  then
    sudo $ZOOKEEPER_HOME/bin/zkServer.sh start
    echo "Zookeeper started on first server"
    wait
  else
    CURRENT_DNS=$(echo $DNS_LIST | awk -F ',' '{print $'"$i"'}')
    echo "TRYING DNS $CURRENT_DNS"
    ssh -v -oStrictHostKeyChecking=no ubuntu@$CURRENT_DNS << EOF
      sudo $ZOOKEEPER_HOME/bin/zkServer.sh start
EOF
    echo "Zookeeper started on $CURRENT_DNS"
    wait
  fi
done
