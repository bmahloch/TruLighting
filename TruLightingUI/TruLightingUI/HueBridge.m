//
//  HueBridge.m
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "HueBridge.h"

@implementation HueBridge

#pragma mark - Constants

NSString *const DATA_KEY_BRIDGE_NAME = @"name";
NSString *const DATA_KEY_BRIDGE_MAC_ADDRESS = @"mac";

- (NSString *)name
{
    return [self.dictionary valueForKey:DATA_KEY_BRIDGE_NAME];
}

- (void)setName:(NSString *)name
{
    [self.dictionary setValue:name forKey:DATA_KEY_BRIDGE_NAME];
}

- (NSString *)macAddress
{
    return [self.dictionary valueForKey:DATA_KEY_BRIDGE_MAC_ADDRESS];
}

- (void)setMacAddress:(NSString *)macAddress
{
    [self.dictionary setValue:macAddress forKey:DATA_KEY_BRIDGE_MAC_ADDRESS];
}

@end
