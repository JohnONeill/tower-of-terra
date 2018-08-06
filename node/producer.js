const kafka = require("kafka-node");
const uuid = require("uuid");
const getCSV = require("get-csv");
const _ = require("lodash");

const client = new kafka.Client("localhost:2181", "my-client-id", {
  sessionTimeout: 300,
  spinDelay: 100,
  retries: 2
});

const producer = new kafka.HighLevelProducer(client);
producer.on("ready", () => {
  console.log("Kafka Producer is connected and ready.");

  console.log('getting csv');
  getCSV('https://s3-us-west-2.amazonaws.com/insight-jo-data-source-bucket/US.7180009.csv')
    .then((rows) => {
      var num_rows = rows.length;
      console.log(num_rows);
      for (var i = 0; i < 10; i++) {
        KafkaService.sendRecord(
        rows[i],
        (err, result) => {
          console.log('sent!', result);
        });
      }
    });
});

// For this demo we just log producer errors to the console.
producer.on("error", function(error) {
  console.error(error);
});

const KafkaService = {
  sendRecord: (row, callback = () => {}) => {

    const event = _.merge(
      {
        id: uuid.v4(),
        timestamp: Date.now(),
      },
      row
    );

    const buffer = new Buffer.from(JSON.stringify(event));

    // Create a new payload
    const record = [
      {
          topic: "my-sample-topic",
          messages: buffer,
          attributes: 1 /* Use GZip compression for the payload */
      }
    ];

    //Send record to Kafka and log result/error
    producer.send(record, callback);
  }
};

module.exports.KafkaService = KafkaService;
