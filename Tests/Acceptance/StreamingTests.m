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
  LRRestyStreamingClient *client;
}
@end

@implementation StreamingTests

- (void)setUp
{
  client = [[[LRResty client] streamingClient] retain];
}

- (void)testCanPerformGetRequestAndStreamResponse
{
  serviceStubWillServe(@"the quick brown fox jumped over the lazy dog", forGetRequestTo(@"/simple/streaming"));
  
  __block NSMutableData *responseData = [NSMutableData data];
  __block NSString *responseBody = nil;
  
  [client get:resourceWithPath(@"/simple/streaming") receive:^(LRRestyResponse *response, NSData *chunk, BOOL *cancel) {
    if (chunk) {
      [responseData appendData:chunk];
      responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
  }];
  
  assertEventuallyThat(&responseBody, equalTo(@"the\nquick\nbrown\nfox\njumped\nover\nthe\nlazy\ndog\n"));
}

- (void)testCancellationUsingTwitterStream;
{
  NSMutableArray *chunks = [NSMutableArray array];
  __block LRRestyResponse *streamResponse = nil;
  
  [(LRRestyClient *)client setUsername:TwitterUsername password:TwitterPassword];
  
  [client get:@"http://stream.twitter.com/1/statuses/sample.json" receive:^(LRRestyResponse *response, NSData *chunk, BOOL *cancel) {
    if (chunk) {
      [chunks addObject:chunk];
    }
    if (response) {
      streamResponse = [response retain];
    }
    if (chunks.count == 5) {
      *cancel = YES;
    }
  }];
  
  assertEventuallyThatWithTimeout(&chunks, satisfiesBlock(@"has 5 objects", ^(id object) {
    return (BOOL)([(NSArray *)object count] == 5);
  }), 5);
  waitForInterval(0.5);
  
  assertThatInt(chunks.count, equalToInt(5)); // check it hasn't changed
  assertThat(streamResponse, is(responseWithStatus(200)));
  
  NSMutableData *collectedData = [NSMutableData data];
  for (NSData *chunk in chunks) {
    [collectedData appendData:chunk];
  }
  assertThat(collectedData, equalTo(streamResponse.responseData));
}

@end
