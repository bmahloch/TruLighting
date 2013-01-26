//
//  DMXLightingUnit.h
//  TruLightingUI
//
//  Created by bmahloch on 1/24/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LightingUnit.h"


@interface DMXLightingUnit : LightingUnit

@property (nonatomic, retain) NSNumber * universe;
@property (nonatomic, retain) NSNumber * channel;
@property (nonatomic, retain) NSNumber * kind;

@end
