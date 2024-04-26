module Pump
  class Process
    include SemanticLogger::Loggable
    def initialize(source)
      @source = source
    end

    def run
      @source.parsers_each do |e|
        e.process
      rescue EmptyError
        logger.warn "empty response", $!
      end
    end
  end
end
