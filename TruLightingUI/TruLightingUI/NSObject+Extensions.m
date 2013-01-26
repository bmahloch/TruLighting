//
//  NSObject+Extensions.m
//  TruLightingUI
//
//  Created by bmahloch on 1/21/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Extensions.h"

@interface NSObject (Private)

- (BOOL)hasType:(NSDictionary *)dictionary;
- (id)objectFromDictionary:(NSDictionary *)dictionary;

@end

@implementation NSObject (Extensions)

#pragma mark - Constants

NSString *const KEY_TYPE_IDENTIFIER = @"__type";

#pragma mark - Constructors

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if((self = [self init]))
    {
        for(NSString *key in [dictionary allKeys])
        {
            if([key isEqualToString:KEY_TYPE_IDENTIFIER])
                continue;
            
            id value = [dictionary valueForKey:key];
            
            if([value isKindOfClass:[NSArray class]])
            {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for(NSDictionary *item in value)
                {
                    if([self hasType:item])
                    {
                        id object = [self objectFromDictionary:item];
                        
                        if(object != nil)
                            [array addObject:object];
                    }
                }
                
                [self setValue:array forKey:key];
            }
            else if([value isKindOfClass:[NSDictionary class]])
            {
                if([self hasType:value])
                {
                    id object = [self objectFromDictionary:value];
                    
                    if(object != nil)
                        [self setValue:object forKey:key];
                }
            }
            else
                [self setValue:value forKey:key];
        }
    }
    
    return self;
}

#pragma mark - Public Methods

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
    
    if([self superclass] != nil)
    {
        NSString *name = NSStringFromClass([self superclass]);
        
        if(![name isEqualToString:@"NSObject"])
            [result addObjectsFromArray:[[self superclass] propertyKeys]];
    }
    
    return result;
}

- (NSMutableDictionary *)dictionary
{
    NSArray *keys = [self propertyKeys];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    for(NSString *key in keys)
    {
        id property = [self valueForKey:key];
        
        if([property isKindOfClass:[NSArray class]])
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for(id object in property)
                [array addObject:[object dictionary]];
            
            [result setValue:array forKey:key];
        }
        else if(![property isKindOfClass:[NSString class]] &&
                ![property isKindOfClass:[NSNumber class]] &&
                ![property isKindOfClass:[NSValue class]])
            [result setValue:[property dictionary] forKey:key];
        else
            [result setValue:[self valueForKey:key] forKey:key];
    }
    
    [result setValue:NSStringFromClass([self class]) forKey:KEY_TYPE_IDENTIFIER];
    
    return result;
}

#pragma mark - Private Methods

- (BOOL)hasType:(NSDictionary *)dictionary
{
    for(NSString *key in [dictionary allKeys])
    {
        if([key isEqualToString:KEY_TYPE_IDENTIFIER])
            return YES;
    }
    
    return NO;
}

- (id)objectFromDictionary:(NSDictionary *)dictionary
{
    NSString *type = [dictionary valueForKey:KEY_TYPE_IDENTIFIER];
    Class class = NSClassFromString(type);
    
    return [[class alloc] initWithDictionary:dictionary];
}

@end
