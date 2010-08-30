//
//  StreamingTests.m
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "TestHelper.h"
#import "LRResty.h"
#import "TwitterCredentials.h"
#import "HCBlockMatcher.h"

@interface StreamingTests : SenTestCase
{
  LRRestyClient *client;
}
@end

@implementation StreamingTests

- (void)setUp
{
  client = [[LRResty client] retain];
}

- (void)testCanPerformGetRequestAndStreamResponse
{
  serviceStubWillServe(@"the quick brown fox jumped over the lazy dog", forGetRequestTo(@"/simple/streaming"));
  
  __block NSMutableData *responseData = [NSMutableData data];
  __block NSString *responseBody = nil;
  
  [client getURL:[NSURL URLWithString:resourceWithPath(@"/simple/streaming")] parameters:nil headers:nil
    onData:^(NSData *chunk, BOOL *cancel) {
      if (chunk) {
        [responseData appendData:chunk];
        responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
      }
    }
    onError:^(NSError *error) {}
  ];
  
  assertEventuallyThat(&responseBody, equalTo(@"the\nquick\nbrown\nfox\njumped\nover\nthe\nlazy\ndog\n"));
}

- (void)testCancellationUsingTwitterStream;
{
  NSMutableArray *chunks = [NSMutableArray array];
  
  [client setUsername:TwitterUsername password:TwitterPassword];
  
  [client getURL:[NSURL URLWithString:@"http://stream.twitter.com/1/statuses/sample.json"] parameters:nil headers:nil
    onData:^(NSData *chunk, BOOL *cancel) {
      if (chunk) {
        [chunks addObject:chunk];
      }
      if (chunks.count == 5) {
        *cancel = YES;
      }
    }
    onError:^(NSError *error) {}
  ];
  
  assertEventuallyThatWithTimeout(&chunks, satisfiesBlock(@"has 5 objects", ^(id object) {
    return (BOOL)([(NSArray *)object count] == 5);
  }), 5);
  waitForInterval(0.5);
  
  assertThatInt(chunks.count, equalToInt(5)); // check it hasn't changed
}

- (void)testNotifiesConnectionErrors
{
  __block NSError *streamError = nil;
  
  [client getURL:[NSURL URLWithString:resourceWithPath(@"/simple/unknown")] parameters:nil headers:nil
      onData:^(NSData *chunk, BOOL *cancel) {}
      onError:^(NSError *error) {
        streamError = [error retain];
      }
  ];
  
  assertEventuallyThat(&streamError, isNot(nilValue()));
}

@end
