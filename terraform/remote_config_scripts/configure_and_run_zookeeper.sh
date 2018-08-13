#!/bin/dash

ZOOKEEPER_CLUSTER_COUNT=$1
ZOOKEEPER_ID=$(echo "$2+1" | bc)
DNS_LIST=$3
ZOOKEEPER_HOME="$4/zookeeper-3.4.13"

# Writing all DNS values of all Zookeeper instances
# 2888 port is for ZK server to connect followers to leaders
# 3888 port is necessary because default leader election also uses TCP
for i in `seq $ZOOKEEPER_CLUSTER_COUNT`; do
    SERVER_INDEX=$(echo "$ZOOKEEPER_CLUSTER_COUNT-$i+1" | bc)
    CURRENT_DNS=$(echo $DNS_LIST | awk -F ',' '{print $'"$SERVER_INDEX"'}')
    echo "Running: sed -i '15i server.'"$SERVER_INDEX"'='"$CURRENT_DNS"':2888:3888' $ZOOKEEPER_HOME/conf/zoo.cfg"
    sudo sed -i '15i server.'"$SERVER_INDEX"'='"$CURRENT_DNS"':2888:3888' $ZOOKEEPER_HOME/conf/zoo.cfg
done

sudo mkdir /var/lib/zookeeper
sudo chown -R ubuntu /var/lib/zookeeper
sudo touch /var/lib/zookeeper/myid
echo 'echo '"$ZOOKEEPER_ID"' >> /var/lib/zookeeper/myid' | sudo -s

# Run zookeeper
echo "Starting Zookeeper..."
# @TODO: this didn't seem to work: sudo nohup $ZOOKEEPER_HOME/bin/zkServer.sh start &
sudo $ZOOKEEPER_HOME/bin/zkServer.sh start

echo "Zookeeper is up and running!"
