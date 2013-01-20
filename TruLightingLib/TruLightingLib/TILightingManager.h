//
//  TILightingManager.h
//  TruLightingLib
//
//  Created by bmahloch on 1/12/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TILightingManager : NSObject

+ (void)connectToHueHost:(NSString *)ip success:(void(^)(NSArray *))success failure:(void(^)(NSInteger, NSArray *))failure;
+ (void)getStatusOfHueHost:(NSString *)ip apiKey:(NSString *)apiKey success:(void(^)(NSDictionary *))success failure:(void(^)(NSInteger, NSArray *))failure;

@end
