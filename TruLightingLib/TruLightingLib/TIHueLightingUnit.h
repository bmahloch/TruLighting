//
//  TIHueLightingUnit.h
//  TruLightingLib
//
//  Created by bmahloch on 1/6/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TILightingUnit.h"

#define HueToScale(h) (NSInteger)(h * 65535);
#define SaturationToScale(s) (NSInteger)(s * 255);

#define kStateKeyBrightness @"bri"
#define kStateKeyHue @"hue"
#define kStateKeySaturation @"sat"
#define kStateKeyOn @"on"
#define kStateKeyAlert @"alert"

#define kStateValueFlashOnce @"select"
#define kStateValueFlashRepeat @"lselect"

@interface TIHueLightingUnit : TILightingUnit

@property (strong, nonatomic) NSString *apiKey;
@property NSInteger lightId;

@end
