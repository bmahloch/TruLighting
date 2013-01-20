//
//  ServiceManager.h
//  SimpleSheets
//
//  Created by Brian Mahloch on 9/17/12.
//  Copyright (c) 2012 Skyline Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMainQueue dispatch_get_main_queue()

#define kCommunicationError @"An unknown communication error occured."
#define kAuthorizationError @"Communication is not authorized."

#define kParsingCode -200
#define kParsingEntityError @"Entity could not be parsed to or from json format."
#define kParsingResponseError @"Response could not be parsed to or from json format."

#define kHttpStatusCodeOK 200
#define kHttpStatusCodeAuthentication 401
#define kHttpStatusCodeBadRequest 400
#define kHttpStatusCodeNotFound 404
#define kHttpStatusCodeForbidden 403

#define kHttpMethodGet @"GET"
#define kHttpMethodPost @"POST"
#define kHttpMethodPut @"PUT"
#define kHttpMethodDelete @"Delete"

#define kContentTypeJson @"application/json"
#define kContentTypeXml @"application/xml"
#define kContentTypePlain @"text/plain"
#define kContentTypeImage @"image/jpg"

@class TIHueLightingUnit;

@interface ServiceManager : NSObject

+ (ServiceManager *)defaultManager;

- (void)setHueLightingUnit:(TIHueLightingUnit *)unit withState:(NSMutableDictionary *)state;
- (void)connectToHueHost:(NSString *)ip authorization:(NSDictionary *)authorization success:(void(^)(NSArray *))success failure:(void(^)(NSInteger, NSArray *))failure;
- (void)getStatusOfHueHost:(NSString *)ip apiKey:(NSString *)apiKey success:(void(^)(NSDictionary *))success failure:(void(^)(NSInteger, NSArray *))failure;

@end
