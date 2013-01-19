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

#define kDataKeyClass @"class"
#define kDataKeyRed @"red"
#define kDataKeyGreen @"green"
#define kDataKeyBlue @"blue"
#define kDataKeyColor @"color"

@interface TILightingUnit : NSObject <TILightingController>

@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) UIColor *color;
@property NSInteger intensity;
@property (strong, nonatomic) NSString *ipAddress;
@property (strong, nonatomic) NSString *name;

+ (TILightingUnit *)createFromDictionary:(NSDictionary *)dictionary;
- (NSMutableDictionary *)dictionary;
- (NSArray *)propertyKeys;

@end
