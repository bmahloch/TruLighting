//
//  TILightingGroup.h
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TILightingController.h"

#define kDataKeyLightingUnits @"LightingUnits"

@interface TILightingGroup : NSObject <TILightingController>

@property (strong, nonatomic) NSMutableArray *lightingUnits;

@property UIColor *color;
@property NSInteger intensity;

- (id)init;

@end
