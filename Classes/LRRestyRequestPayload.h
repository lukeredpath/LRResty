//
//  LRRestyRequestPayload.h
//  LRResty
//
//  Created by Luke Redpath on 05/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRRestyRequest;

/**
 The LRRestyRequestPayload protocol is the basis for the LRResty payload system.
 
 It describes an object that can be used with POST or PUT request methods that
 take a payload parameter.
 
 When you perform POST or PUT requests to a resource, you typically want to post some kind of
 data to that resource.
 
 The LRResty payload system lets you POST or PUT data in an agnostic way, letting you pass
 any object that implements the LRRestyRequestPayload protocol into one of the request methods
 on LRRestyClient that accept a payload parameter.
 
 In addition, LRResty provides out of the box support for certain native data types, including
 encodable objects (such as NSString, or anything that responds to dataUsingEncoding:), NSDictionary
 and of course, NSData can also be used directly.
 */
@protocol LRRestyRequestPayload <NSObject>
/**
 * This method will be called when constructing the POST or PUT request and is where
 * the object can inject itself into the request body in the appropriate format. It
 * can also be used to set relevant headers (e.g. setting the content-type for the
 * object's format).
 */
- (void)modifyRequest:(LRRestyRequest *)request;
@end

/**
 * Will return an object that implements LRRestyRequestPayload; this enables various
 * native objects that do not implement the protocol to be used as payload parameters,
 * such as NSData, NSString and NSDictionary.
 */ 
@interface LRRestyRequestPayloadFactory : NSObject 
{}
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
