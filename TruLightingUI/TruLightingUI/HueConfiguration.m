//
//  HueConfiguration.m
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "HueConfiguration.h"
#import "HueBridge.h"

@implementation HueConfiguration

#pragma mark - Constants

NSString *const DATA_KEY_BRIDGES = @"Bridges";

- (NSMutableArray *)bridges
{
    NSMutableArray *result = [NSMutableArray array];
    
    for(NSMutableDictionary *dict in [self.dictionary valueForKey:DATA_KEY_BRIDGES])
        [result addObject:[[HueBridge alloc] initWithDictionary:dict]];
         
    return result;
}

- (void)setBridges:(NSMutableArray *)bridges
{
    [self.dictionary setValue:bridges forKey:DATA_KEY_BRIDGES];
}

@end
