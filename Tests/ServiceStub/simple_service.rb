require 'service_stub'
require 'json'

class SimpleService < Sinatra::Base
  TEST_USER = 'testuser'
  TEST_PASS = 'testpass'
  
  get '/resource' do
    with_error_handling do
      response.set_cookie("TestCookie", "CookieValue")
      response_for("GET")
    end
  end
  
  get '/requires_cookie' do
    with_error_handling do
      if request.cookies['TestCookie']
        [200, {'Content-Type' => "text/plain"}, "Got cookie #{request.cookies['TestCookie']}"]
      else
        [403, {'Content-Type' => "text/plain"}, "Missing cookie"]
      end
    end
  end

  get '/requires_auth' do
    with_error_handling do
      protected!
      response_for("GET")
    end
  end
  
  get '/streaming' do
    with_error_handling do
      stream(response_for("GET").last)
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
  
  post "/form_handler" do
    with_error_handling do
      [200, {'Content-Type' => 'application/json'}, "posted params #{params.inspect}"]
    end
  end
  
  put '/echo' do
    with_error_handling do
      [200, {'Content-Type' => "text/plain"}, "you said #{request.body.read}"]
    end
  end
  
  put "/accepts_only_json" do
    with_error_handling do
      if request.env["HTTP_ACCEPT"] =~ /application\/json/
        [200, {'Content-Type' => 'application/json'}, {'it' => 'worked'}.to_json]
      else
        [406, {'Content-Type' => 'application/json'}, {'error' => 'Not Acceptable'}.to_json]
      end
    end
  end
  
  put "/form_handler" do
    with_error_handling do
      [200, {'Content-Type' => 'application/json'}, "PUT params #{params.inspect}"]
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
  
  def stream(content)
    streamer = StringStreamer.new(content)
    [200, {"Content-Type" => "text/plain", "Connection" => "keep-alive"}, streamer]
  end
  
  class StringStreamer
    def initialize(string)
      @string = string
    end
    
    def each(&block)
      @string.split(" ").each do |chunk|
        yield chunk + "\n"
        sleep 0.1
      end
    end
    
    def length
      @string.split(" ").length + @string.length
    end
  end
  
  helpers do
    def protected!
      response['WWW-Authenticate'] = %(Basic realm="Testing HTTP Auth")
      throw(:halt, [401, "Not authorized\n"]) and return unless authorized?
    end

    def authorized?
      auth ||=  Rack::Auth::Basic::Request.new(request.env)
      auth.provided? && auth.basic? && auth.credentials && auth.credentials == [TEST_USER, TEST_PASS]
    end
  end
  
end
