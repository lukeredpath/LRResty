require 'rubygems'
require 'sinatra'
require 'rack'
require 'thin'

$LOAD_PATH.unshift(File.dirname(__FILE__))

SERVICE_PORT = ENV['SERVICE_PORT'] || 10090

require 'simple_service'

set :daemonize, true

app = Rack::Builder.new do
  use Rack::Chunked
  map "/simple" do
    run SimpleService
  end
end

run app
