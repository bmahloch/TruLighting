//
//  TruLightingUITests.m
//  TruLightingUITests
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//
#import <objc/objc.h>
#import <objc/runtime.h>
#import "TruLightingUITests.h"
#import "LightingGroup.h"
#import "LightingUnit.h"

#import "NSObject+Extensions.h"

@implementation TruLightingUITests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test_kvc
{
    LightingGroup *group = [[LightingGroup alloc] init];
    
    group.name = @"Group Name";
    
    LightingUnit *unit = [[LightingUnit alloc] init];
    
    unit.name = @"Unit 1";
    unit.unitId = 1;
    
    [group.lightingUnits addObject:unit];
    
    unit = [[LightingUnit alloc] init];
    
    unit.name = @"Unit 2";
    unit.unitId = 2;
    
    [group.lightingUnits addObject:unit];
    
    group.defaultUnit = [[LightingUnit alloc] init];
    group.defaultUnit.name = @"Default Unit";
    group.defaultUnit.unitId = 3;
    
    NSMutableDictionary *dictionary = [group dictionary];
    
    LightingGroup *object = [[LightingGroup alloc] initWithDictionary:dictionary];
    
    NSMutableDictionary *dictionary2 = [object dictionary];
    
    STAssertNotNil(dictionary2, @"dictionary should not be nil");
    
}

@end
