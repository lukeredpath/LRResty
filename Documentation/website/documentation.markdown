---
layout: default
title: Resty Documentation
---

# Documentation

Resty is a simple to use HTTP library for Cocoa and iOS apps, aimed at consuming RESTful web services and APIs. 

It uses modern Objective-C language features like blocks to simple asynchronous requests without having to worry about threads, operation queues or repetitive delegation. It is inspired heavily by [RestClient](http://github.com/archiloque/rest-client), a Ruby HTTP library.

## Making a simple GET request

Resty's simplicity is best demonstrated with a simple GET request.

{% ultrahighlight objective-c %}
[[LRResty client] get:@"http://www.example.com" 
            withBlock:^(LRRestyResponse *response) {
              
    if(response.status == 200) {
      NSLog(@"Successful response %@", [response asString]);
    }
}];
{% endultrahighlight %}

In the above code, <code>[LRResty client]</code> returns a shared instance of <code>LRRestyClient</code>. A brand new client instance created by calling <code>[LRResty newClient]</code> although in most cases, the shared client will be all you need.

## Handling responses: two approaches

Resty supports two methods of handling responses; the preferred method -- shown in the above example -- is to use a block and the second is a more traditional delegate-based approach.

The block-based approach is preferred because it is simpler and keeps request and the matching response handler in the same location however if for some reason you need to use delegation to handle responses, you can do so easily. 

Using the delegate-based approach will be familiar to anybody used to other delegation-based Cocoa APIs (i.e. most of them); instead of passing a block to the request method you pass in an object that conforms to the <code>LRRestyClientResponseDelegate</code> protocol.

{% ultrahighlight objective-c %}
[[LRResty client] get:@"http://www.example.com" delegate:self]
{% endultrahighlight %}

Then, implement the delegate methods as appropriate. [Several are available](http://github.com/lukeredpath/LRResty/blob/master/Classes/LRRestyClientResponseDelegate.h) but only one is required:

{% ultrahighlight objective-c %}
- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)res;
{
  // do something with the response
}
{% endultrahighlight %}

## Customizing requests

Resty lets you customise requests by specifying query parameters (for GET requests), request headers and the request body (for POST or PUT requests).

### Query parameters

Whilst you could just embed query parameters in the URL itself, you often want to to pass a dictionary of options to the URL as query parameters. Resty has support for specifying query parameters as an <code>NSDictionary</code> for GET requests built in.

{% ultrahighlight objective-c %}
NSDictionary *parameters = [NSDictionary 
      dictionaryWithObject:@"somevalue" forKey:@"someparam"];
  
[[LRResty client] get:@"http://www.example.com" parameters:parameters 
            withBlock:^(LRRestyResponse *response){}];
{% endultrahighlight %}

### Request headers

Like query parameters, request headers can also be passed as a dictionary and can be passed into any of the request methods (GET, POST, PUT, DELETE and HEAD).

{% ultrahighlight objective-c %}
NSDictionary *requestHeaders = [NSDictionary 
      dictionaryWithObject:@"application/json" forKey:@"Content-Type"];
  
[[LRResty client] get:@"http://www.example.com" headers:requestHeaders
            withBlock:^(LRRestyResponse *response){}];
{% endultrahighlight %}

### Setting the request body

Resty supports polymorphic request payloads; a payload being any Objective-C object that can be used to create a request body.

Out of the box, Resty supports <code>NSDictionary</code> and <code>NSData</code> payloads as well as any object that can be converted to <code>NSData</code> by calling the <code>dataUsingEncoding:</code> method (such as <code>NSString</code>). 

<p><code>NSDictionary</code> payloads are used to POST or PUT form-encoded data; the dictionary will be used to create the form-encoded parameters (nested parameters are supported) and the appropriate Content-Type header will be set.</p>

{% ultrahighlight objective-c %}
NSDictionary *params = [NSMutableDictionary dictionary];
[params setObject:@"Joe Bloggs" forKey:@"name"];
[params setObject:@"joe@example.com" forKey:@"email"];
 
[[LRResty client] post:@"http://www.example.com" payload:params 
            withBlock:^(LRRestyResponse *response){}];
{% endultrahighlight %}

<p><code>NSData</code> or any other data-encodable payloads set the request body as-is; encodable payloads will be encoded using UTF8.</p>

{% ultrahighlight objective-c %}
[[LRResty client] put:@"http://www.example.com" payload:@"This is the request body"
           withBlock:^(LRRestyResponse *response){}];
{% endultrahighlight %}

### Custom payload objects

In addition to the above, it is also possible to add payload support to your own objects by implementing the <code>LRRestyRequestPayload</code> protocol. 

The protocol simply requires that you implement one method, <code>modifyRequest:</code> which is where object can modify the request (typically by setting the request body and adding any relevant headers) without having to expose it's state.

Once implemented, you can pass in instances of your own objects to the <code>payload</code> parameter.

{% ultrahighlight objective-c %}
@interface JSONObject <LRRestyRequestPayload>
  {}
@end

@implementation JSONObject

- (void)modifyRequest:(LRRestyRequest *)request
{
  [request setPostData:[[self JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
  [request addHeader:@"Content-Type" value:@"application/json"];
}

@end

JSONObject *json = [JSONObject new];
[[LRResty client] post:@"http://www.example.com/jsonapi" payload:json
             withBlock:^(LRRestyResponse *response){}];
{% endultrahighlight %}


