//
//  TILightingGroup.m
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "TILightingGroup.h"
#import "TILightingUnit.h"

@implementation TILightingGroup
{
    UIColor *_color;
    NSInteger _intensity;
}

#pragma mark - Constructors

- (id)init
{
    if((self = [super init]))
    {
        _lightingUnits = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Property Accessors/Mutators

- (UIColor *)color
{
    return _color;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    for(TILightingUnit *unit in self.lightingUnits)
        unit.color = color;
}

- (NSInteger)intensity
{
    return _intensity;
}

- (void)setIntensity:(NSInteger)intensity
{
    _intensity = intensity;
    
    for(TILightingUnit *unit in _lightingUnits)
        unit.intensity = intensity;
}

#pragma mark - TILightingController Implementation

- (void)update
{
    for(TILightingUnit *unit in _lightingUnits)
        [unit update];
}

- (void)updateColor
{
    for(TILightingUnit *unit in _lightingUnits)
        [unit updateColor];
}

- (void)updateIntensity
{
    for(TILightingUnit *unit in _lightingUnits)
        [unit updateIntensity];
}

- (void)fadeOff
{
    [self fadeOffOverDuration:kDefaultFadeDuration];
}

- (void)fadeOffOverDuration:(float)duration
{
    for(TILightingUnit *unit in _lightingUnits)
        [unit fadeOffOverDuration:duration];
}

- (void)fadeOn
{
    [self fadeOnOverDuration:kDefaultFadeDuration];
}

- (void)fadeOnOverDuration:(float)duration
{
    for(TILightingUnit *unit in _lightingUnits)
        [unit fadeOnOverDuration:duration];
}

- (void)blink
{
    [self blinkForDuration:kDefaultBlinkDuration];
}

- (void)blinkForDuration:(float)duration
{
    for(TILightingUnit *unit in _lightingUnits)
        [unit blinkForDuration:duration];
}

@end
