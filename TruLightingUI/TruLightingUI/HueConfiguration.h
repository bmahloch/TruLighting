//
//  HueConfiguration.h
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDataKeyHueConfiguration @"config"
#define kDataKeyHueApiKey @"apikey"
#define kDataKeyHueLights @"lights"
#define kDataKeyHueError @"error"
#define kDataKeyHueSuccess @"success"
#define kDataKeyHueUsername @"username"
#define kDataKeyHueBridgeIpAddress @"ipaddress"
#define kDataKeyHueBridgeName @"name"
#define kDataKeyHueBridgeMacAddress @"mac"
#define kDataKeyHueLightName @"name"

@interface HueConfiguration : NSObject

+ (BOOL)bridgeExists:(NSMutableArray *)configuration byHost:(NSString *)host;

@end
