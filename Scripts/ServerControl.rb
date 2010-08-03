if ARGV[0] == 'start'
  `thin -t1 -d -p 10090 -R Tests/ServiceStub/config.ru start `
else
  `thin stop`
end
