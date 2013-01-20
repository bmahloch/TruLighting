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

@interface TILightingManager ()

+ (BOOL)isHueResponseSuccessful:(NSArray *)response;

@end

@implementation TILightingManager

#pragma mark - Constants

NSString *const APPLICATION_NAME = @"TruLighting";
NSString *const DATA_KEY_HUE_ERROR = @"error";
NSString *const DATA_KEY_HUE_USERNAME = @"username";
NSString *const DATA_KEY_HUE_DEVICE_TYPE = @"devicetype";

#pragma mark - Public Methods

+ (void)connectToHueHost:(NSString *)ip success:(void(^)(NSArray *))success failure:(void(^)(NSInteger, NSArray *))failure
{
    NSMutableDictionary *authorization = [NSMutableDictionary dictionary];
    NSString *apiKey = [[NSString guid] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [authorization setValue:apiKey forKey:DATA_KEY_HUE_USERNAME];
    [authorization setValue:APPLICATION_NAME forKey:DATA_KEY_HUE_DEVICE_TYPE];
    
    [[ServiceManager defaultManager] connectToHueHost:ip authorization:authorization success:^(NSArray *result){
       
        if([TILightingManager isHueResponseSuccessful:result])
            success(result);
        else
            failure(0, result);
        
    }failure:failure];
}

+ (void)getStatusOfHueHost:(NSString *)ip apiKey:(NSString *)apiKey success:(void(^)(NSDictionary *))success failure:(void(^)(NSInteger, NSArray *))failure
{
    [[ServiceManager defaultManager] getStatusOfHueHost:ip apiKey:apiKey success:^(id result){
        
        if([result isKindOfClass:[NSDictionary class]])
            success(result);
        else
        {
            if([TILightingManager isHueResponseSuccessful:result])
                success(result);
            else
                failure(0, result);
        }
        
    }failure:failure];
}

#pragma mark - Private Methods

+ (BOOL)isHueResponseSuccessful:(NSArray *)response
{
    for(NSDictionary *item in response)
    {
        for(NSString *key in [item allKeys])
        {
            if([key isEqualToString:DATA_KEY_HUE_ERROR])
                return NO;
        }
    }
    
    return YES;
}

@end
