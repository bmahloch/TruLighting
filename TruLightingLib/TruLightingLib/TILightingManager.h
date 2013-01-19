//
//  TILightingManager.h
//  TruLightingLib
//
//  Created by bmahloch on 1/12/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kApplicationName @"TruLighting"

#define kDataKeyHueUsername @"username"
#define kDataKeyHueDeviceType @"devicetype"

@interface TILightingManager : NSObject

+ (void)connectToHueHost:(NSString *)ip apiKey:(NSString **)apiKey completionBlock:(void(^)(bool, NSMutableArray *))completion;
+ (void)getStatusOfHueHost:(NSString *)ip apiKey:(NSString *)apiKey success:(void(^)(NSDictionary *))success failure:(void(^)(NSMutableArray *))failure;

@end
