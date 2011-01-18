### Used by CookieHandlingTests.m

TEST_COOKIE_NAME = "TestCookie"

get("/sets/cookie") do
  response.set_cookie("TestCookie",
    :value  => "CookieValue", 
    :domain => "localhost", 
    :path   => "/requires/cookie"
  )
  [200, {}, ""]
end

get("/requires/cookie") do
  if request.cookies[TEST_COOKIE_NAME]
    [200, {'Content-Type' => "text/plain"}, "Got cookie #{request.cookies[TEST_COOKIE_NAME]}"]
  else
    [403, {'Content-Type' => "text/plain"}, "Missing cookie"]
  end
end
