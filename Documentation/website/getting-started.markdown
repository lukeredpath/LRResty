---
layout: default
title: Getting started | Resty
---

# Getting started with Resty

Resty is distributed as a static framework for iOS and Mac; this makes it easy to get up and running with Resty.

## Importing the framework

Download the framework and drag it into your project (you might want to drop it into the Frameworks folder but it's not necessary). Whether or not you choose to reference the framework from some shared location or copy it into your project depends on your needs.

To ensure any categories that are used by Resty are loaded, you will need to add the <code>ObjC</code> and <code>all_load</code> linker flags to your target settings:

![Target settings](images/target-settings.png)

## Verify everything is working

The quickest way of checking that Resty is working correctly (assuming that your project is building successfully after importing the framework), is to make a request in your application delegate.

First, import the header:

{% ultrahighlight objective-c %}
#import <LRResty/LRResty.h>
{% endultrahighlight %}

Then, in your application launch method, make a GET request and log the result:

{% ultrahighlight objective-c %}
- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[LRResty client] get:@"http://www.example.com" withBlock:^(LRRestyResponse *r) {
    NSLog(@"%@", [r asString]);
  }];

  ...
}
{% endultrahighlight %}

If you see the returned HTML from www.example.com in your Console log, everything is up and running and you're ready to start using Resty.

## Building from the latest source

If you've cloned the latest copy of LRResty from Github, you can build the framework for your platform of choice using the supplied [Rake](http://rake.rubyforge.org/) tasks. You'll need to install one RubyGem - the plist gem.

    $ gem install plist
    
You can then run the `build:ios:framework` or `build:mac:framework` task to build either a static framework for iOS or a regular framework for Mac, e.g.:
    
    $ rake build:ios: framework
    
The built framework will be in `build/Release`. You can then import this framework into your project using the instructions above. Alternatively, you may wish to download a <a href="http://github.com/lukeredpath/LRResty/downloads">nightly build</a>.

Note: I have observed some issues when building with Clang, which results in Clang crashing with an "abort trap" message at the end of the build. As far as I can see, this doesn't actually cause a problem and the framework will still be successfully built.
