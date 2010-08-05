//
//  TestRequestBuilder.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestRequestSpecificationBuilder : NSObject
{
  NSString *path;
  NSString *method;
  NSMutableDictionary *headers;
  id resultObject;
}
- (id)initWithPath:(NSString *)aPath method:(NSString *)theMethod;
- (id)withHeader:(NSString *)header value:(NSString *)headerValue;
- (void)setResult:(id)object;
@end

@interface TestRequestSpecification : NSObject
{
  NSMutableArray *specs;
}
- (void)addSpec:(TestRequestSpecificationBuilder *)spec;
- (void)writeToFile:(NSString *)filePath;
@end

TestRequestSpecificationBuilder *forGetRequestTo(NSString *path);

void serviceStubWillServe(id object, TestRequestSpecificationBuilder *requestSpec);
void serviceStubWillServeWithHeaders(id object, NSDictionary *headers, TestRequestSpecificationBuilder *requestSpec);
void clearServiceStubs();
