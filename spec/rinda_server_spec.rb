require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "rinda_server"

class InMemoryTupleSpace
  
  def test
    return true
  end
end

describe Rinda::RindaServer do
  
  @server_thread = Thread.new do 
    begin
      @server.start 
    rescue Exception => e
      thread_exception = e
      puts e
    end
  end
  
  before(:each) do
    @server = Rinda::RindaServer.new({:port => 9333, :frequency => 0.5})
    @drb_service = mock(DRb)
  end

  it "should have port and frequency period" do
    @server.port.should eql(9333)
    @server.frequency.should == 0.5
  end
  
  it "should stop the service" do
    @server.service = @drb_service
    @server.running = true
    @drb_service.should_receive(:stop_service)

    @server.stop

    @server.running.should be_false
  end
  
  it "should request drb object from the server" do
    tuplespace = InMemoryTupleSpace.new
    @server.tuplespace = tuplespace
    @server.start
    
    drb_tuplespace = DRbObject.new_with_uri('druby://localhost:9333')
    drb_tuplespace.test.should be_true
  end

  it "should process a request asynchronously on the server" do
    tuplespace = InMemoryTupleSpace.new
    @server.tuplespace = tuplespace
    @server.start
    
    drb_tuplespace = DRbObject.new_with_uri('druby://localhost:9333')
    drb_tuplespace.test.should be_true
  end
  
end