---
layout: default
title: A simple Objective-C REST/HTTP client for iOS and Mac
---

Resty is a simple to use HTTP library for Cocoa and iOS apps, aimed at consuming RESTful web services and APIs. It enables you to make requests in fewer lines of code than using the built-in `NSURLConnection` API (which LRResty is built on). This is what it looks like:

{% ultrahighlight objective-c %}
- (void)fetchSomething
{
  [[LRResty client] get:@"http://www.example.com" withBlock:^(LRRestyResponse *r) {
    NSLog(@"That's it! %@", [r asString]);
  }];
}
{% endultrahighlight %}

It uses modern Objective-C language features like blocks to simple asynchronous requests without having to worry about threads, operation queues or repetitive delegation. It is inspired heavily by [RestClient](http://github.com/archiloque/rest-client), a Ruby HTTP library.

<div class="download">
  <p><strong>Download the latest version of LRResty.framework (0.10) <a href="http://github.com/downloads/lukeredpath/LRResty/LRResty-iOS-0.10.dmg">for iOS</a> or <a href="http://github.com/downloads/lukeredpath/LRResty/LRResty-Mac-0.10.dmg">for Mac</a></strong></a></p>
  
  <p>Alternatively, you can grab one of the <a href="http://github.com/lukeredpath/LRResty/downloads">nightly builds</a> or the latest source <a href="http://github.com/lukeredpath/LRResty">on Github</a></p>
  
  <p class="notice">Resty requires iOS 4.0 or Mac OSX 10.6 or later</p>
  
  <p class="license">Resty is released under the <a href="http://en.wikipedia.org/wiki/MIT_License">MIT license</a>.</p>
</div>

