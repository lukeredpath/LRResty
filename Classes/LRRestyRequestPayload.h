//
//  LRRestyRequestPayload.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyRequest;

@protocol LRRestyRequestPayload <NSObject>
- (void)modifyRequest:(LRRestyRequest *)request;
@end

@interface LRRestyRequestPayloadFactory : NSObject {

}
+ (id)payloadFromObject:(id)object;
@end

@interface LRRestyRequestBasicPayload : NSObject <LRRestyRequestPayload>
{
  NSData *data;
}
- (id)initWithData:(NSData *)rawData;
@end

@interface LRRestyRequestEncodablePayload : NSObject <LRRestyRequestPayload>
{
  id encodable; // typically a string, but anything that responds to dataUsingEncoding:
}
- (id)initWithEncodableObject:(id)object;
@end

@interface LRRestyRequestFormEncodedData : NSObject <LRRestyRequestPayload>
{
  NSDictionary *dictionary;
}
- (id)initWithDictionary:(NSDictionary *)aDictionary;
@end

//@class LRRestyRequestMultipartPart;
//
//@interface LRRestyRequestMultipartFormData : NSObject <LRRestyRequestPayload>
//{
//  NSMutableArray *parts; 
//}
//- (void)addPart:(void (^)(LRRestyRequestMultipartPart *))block;
//@end
//
//@interface LRRestyRequestMultipartPart
//{
//  NSString *contentType;
//  NSString *name;
//  NSString *fileName;
//  NSData *data;
//}
//@property (nonatomic, copy) NSString *contentType;
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *fileName;
//@property (nonatomic, copy) NSData *data;
//@end
//
//@implementation LRRestyRequestMultipartPart
//
//@synthesize contentType, name, fileName, data;
//
//- (NSString *)contentDisposition
//{
//  NSMutableArray *components = [NSMutableArray array];
//  [components addObject:@"form-data"];
//  [components addObject:[NSString stringWithFormat:@"name=\"%@\"", name]];
//  if (fileName) {
//    [components addObject:[NSString stringWithFormat:@"filename=\"%@\"", fileName]];
//  }
//  return [components componentsJoinedByString:@"; "];
//}
//
//- (void)modifyRequest:(LRRestyRequest *)request
//{
//
//}
//
//@end


// LRRestyRequestMultipartFormData *multipart = [[LRRestyRequestMultipartFormData alloc] init];
// 
// [multipart addPart:^(LRRestyRequestMultipartPart *part) {
//   part.name = @"upload";
//   part.fileName = @"My holiday.jpg"
//   part.contentType = @"image/jpeg";
//   part.data = UIImageJpegRepresentation(myImage);
// }];
//
// [multipart addPart:^(LRRestyRequestMultipartPart *part) {
//   part.name = @"comment";
//   part.contentType = @"text/plain";
//   part.data = [@"this is a comment" dataUsingEncoding:NSUTF8Encoding];
// }];
//
// [[LRResty client] post:@"http://www.example.com/endpoint" payload:multipart withBlock:^(LRRestyResponse *response) {
//   if (response.status == 201) {
//     NSLog(@"It worked!");
//   }
// }];
