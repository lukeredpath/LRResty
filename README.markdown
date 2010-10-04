# Resty, an Objective-C HTTP framework

Resty is a simple to use HTTP library for iOS (and soon, Mac) apps, aimed at consuming RESTful web services and APIs. 

It uses modern Objective-C language features like blocks to simple asynchronous requests without having to worry about threads, operation queues or repetitive delegation. It is inspired heavily by [RestClient](http://github.com/archiloque/rest-client), a Ruby HTTP library.

For more information and documentation, [check out the project website](http://projects.lukeredpath.co.uk/resty/).

## Getting started

Because Resty relies heavily on Objective-C blocks, it requires a minimum of iOS 4.0. It is possible to get Resty working the [PLBlocks runtime](http://code.google.com/p/plblocks/) for older versions of iOS and some compatibility patches are included although support for this will be limited going forward due to the imminent release of iOS 4.2 for iPad and iPhone/iPod Touch.

Resty is distributed as a static framework for iOS; this makes it easy to get up and running with Resty. Simply drop the framework into your project (like any other framework) and add the -ObjC and -all_load linker flags to your target. If your project builds, you should be ready to go.

[Now go and read the documentation](http://projects.lukeredpath.co.uk/documentation.html).