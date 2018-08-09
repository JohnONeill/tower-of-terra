ZOOKEEPER_CLUSTER_COUNT=$1
ZOOKEEPER_ID=$2
DNS_LIST=$3
# @TODO: pass down zookeeper name as well
# @TODO: not 100% sure why these indexes are off by one
#        (running locally vs via terraform provisioner)
ZOOKEEPER_HOME="$4/zookeeper-3.4.13"

# Copy sample configuration into normal position
# @TODO: why do these need to be sudo?
# echo "${color_magenta}Setting and adjusting zoo config file...${color_norm}"
echo "Setting and adjusting Zookeeper configuration..."
sudo cp $ZOOKEEPER_HOME/conf/zoo_sample.cfg $ZOOKEEPER_HOME/conf/zoo.cfg
sudo sed -i 's@/tmp/zookeeper@/var/lib/zookeeper@g' $ZOOKEEPER_HOME/conf/zoo.cfg

# Writing all DNS values of all Zookeeper instances
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
echo "Running Zookeeper..."
# . ~/.profile; zkServer.sh start
sudo $ZOOKEEPER_HOME/bin/zkServer.sh start

echo "Zookeeper is up and running!"
