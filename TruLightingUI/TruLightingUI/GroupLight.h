//
//  GroupLight.h
//  TruLightingUI
//
//  Created by bmahloch on 1/29/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LightingState, LightingUnit;

@interface GroupLight : NSManagedObject

@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) LightingState *lightingState;
@property (nonatomic, retain) LightingUnit *lightingUnit;

@end
