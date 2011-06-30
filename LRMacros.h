//
//  LRMacros.h
//  LRResty
//
//  Created by Luke Redpath on 30/06/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
  _sharedObject = block(); \
  }); \
  return _sharedObject; \
