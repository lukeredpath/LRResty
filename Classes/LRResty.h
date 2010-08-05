//
//  LRResty.h
//  LRResty
//
//  Created by Luke Redpath on 03/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRRestyClient.h"
#import "LRRestyClient+GET.h"
#import "LRRestyClient+POST.h"
#import "LRRestyClient+PUT.h"
#import "LRRestyResponse.h"
#import "LRRestyRequest.h"

@interface LRResty : NSObject {

}
+ (LRRestyClient *)client;
@end
