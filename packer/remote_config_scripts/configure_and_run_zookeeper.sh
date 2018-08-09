# @TODO: pass down zookeeper name as well
# @TODO: not 100% sure why these indexes are off by one
#        (running locally vs via terraform provisioner)
ZOOKEEPER_HOME="$1/zookeeper-3.4.13"
UTILS_SHELL_PATH=$2
ZOOKEEPER_ID=$3
DNS=$4

# UTILS_ROOT=$(dirname ${BASH_SOURCE})/../../../utils/shell
# echo "UTILS ROOT: $UTILS_ROOT"
# @TODO: transfer this tmp path over more elegantly
source $UTILS_SHELL_PATH/colors.sh

# Copy sample configuration into normal position
# @TODO: why do these need to be sudo?
echo "${color_magenta}Setting and adjusting zoo config file...${color_norm}"
sudo cp $ZOOKEEPER_HOME/conf/zoo_sample.cfg $ZOOKEEPER_HOME/conf/zoo.cfg
sudo sed -i 's@/tmp/zookeeper@/var/lib/zookeeper@g' $ZOOKEEPER_HOME/conf/zoo.cfg
sudo sed -i '15i server.'"$ZOOKEEPER_ID"'='"$DNS"':2888:3888' $ZOOKEEPER_HOME/conf/zoo.cfg

# Run zookeeper!
echo "${color_magenta}Running zookeeper...${color_norm}"
sudo mkdir /var/lib/zookeeper
sudo chown -R ubuntu /var/lib/zookeeper
sudo touch /var/lib/zookeeper/myid
echo 'echo '"$ZOOKEEPER_ID"' >> /var/lib/zookeeper/myid' | sudo -s
