//
//  TILightingUnit.m
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <objc/runtime.h>
#import "TILightingUnit.h"
#import "UIColor+Extensions.h"

@implementation TILightingUnit

#pragma mark - TILightingController Implementation

- (void)update
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)updateColor
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)updateIntensity
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)fadeOff
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)fadeOffOverDuration:(float)duration
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)fadeOn
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)fadeOnOverDuration:(float)duration
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)blink
{
    NSAssert(NO, @"Method should be overridden");
}

- (void)blinkForDuration:(float)duration
{
    NSAssert(NO, @"Method should be overridden");
}

@end
