require 'service_stub'

class SimpleService < Sinatra::Base
  
  get '/resource' do
    response_for("GET")
  end
  
  private
  
  def response_for(method)
    response_body = ServiceStub.response_for(request, method)
    [200, {"Content-Type" => "text/plain"}, response_body]
  rescue ServiceStub::MissingSpec
    [404, {"Content-Type" => "text/plain"}, "Not Found"]
  rescue StandardError => e # html error pages don't help me here
    [500, {"Content-Type" => "text/plain"}, e.message]
  end
  
end
