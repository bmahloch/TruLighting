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

#pragma mark - Public Methods

+ (TILightingUnit *)createFromDictionary:(NSDictionary *)dictionary
{
    NSString *class = [dictionary valueForKey:kDataKeyClass];
    
    NSAssert(class != nil, @"Dictionary must contain a lighting unit class");
    
    [dictionary setValue:nil forKey:kDataKeyClass];
    
    Class object = NSClassFromString(class);
    TILightingUnit *result = [[object alloc] init];
    NSInteger r,g,b;
    
    for(NSString *key in dictionary.allKeys)
    {
        if([key isEqualToString:kDataKeyRed])
            r = [[dictionary valueForKey:key] integerValue];
        else if([key isEqualToString:kDataKeyGreen])
            g = [[dictionary valueForKey:key] integerValue];
        else if([key isEqualToString:kDataKeyBlue])
            b = [[dictionary valueForKey:key] integerValue];
        else
            [result setValue:[dictionary valueForKey:key] forKey:key];
    }
    
    result.color = [UIColor colorWithRed:RGBIntegerToFloat(r) green:RGBIntegerToFloat(g) blue:RGBIntegerToFloat(b) alpha:1];
    
    return result;
}

- (NSMutableDictionary *)dictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for(NSString *key in [self propertyKeys])
    {
        if([key isEqualToString:kDataKeyColor])
        {
            UIColor *color = [self valueForKey:key];
            NSInteger r,g,b;
            
            [color r:&r g:&g b:&b];
            [result setValue:[NSNumber numberWithInteger:r] forKey:kDataKeyRed];
            [result setValue:[NSNumber numberWithInteger:g] forKey:kDataKeyGreen];
            [result setValue:[NSNumber numberWithInteger:b] forKey:kDataKeyBlue];
        }
        else
            [result setValue:[self valueForKey:key] forKey:key];
    }
    
    [result setValue:NSStringFromClass([self class]) forKey:kDataKeyClass];
    
    return result;
}

- (NSArray *)propertyKeys
{
    NSMutableArray *result = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        
        if(name)
            [result addObject:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
    }
    
    properties = class_copyPropertyList([TILightingUnit class], &outCount);
    
    for(int i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        
        if(name)
            [result addObject:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
    }
    
    return result;
}

@end
