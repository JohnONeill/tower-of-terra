const kafka = require("kafka-node");
const uuid = require("uuid");

const client = new kafka.Client("localhost:2181", "my-client-id", {
  sessionTimeout: 300,
  spinDelay: 100,
  retries: 2
});

const producer = new kafka.HighLevelProducer(client);
producer.on("ready", () => {
  console.log("Kafka Producer is connected and ready.");

  for (var i = 0; i < 100; i++) {
    console.log('here! (' + i + ')');
    KafkaService.sendRecord({
      type: 'sample_type',
      userId: 'sample_user_id',
      sessionId: 'sample_session_id',
      data: 'sample_data'
    },
    (result) => {
      console.log('sent!', result);
    });
  }
});

// For this demo we just log producer errors to the console.
producer.on("error", function(error) {
  console.error(error);
});

const KafkaService = {
  sendRecord: ({ type, userId, sessionId, data }, callback = () => {}) => {
    if (!userId) {
      return callback(new Error(`A userId must be provided.`));
    }

    const event = {
      id: uuid.v4(),
      timestamp: Date.now(),
      userId: userId,
      sessionId: sessionId,
      type: type,
      data: data
    };

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
