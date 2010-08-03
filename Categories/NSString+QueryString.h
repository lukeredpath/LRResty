//
//  NSString+QueryString.h
//  LROAuth2Client
//
//  Created by Luke Redpath on 14/05/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

@interface NSString (QueryString)

- (NSString*)stringByEscapingForURLQuery;
- (NSString*)stringByUnescapingFromURLQuery;

@end
