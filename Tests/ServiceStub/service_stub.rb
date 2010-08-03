require 'plist'

class ServiceStub
  class MissingSpec < RuntimeError; end
  
  def self.response_for(request, method)
    response_spec = spec.find do |spec|
      (spec['method'] == method &&
       spec['path']   == request.fullpath &&
       spec['headers'].all? do |header, value|
         request.env[http_header(header)] == value
       end)
    end
    if response_spec
      return response_spec['body']
    else
      raise MissingSpec
    end
  end
  
  def self.spec
    Plist.parse_xml("/tmp/resty_request_spec.plist")
  end
  
  private
  
  def self.http_header(header)
    "HTTP_#{header.upcase.gsub(/-/, "_")}"
  end
end
