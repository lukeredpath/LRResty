#import <Foundation/Foundation.h>

int main(int argc, char *argv[]) {
  
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, @"ExampleAppDelegate");
  [pool release];
  return retVal;
}
