//
//  ModelBase.m
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "ModelBase.h"

@implementation ModelBase

#pragma mark - Constructors

- (id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    if((self = [super init]))
    {
        _dictionary = dictionary;
    }
    
    return self;
}

@end
