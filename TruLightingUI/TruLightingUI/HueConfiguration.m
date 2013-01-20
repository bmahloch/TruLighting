//
//  HueConfiguration.m
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "HueConfiguration.h"

@implementation HueConfiguration

#pragma mark - Public Methods

+ (BOOL)bridgeExists:(NSMutableArray *)configuration byHost:(NSString *)host
{
    for(NSDictionary *bridge in configuration)
    {
        if([[bridge valueForKey:kDataKeyHueBridgeIpAddress] isEqualToString:host])
            return YES;
    }
    
    return NO;
}

@end
