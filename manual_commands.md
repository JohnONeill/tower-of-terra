(things to automate!)

ec2-34-212-3-75.us-west-2.compute.amazonaws.com

ssh -v -i ~/.ssh/john-oneill-IAM-keypair.pem ubuntu@ec2-34-212-3-75.us-west-2.compute.amazonaws.com

# Kafka!

### copy over kafka
scp -r -i ~/.ssh/john-oneill-IAM-keypair.pem kafka ubuntu@ec2-34-212-3-75.us-west-2.compute.amazonaws.com:~/.

### installing java on zookeeper machine (while sshed in)
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer

### uninstall
(old) sudo apt-get -y install openjdk-6-jre-headless
sudo apt-get remove openjdk-6-jre-headless

### starting zookeeper (sshed into the kafka machine)
~/kafka/bin/zookeeper-server-start.sh ~/kafka/config/zookeeper.properties

### starting kafka server (sshed into the kafka machine)
~/kafka/bin/kafka-server-start.sh ~/kafka/config/server.properties

### starting kafka producer (sshed into the kafka machine)
~/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic my-sample-topic

### starting simple kafka consumer (sshed into the kafka machine)
~/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --from-beginning --topic my-sample-topic

### starting complicated kafka consumer (sshed into the kafka machine)
~/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092     --topic my-sample-topic --from-beginning     --formatter kafka.tools.DefaultMessageFormatter     --property print.key=true     --property print.value=true     --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer     --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer

## consumer
~/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-sample-topic --from-beginning

### create topic
~/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic my-sample-topic

### list topics
bin/kafka-topics.sh --list --zookeeper localhost:2181

### describe
~/kafka/bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic my-replicated-topic




# nodejs!
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

### scp node stuff
### exclude node_modules!
scp -r -i ~/.ssh/john-oneill-IAM-keypair.pem node/package.json ubuntu@ec2-34-212-3-75.us-west-2.compute.amazonaws.com:~/node
scp -r -i ~/.ssh/john-oneill-IAM-keypair.pem node/index.js ubuntu@ec2-34-212-3-75.us-west-2.compute.amazonaws.com:~/node
scp -r -i ~/.ssh/john-oneill-IAM-keypair.pem node/producer.js ubuntu@ec2-34-212-3-75.us-west-2.compute.amazonaws.com:~/node

### sshed in
sudo apt-get update
sudo apt-get install make
sudo apt-get install g++
cd node
npm install



# important ssh stuff
to remove output when ssh-ing in (it was breaking scp):
sudo chmod -x /etc/update-motd.d/*

silence login:
touch .hushlogin
(didn't seem to actually help)
