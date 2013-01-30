//
//  TILightingController.h
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDefaultFadeDuration 1.0f
#define kDefaultBlinkDuration 15.0f
#define kBlinkDelay 0.5f

#define kDMXLoopingCommandDelay 0.025f
#define kHueLoopingCommandDelay 0.5f

#define kDMXDispatchQueueNameFormat @"com.truidea.dmxqueue%d"
#define kHueDispatchQueueNameFormat @"com.truidea.huequeue%d"

@protocol TILightingController <NSObject>

- (void)update;
- (void)updateColor;
- (void)updateIntensity;
- (void)fadeOff;
- (void)fadeOffOverDuration:(float)duration;
- (void)fadeOn;
- (void)fadeOnOverDuration:(float)duration;
- (void)blink;
- (void)blinkForDuration:(float)duration;

@end
