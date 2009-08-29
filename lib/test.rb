 
require 'drb/drb'
  
# The URI for the server to connect to
URI="druby://localhost:8787" 
  
class TimeServer
  
  def get_current_time
    return Time.now
  end
  
end
  
# The object that handles requests on the server
FRONT_OBJECT=TimeServer.new

$SAFE = 1   # disable eval() and friends

@service = DRb.start_service(URI, FRONT_OBJECT)

timeserver = DRbObject.new_with_uri(URI)
puts timeserver.get_current_time 

sleep 5
@service.stop_service