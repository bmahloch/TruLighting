//
//  LightingUnit.h
//  TruLightingUI
//
//  Created by bmahloch on 1/25/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupLight, LightingState;

@interface LightingUnit : NSManagedObject

@property (nonatomic, retain) NSString * ip;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) LightingState *currentState;
@property (nonatomic, retain) NSSet *groupLights;
@end

@interface LightingUnit (CoreDataGeneratedAccessors)

- (void)addGroupLightsObject:(GroupLight *)value;
- (void)removeGroupLightsObject:(GroupLight *)value;
- (void)addGroupLights:(NSSet *)values;
- (void)removeGroupLights:(NSSet *)values;

@end
