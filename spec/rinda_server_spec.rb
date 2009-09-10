require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "rinda_server"

class InMemoryTupleSpace
  
  def test
    return true
  end
end

describe Rinda::RindaServer do
  
  before(:each) do
    @server = Rinda::RindaServer.new({:port => 9332, :frequency => 0.5})
    @drb_service = mock(DRb)
  end
  
  def start_pheid
    thread_exception = nil
    @rinda_thread = Thread.new do
      begin
        @server.start
      rescue Exception => e
        thread_exception = e
        puts e
        puts e.backtrace
      end
    end
    
    while(!@server.running? and !thread_exception)
      Thread.pass
    end
  end
  
  def stop_pheid
    @server.stop
    @rinda_thread.join(1) if @rinda_thread
  end
  
  it "should have port and frequency period" do
    @server.port.should eql(9332)
    @server.frequency.should == 0.5
  end
  
  it "should not be running to start" do
    @server.running.should be_false
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
    
    drb_tuplespace = DRbObject.new_with_uri('druby://localhost:9332')
    drb_tuplespace.test.should be_true
    @server.stop
  end

  it "should process a request asynchronously on the server" do
    tuplespace = InMemoryTupleSpace.new
    @server.tuplespace = tuplespace
    start_pheid
    
    drb_tuplespace = DRbObject.new_with_uri('druby://localhost:9332')
    drb_tuplespace.test.should be_true
    stop_pheid
  end
  
end