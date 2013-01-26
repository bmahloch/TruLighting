//
//  GroupLight.h
//  TruLightingUI
//
//  Created by bmahloch on 1/25/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LightingState;

@interface GroupLight : NSManagedObject

@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) LightingState *lightingState;

@end
