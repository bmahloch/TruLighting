//
//  TIDMXLightingUnit.h
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TILightingUnit.h"
#import "GCDAsyncUdpSocket.h"

typedef enum
{
    kDMXUnitTypeRGB,
    kDMXUnitTypeWhite
} TIDMXUnitType;

@interface TIDMXLightingUnit : TILightingUnit <GCDAsyncUdpSocketDelegate>

@property NSUInteger universe;
@property NSUInteger channel;
@property TIDMXUnitType type;

@end
