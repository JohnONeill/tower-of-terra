#!/bin/dash
# Iteratively begin Zookeeper instances, beginning at server #1

KEY_NAME=$1
ZOOKEEPER_CLUSTER_COUNT=$2
DNS_LIST=$3
ZOOKEEPER_HOME="$4/zookeeper-3.4.13"

echo "KEY_NAME $KEY_NAME"
sudo mv /tmp/${KEY_NAME} ~/.ssh/
sudo chmod 600 ~/.ssh/${KEY_NAME}

if ! [ -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -P ""
fi
sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

for i in `seq $ZOOKEEPER_CLUSTER_COUNT`; do
  if [ $i = 1 ]
  then
    sudo $ZOOKEEPER_HOME/bin/zkServer.sh start
    echo "Zookeeper started on first server"
  else
    CURRENT_DNS=$(echo $DNS_LIST | awk -F ',' '{print $'"$i"'}')
    cat ~/.ssh/id_rsa.pub | ssh -o "StrictHostKeyChecking no" -i ~/.ssh/${KEY_NAME} ubuntu@$CURRENT_DNS 'cat >> ~/.ssh/authorized_keys'
    echo "TRYING DNS $CURRENT_DNS"
    ssh -v -oStrictHostKeyChecking=no ubuntu@$CURRENT_DNS << EOF
      sudo $ZOOKEEPER_HOME/bin/zkServer.sh start
EOF
    echo "Zookeeper started on $CURRENT_DNS"
  fi
done

wait
