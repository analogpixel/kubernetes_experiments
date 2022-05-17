#!/usr/bin/env python

import kafka

# consumer = kafka.KafkaConsumer(group_id='test', bootstrap_servers=['gc-kafkalocal-01', 'gc-kafkalocal-01'])
# consumer = kafka.KafkaConsumer(group_id='test', bootstrap_servers=['localhost:4040', 'localhost:4041', 'localhost:4042'])
client = kafka.KafkaClient(group_id='test', bootstrap_servers=['localhost:4040', 'localhost:4041', 'localhost:4042'])


print( client.cluster.config )
