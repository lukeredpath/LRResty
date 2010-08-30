//
//  LRRestyClientStreamingDelegate.m
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClientStreamingDelegate.h"
#import "LRRestyResponse.h"

NSString *const LRRestyClientStreamingErrorDomain = @"LRRestyClientStreamingError";

@implementation LRRestyClientStreamingDelegate

+ (id)delegateWithDataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock;
{
  return [[[self alloc] initWithDataHandler:dataBlock errorHandler:errorBlock] autorelease];
}

- (id)initWithDataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock;
{
  if (self = [super init]) {
    dataHandler = Block_copy(dataBlock);
    errorHandler = Block_copy(errorBlock);
  }
  return self;
}

- (void)dealloc
{
  Block_release(dataHandler);
  Block_release(errorHandler);
  [super dealloc];
}

- (void)restClient:(LRRestyClient *)client request:(LRRestyRequest *)request receivedData:(NSData *)data
{
  BOOL shouldCancel = NO;
  dataHandler(data, &shouldCancel);
  
  if (shouldCancel == YES) {
    [request cancel];
  }
}

- (void)restClient:(LRRestyClient *)client receivedResponse:(LRRestyResponse *)response
{
  if ([response status] > 200) {
    NSError *error = [NSError errorWithDomain:LRRestyClientStreamingErrorDomain 
                                         code:LRRestyStreamingErrorUnsuccessfulResponse 
                                     userInfo:[NSDictionary dictionaryWithObject:response forKey:@"response"]];
    errorHandler(error);
  }
}

@end
