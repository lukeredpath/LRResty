//
//  LRRestyTypes.h
//  LRResty
//
//  Created by Luke Redpath on 30/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

typedef void (^LRRestyStreamingDataBlock)(NSData *data, BOOL *cancel);
typedef void (^LRRestyStreamingErrorBlock)(NSError *error);
