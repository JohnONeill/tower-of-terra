const producer = require("./producer.js");

do {
  console.log('sending record!');
  producer.Kafka.sendRecord({
    type: 'sample_type',
    userId: 'sample_user_id',
    sessionId: 'sample_session_id',
    data: 'sample_data'
  });
} while (true);
