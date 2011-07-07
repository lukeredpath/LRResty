### Used by CookieHandlingTests.m

TEST_COOKIE_NAME = "TestCookie"

get "/sets/cookie" do
  response.set_cookie("TestCookie",
    :value  => "CookieValue", 
    :domain => "localhost", 
    :path   => "/requires/cookie"
  )
  [200, {}, ""]
end

get "/requires/cookie" do
  if request.cookies[TEST_COOKIE_NAME]
    [200, {'Content-Type' => "text/plain"}, "Got cookie #{request.cookies[TEST_COOKIE_NAME]}"]
  else
    [403, {'Content-Type' => "text/plain"}, "Missing cookie"]
  end
end

### Used by AuthenticationTests.m

helpers do
  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end
  
  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['testuser', 'testpass']
  end
  
  def stream(content)
    streamer = StringStreamer.new(content)
    [200, {"Content-Type" => "text/plain", "Connection" => "keep-alive"}, streamer]
  end
end

get "/requires/auth" do
  protected!
  [200, {}, "OK"]
end


### Used by StreamingTests.m

get '/streaming' do
  stream("the quick brown fox jumped over the lazy dog")
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


### Used by all synchronous tests

%w{get post put delete head}.each do |verb|
  send(verb, "/synchronous/echo") do
    echo_request!(:plist)
  end
end

### Used by TimeoutTests.m

post "/long/request" do
  sleep_time = (params[:sleep] || 0).to_i
  sleep(sleep_time)
  [200, {}, ""]
end

### Used by RetryTests.m

enable :sessions

get "/optional/failure" do
  session[:failure_count] ||= 0
  succeed_after = (params[:succeed_after] || "0").to_i
  
  if session[:failure_count] < succeed_after
    session[:failure_count] += 1

    [500, {"X-Number-Of-Retries" => session[:failure_count].to_s, "X-Succeed-After" => succeed_after.to_s}, ""]
  else
    session[:failure_count] = 0
    
    [200, {"X-Number-Of-Retries" => (session[:failure_count] + 1).to_s}, ""]
  end
end
