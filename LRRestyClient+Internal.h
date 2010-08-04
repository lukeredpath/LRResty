//
//  LRRestyClient+Internal.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClient.h"

@interface LRRestyClient (Internal)

- (NSData *)dataFromFormEncodedParameters:(NSDictionary *)parameters;
- (NSDictionary *)headersForFormEncodedParameters:(NSDictionary *)otherHeaders;

@end
