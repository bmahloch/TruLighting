//
//  HueLightingUnit.m
//  TruLightingUI
//
//  Created by bmahloch on 1/24/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "HueLightingUnit.h"
#import "TIHueLightingUnit.h"

@implementation HueLightingUnit

@dynamic lightId;
@dynamic apiKey;

- (TILightingUnit *)getControllableUnit
{
    TIHueLightingUnit *result = [[TIHueLightingUnit alloc] init];
    
    result.ip = self.ip;
    result.lightId = [self.lightId integerValue];
    result.apiKey = self.apiKey;
    
    return result;
}

@end
