require 'plist'

class ServiceStub
  class MissingSpec < RuntimeError; end
  
  def self.response_for(path, method)
    response_spec = spec.find do |spec|
      (spec['method'] == method &&
       spec['path']   == path)
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
end
