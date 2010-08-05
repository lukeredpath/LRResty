//
//  LRRestyResponse.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyRequest;

@interface LRRestyResponse : NSObject {
  NSUInteger status;
  NSData *responseData;
  NSDictionary *headers;
  NSDictionary *cookies;
}
- (id)initWithStatus:(NSInteger)statusCode responseData:(NSData *)data headers:(NSDictionary *)theHeaders originalRequest:(LRRestyRequest *)originalRequest;
- (NSUInteger)status;
- (NSString *)asString;
- (NSHTTPCookie *)cookieNamed:(NSString *)name;
- (NSString *)valueForHeader:(NSString *)header;
- (NSString *)valueForCookie:(NSString *)cookieName;
@end
