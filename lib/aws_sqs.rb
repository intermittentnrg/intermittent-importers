require 'aws-sdk-sqs'

module AwsSqs
  def self.included(klass)
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def each
      sqs = Aws::SQS::Client.new(region: self::QUEUE_REGION)
      receipt_handles = []
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      loop do
        result = sqs.receive_message({
                                       queue_url: self::QUEUE_URL,
                                       max_number_of_messages: 10,
                                       visibility_timeout: self::MAX_RUNTIME,
                                       wait_time_seconds: 0 # Do not wait to check for the message.
                                     })
        result.messages.each do |message|
          body = message.body
          yield new(body)

          receipt_handles << message.receipt_handle
        end

        # If it runs for more than 10 mins already processed messages can become visible again.
        break if (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) >= self::MAX_RUNTIME

        break if result.messages.length <10
      end
      i=0
      receipt_handles.each_slice(10) do |batch|
        sqs.delete_message_batch({
                                   queue_url: self::QUEUE_URL,
                                   entries: batch.map do |receipt_handle|
                                     {
                                       id: (i += 1).to_s,
                                       receipt_handle:
                                     }
                                   end
                                 })
      end
      logger.info "deleted #{receipt_handles.length} from SQS"
    end
  end
end
