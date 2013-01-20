//
//  AppRepository.h
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HueConfiguration;

@interface AppRepository : NSObject

- (NSMutableArray *)getAllLights;
- (NSMutableArray *)getHueConfiguration;

- (void)saveHueConfiguration:(NSMutableArray *)configuration;

@end
