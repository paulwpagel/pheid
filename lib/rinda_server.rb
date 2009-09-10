module Rinda
  class RindaServer
    attr_reader :frequency, :port
    attr_accessor :service, :running, :tuplespace
    
    def initialize(options = {})
      @port = options[:port]
      @frequency = options[:frequency]
      @running = false
    end
    
    def start
      @service = DRb.start_service("druby://localhost:#{@port}", @tuplespace)
      @running = true
    end
    
    def stop
      @service.stop_service
      @running = false
    end
    
    def running?
      return running
    end
  end
end