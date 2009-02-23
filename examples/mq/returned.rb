
#
# This example demonstrates how to handle returns of undeliverable
# messages (when published with "immediate" flag) or unroutable
# messages (when published with "mandatory" flag)
#

$:.unshift File.dirname(__FILE__) + '/../../lib'
require 'mq'

EM.run {
    AMQP.start :logging => true

    amq = MQ.new
    MQ.message_returned { |msg|
      p "Broker returned a message"
      p msg.reply_code
      p msg.reply_text
      p msg.original_header
      p msg.original_body
    }

    # attempting to publish to a non-existent exchange with 
    # "immediate" flag set to true
    amq.topic("test_topic_exch_does_not_exist").publish("test",
        :key => 'foo.bar.baz', :immediate => true)

    EM.add_timer(1) {
        AMQP.stop { EM.stop }
    }
}



