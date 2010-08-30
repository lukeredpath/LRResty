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
#import "LRRestyResource.h"
#import "LRRestyStreamingClient.h"

@interface LRResty : NSObject {

}
+ (LRRestyClient *)client;
+ (LRRestyClient *)authenticatedClientWithUsername:(NSString *)username password:(NSString *)password;
+ (LRRestyResource *)resource:(NSString *)urlString;
+ (LRRestyResource *)authenticatedResource:(NSString *)urlString username:(NSString *)username password:(NSString *)password;
@end
