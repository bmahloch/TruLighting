//
//  AppRepository.m
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "AppRepository.h"
#import "TILightingUnit.h"

@interface AppRepository ()

- (NSString *)documentsDirectory;

@end

@implementation AppRepository

#pragma mark - Constants

NSString *const DATA_FILE_LIGHTS = @"Lights.plist";

#pragma mark - Public Methods

- (NSMutableArray *)getAllLights
{
    NSString *path = [[self documentsDirectory] stringByAppendingPathComponent:DATA_FILE_LIGHTS];
    NSMutableArray *result = [NSMutableArray array];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSArray *lights = [NSArray arrayWithContentsOfFile:path];
        
        for(NSDictionary *dictionary in lights)
            [result addObject:[TILightingUnit createFromDictionary:dictionary]];
    }
    
    return result;
}

#pragma mark - Private Methods

- (NSString *)documentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

@end