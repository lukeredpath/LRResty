//
//  LRRestyResponse+Internal.h
//  LRResty
//
//  Created by Luke Redpath on 26/06/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyResponse.h"

@interface LRRestyResponse ()

- (id)initWithStatus:(NSInteger)statusCode 
        responseData:(NSData *)data 
             headers:(NSDictionary *)theHeaders 
     originalRequest:(LRRestyRequest *)originalRequest;

@end
