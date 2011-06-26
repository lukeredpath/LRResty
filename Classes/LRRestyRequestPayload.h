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
 data to that resource. The LRResty payload system lets you POST or PUT data in an agnostic way, letting you pass
 any object that implements the LRRestyRequestPayload protocol into one of the request methods
 on LRRestyClient that accept a payload parameter.
 
 #### Native type support
 
 LRResty provides out of the box support for certain native data types, including
 NSString (or any other object that responds to dataUsingEncoding:), NSDictionary
 and of course, NSData can also be used directly.
 
 #### Implementing the protocol in your domain model
 
 As an example, imagine you have a model object that you would like to serialize as JSON and POST
 to a server that uses a REST API. Your model object could implement the LRRestyRequestPayload directly:
 
    @interface SpaceShip
      ...
    
    - (NSData *)dataForRequest
    {
      return [[self propertiesAsDictionary] JSONDataUsingEncoding:NSUTF8Encoding];
    }
 
    - (NSString *)contentTypeForRequest
    {
      return @"application/json";
    }
 
    @end
 
 It is now possible to POST or PUT an instance of your SpaceShip object to your server using the
 LRRestyClient APIs without any further work:
 
    SpaceShip *spaceship = [self findInstanceOfSpaceShip];
  
    [[LRResty client] post:@"http://www.nasa.com/spaceships" payload:spaceship withBlock:^(LRRestyResponse *response) {
        if (response.code == 201) {
            NSLog(@"Spaceship was created on server!");
        }
    }];
 
 Finally, if the REST API was strict and required that the Accept header was also set correctly,
 we can simply extend our class to implement modifyRequestBeforePerforming: as well:
 
    @implementation SpaceShip (Continued)
 
    - (void)modifyRequestBeforePerforming:(LRRestyRequest *)request
    {
      [request addHeader:@"Accept" value:@"application/json"];
    }
 
    @end
 */
@protocol LRRestyRequestPayload <NSObject>

@required

/**
 The data to be used in the request body.
 */
- (NSData *)dataForRequest;

/**
 The MIME type that will be used in the Content-Type header
 */
- (NSString *)contentTypeForRequest;

@optional

/**
 This will be called just before the request is performed. 
 
 It gives the payload object one more opportunity to modify the request
 prior to it being performed.
 
 This used to be the only method in the protocol and was used to set the request
 data and any headers (such as the content type). You should no longer use
 this method for setting the data or the Content-Type header as these will be set
 automatically using the values returned by the other protocol methods.
 
 @param request The request about to be performed.
 */
- (void)modifyRequestBeforePerforming:(LRRestyRequest *)request;

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

@interface LRRestyDataPayload : NSObject <LRRestyRequestPayload>
{
  NSData *requestData;
  NSString *contentType;
}
- (id)initWithData:(NSData *)data;
- (id)initWithEncodable:(id)encodable encoding:(NSStringEncoding)encoding;
@end

@interface LRRestyFormEncodedPayload : NSObject <LRRestyRequestPayload>
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
