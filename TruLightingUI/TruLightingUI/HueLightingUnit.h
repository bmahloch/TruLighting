//
//  HueLightingUnit.h
//  TruLightingUI
//
//  Created by bmahloch on 1/24/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LightingUnit.h"


@interface HueLightingUnit : LightingUnit

@property (nonatomic, retain) NSNumber * lightId;
@property (nonatomic, retain) NSString * apiKey;

@end
