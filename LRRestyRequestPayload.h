//
//  LRRestyRequestPayload.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyRequest;

@protocol LRRestyRequestPayload <NSObject>
- (void)modifyRequest:(LRRestyRequest *)request;
@end

@interface LRRestyRequestPayloadFactory : NSObject {

}
+ (id)payloadFromObject:(id)object;
@end

@interface LRRestyRequestEncodablePayload : NSObject <LRRestyRequestPayload>
{
  id encodable; // typically a string, but anything that responds to dataUsingEncoding:
}
- (id)initWithEncodableObject:(id)object;
@end

@interface LRRestyRequestFormEncodedData : NSObject <LRRestyRequestPayload>
{
  NSDictionary *dictionary;
}
- (id)initWithDictionary:(NSDictionary *)aDictionary;
@end
