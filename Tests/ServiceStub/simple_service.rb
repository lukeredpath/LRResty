require 'service_stub'
require 'json'

class SimpleService < Sinatra::Base
  
  get '/resource' do
    with_error_handling do
      response_for("GET")
    end
  end
  
  post '/echo' do
    with_error_handling do
      [200, {'Content-Type' => "text/plain"}, "you said #{request.body.read}"]
    end
  end
  
  post "/accepts_only_json" do
    with_error_handling do
      if request.env["HTTP_ACCEPT"] =~ /application\/json/
        [200, {'Content-Type' => 'application/json'}, {'it' => 'worked'}.to_json]
      else
        [406, {'Content-Type' => 'application/json'}, {'error' => 'Not Acceptable'}.to_json]
      end
    end
  end
  
  private
  
  def response_for(method)
    response_body = ServiceStub.response_for(request, method)
    [200, {"Content-Type" => "text/plain"}, response_body]
  rescue ServiceStub::MissingSpec
    [404, {"Content-Type" => "text/plain"}, "Not Found"]
  end
  
  def with_error_handling(&block)
    begin
      return yield
    rescue StandardError => e # html error pages don't help me here
      return [500, {"Content-Type" => "text/plain"}, e.message]
    end
  end
  
end
