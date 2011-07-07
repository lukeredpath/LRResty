//
//  RestyClientAcceptanceTestCase.h
//  LRResty
//
//  Created by Luke Redpath on 25/06/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestCase.h>
#import "TestHelper.h"
#import "LRResty.h"

@interface RestyClientAcceptanceTestCase : SenTestCase <LRRestyClientResponseDelegate>
{
  LRRestyResponse *lastResponse;
  LRRestyClient *client;
}
@property (nonatomic, retain) LRRestyResponse *lastResponse;
@property (nonatomic, retain) LRRestyClient *client;
@end

#define RESTY_CLIENT_ACCEPTANCE_TEST(name) \
  @interface name : RestyClientAcceptanceTestCase {}; @end \
  @implementation name \

#define END_ACCEPTANCE_TEST @end

#define ENABLE_RESTY_LOGGING \
  - (void)setUp { [super setUp]; [LRResty setDebugLoggingEnabled:YES]; }       \
  - (void)tearDown { [super tearDown];  [LRResty setDebugLoggingEnabled:NO]; } \
