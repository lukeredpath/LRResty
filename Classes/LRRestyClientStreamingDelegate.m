//
//  LRRestyClientStreamingDelegate.m
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "LRRestyClientStreamingDelegate.h"
#import "LRRestyResponse.h"
#import "LRRestyRequest.h"

NSString *const LRRestyClientStreamingErrorDomain = @"LRRestyClientStreamingError";

@implementation LRRestyClientStreamingDelegate

+ (id)delegateWithBlock:(LRRestyResponseBlock)theBlock dataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock
{
  return [[[self alloc] initWithBlock:theBlock dataHandler:dataBlock errorHandler:errorBlock] autorelease];
}

- (id)initWithBlock:(LRRestyResponseBlock)theBlock dataHandler:(LRRestyStreamingDataBlock)dataBlock errorHandler:(LRRestyStreamingErrorBlock)errorBlock
{
  if ((self = [super initWithBlock:theBlock])) {
    dataHandler = [dataBlock copy];
    errorHandler = [errorBlock copy];
  }
  return self;
}

- (void)dealloc
{
  [dataHandler release];
  [errorHandler release];
  [super dealloc];
}

- (void)restyRequest:(LRRestyRequest *)request didReceiveData:(NSData *)data
{
  BOOL shouldCancel = NO;
  dataHandler(data, &shouldCancel);
  
  if (shouldCancel == YES) {
    [request cancel];
  }
}

- (void)restyRequest:(LRRestyRequest *)request didFinishWithResponse:(LRRestyResponse *)response
{
  if ([response status] > 200 && errorHandler != nil) {
    NSError *error = [NSError errorWithDomain:LRRestyClientStreamingErrorDomain 
                                         code:LRRestyStreamingErrorUnsuccessfulResponse 
                                     userInfo:[NSDictionary dictionaryWithObject:response forKey:@"response"]];
    errorHandler(error);
  }
  [super restyRequest:request didFinishWithResponse:response];
}

@end
