//
//  DMXLightingUnit.m
//  TruLightingUI
//
//  Created by bmahloch on 1/24/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "DMXLightingUnit.h"
#import "TIDMXLightingUnit.h"

@implementation DMXLightingUnit

@dynamic universe;
@dynamic channel;
@dynamic kind;

- (TILightingUnit *)getControllableUnit
{
    TIDMXLightingUnit *result = [[TIDMXLightingUnit alloc] init];
    
    result.ip = self.ip;
    result.universe = [self.universe integerValue];
    result.channel = [self.channel integerValue];
    result.type = [self.kind integerValue];
    
    return result;
}

@end
