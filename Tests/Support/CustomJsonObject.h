//
//  CustomJsonObject.h
//  LRResty
//
//  Created by Luke Redpath on 18/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyRequestPayload.h"

@interface CustomJsonObject : NSObject <LRRestyRequestPayload>
{
  NSString *string;
}
- (id)initWithJSONString:(NSString *)jsonString;
@end
