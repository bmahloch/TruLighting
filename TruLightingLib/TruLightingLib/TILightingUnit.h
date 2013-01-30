//
//  TILightingUnit.h
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TILightingController.h"

#define RGBIntegerToFloat(v) (CGFloat)v / 255

@interface TILightingUnit : NSObject <TILightingController>

@property (strong, nonatomic) UIColor *color;
@property NSInteger intensity;
@property (strong, nonatomic) NSString *ip;
@property BOOL on;

@end
