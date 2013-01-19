//
//  TILightingManager.m
//  TruLightingLib
//
//  Created by bmahloch on 1/12/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "TILightingManager.h"
#import "NSString+Extensions.h"
#import "ServiceManager.h"

@implementation TILightingManager

#pragma mark - Public Methods

+ (void)connectToHueHost:(NSString *)ip apiKey:(NSString **)apiKey completionBlock:(void(^)(bool, NSMutableArray *))completion;
{
    NSMutableDictionary *authorization = [NSMutableDictionary dictionary];
    *apiKey = [[NSString guid] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [authorization setValue:*apiKey forKey:kDataKeyHueUsername];
    [authorization setValue:kApplicationName forKey:kDataKeyHueDeviceType];
    
    [[ServiceManager defaultManager] connectToHueHost:ip authorization:authorization completionBlock:completion];
}

+ (void)getStatusOfHueHost:(NSString *)ip apiKey:(NSString *)apiKey success:(void(^)(NSDictionary *))success failure:(void(^)(NSMutableArray *))failure
{
    [[ServiceManager defaultManager] getStatusOfHueHost:ip apiKey:apiKey success:success failure:failure];
}

@end
