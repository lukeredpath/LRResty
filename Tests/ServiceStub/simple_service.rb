class SimpleService < Sinatra::Base
  
  get '/resource' do
    "plain text response"
  end
  
end
