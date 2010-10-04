---
layout: default
title: Resty,  Objective-C REST Resource consumption made easy
---

Resty is a simple to use HTTP library for Cocoa and iOS apps, aimed at consuming RESTful web services and APIs. 

It uses modern Objective-C language features like blocks to simple asynchronous requests without having to worry about threads, operation queues or repetitive delegation. It is inspired heavily by [RestClient](http://github.com/archiloque/rest-client), a Ruby HTTP library.

{% ultrahighlight objective-c %}
- (void)fetchSomething
{
  [[LRResty client] get:@"http://www.example.com" withBlock:^(LRRestyResponse *r) {
    NSLog(@"That's it! %@", [r asString]);
  }];
}
{% endultrahighlight %}

<div class="download">
  <a href="http://github.com/downloads/lukeredpath/LRResty/LRResty-0.9.dmg">Download the latest version of LRResty.framework (1.0)</a>
  
  <p class="license">Resty is released under the <a href="http://en.wikipedia.org/wiki/MIT_License">MIT license</a>.</p>
</div>

