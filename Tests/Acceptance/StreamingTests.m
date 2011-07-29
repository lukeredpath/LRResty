//
//  StreamingTests.m
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "RestyClientAcceptanceTestCase.h"
#import "TwitterCredentials.h"
#import "HCBlockMatcher.h"

RESTY_CLIENT_ACCEPTANCE_TEST(StreamingTests)

- (void)testCanPerformGetRequestAndStreamResponse
{
  __block NSMutableData *responseData = [[NSMutableData alloc] init];
  __block NSString *responseBody = nil;
  
  [client get:resourceWithPath(@"/streaming")
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
  __block NSMutableArray *chunks = [NSMutableArray array];
  
  [client setUsername:TwitterUsername password:TwitterPassword];
  
  [client get:@"http://stream.twitter.com/1/statuses/sample.json"
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
  
  [client get:resourceWithPath(@"/simple/unknown")
      onData:^(NSData *chunk, BOOL *cancel) {}
      onError:^(NSError *error) {
        streamError = [error retain];
      }
  ];
  
  assertEventuallyThat(&streamError, isNot(nilValue()));
}

END_ACCEPTANCE_TEST
