require 'service_stub'

class SimpleService < Sinatra::Base
  
  get '/resource' do
    response_for(request.fullpath, "GET")
  end
  
  private
  
  def response_for(path, method)
    response_body = ServiceStub.response_for(path, method)
    [200, {"Content-Type" => "text/plain"}, response_body]
  rescue ServiceStub::MissingSpec
    [404, {"Content-Type" => "text/plain"}, "Not Found"]
  end
  
end
