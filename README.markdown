# Resty, an Objective-C HTTP framework

Resty is a simple to use HTTP library for iOS and Mac apps, aimed at consuming RESTful web services and APIs. 

It uses modern Objective-C language features like blocks to simple asynchronous requests without having to worry about threads, operation queues or repetitive delegation. It is inspired heavily by [RestClient](http://github.com/archiloque/rest-client), a Ruby HTTP library.

For more information and documentation, [check out the project website](http://projects.lukeredpath.co.uk/resty/).

## Getting started

Because Resty relies heavily on Objective-C blocks, it requires a minimum of iOS 4.0 or Mac 10.6.

Resty is distributed as a static framework for iOS and a regular framework Mac; this makes it easy to get up and running with Resty. Simply drop the framework into your project (like any other framework) and add the -ObjC and -all_load linker flags to your target. If your project builds, you should be ready to go.

To download Resty, you can either [clone this project and build from scratch](http://projects.lukeredpath.co.uk/resty/getting-started.html), grab one of the latest releases from the [Github downloads tab](http://github.com/lukeredpath/LRResty/downloads) or grab one of the [nightly builds](http://projects.lukeredpath.co.uk/resty/downloads).

For detailed information, [check out the Resty website](http://projects.lukeredpath.co.uk/documentation.html).
