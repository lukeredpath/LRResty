//
//  LRRestyResponse+JSON.h
//  LRResty
//
//  Created by Luke Redpath on 06/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyResponse.h"

@interface LRRestyResponse (JSON)
- (id)asJSONObject;
@end
