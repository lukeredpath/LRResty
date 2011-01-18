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
end

get "/requires/auth" do
  protected!
  [200, {}, "OK"]
end
