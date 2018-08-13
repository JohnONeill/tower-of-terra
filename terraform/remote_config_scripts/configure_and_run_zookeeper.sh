ZOOKEEPER_CLUSTER_COUNT=$1
ZOOKEEPER_ID=$2
DNS_LIST=$3
ZOOKEEPER_HOME="$4/zookeeper-3.4.13"

# Writing all DNS values of all Zookeeper instances
# 2888 port is for ZK server to connect followers to leaders
# 3888 port is necessary because default leader election also uses TCP
SERVER_INDEX=0
for DNS in $(echo $DNS_LIST | sed "s/,/ /g")
do
  sudo sed -i '15i server.'"$SERVER_INDEX"'='"$DNS"':2888:3888' $ZOOKEEPER_HOME/conf/zoo.cfg
  SERVER_INDEX=$(($SERVER_INDEX+1))
done

sudo mkdir /var/lib/zookeeper
sudo chown -R ubuntu /var/lib/zookeeper
sudo touch /var/lib/zookeeper/myid
echo 'echo '"$ZOOKEEPER_ID"' >> /var/lib/zookeeper/myid' | sudo -s

# Run zookeeper
echo "Starting Zookeeper..."
# sudo nohup $ZOOKEEPER_HOME/bin/zkServer.sh start &
sudo $ZOOKEEPER_HOME/bin/zkServer.sh start

echo "Zookeeper is up and running!"
