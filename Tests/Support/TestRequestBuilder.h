//
//  TestRequestBuilder.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestRequestSpecification : NSObject
{
  NSString *path;
  NSString *method;
}
- (id)initWithPath:(NSString *)aPath method:(NSString *)theMethod;
- (void)writeToFile:(NSString *)filePath object:(id)resultObject;
@end

TestRequestSpecification *forGetRequestTo(NSString *path);

void serviceStubWillServe(id object, TestRequestSpecification *requestSpec);
void serviceStubWillServeWithHeaders(id object, NSDictionary *headers, TestRequestSpecification *requestSpec);
