//
//  TruLightingLibTests.m
//  TruLightingLibTests
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "TruLightingLibTests.h"
#import "TILightingGroup.h"
#import "TILightingUnit.h"
#import "TIDMXLightingUnit.h"
#import "TIHueLightingUnit.h"
#import "TILightingManager.h"

@implementation TruLightingLibTests

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

/*
- (void)test_single_dmx_unit_on;
{
    TILightingGroup *group = [TILightingGroup new];
    TIDMXLightingUnit *unit = [TIDMXLightingUnit new];
    
    unit.ipAddress = @"10.0.0.3";
    unit.universe = 0;
    unit.channel = 1;
    unit.type = kDMXUnitTypeRGB;
    
    [group.lightingUnits addObject:unit];

    group.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    group.intensity = 255;
    
    //STAssertNoThrow([[TILightingManager sharedManager] setLightingGroup:group], @"test_single_dmx_unit_on");
}

- (void)test_single_hue_unit_on;
{
    TILightingGroup *group = [TILightingGroup new];
    TIHueLightingUnit *unit = [TIHueLightingUnit new];
    
    unit.ipAddress = @"10.0.0.14";
    unit.apiKey = @"3c2e023bcde31bab6839d7e95c5359a3";
    unit.lightId = 3;
    
    [group.lightingUnits addObject:unit];
    
    group.color = [UIColor colorWithRed:1 green:1 blue:0 alpha:1];
    group.intensity = 255;
    
    //STAssertNoThrow([[TILightingManager sharedManager] setLightingGroup:group], @"test_single_hue_unit_on");
}

- (void)test_single_hue_unit_intensity;
{
    TIHueLightingUnit *unit = [TIHueLightingUnit new];
    
    unit.ipAddress = @"10.0.0.14";
    unit.apiKey = @"3c2e023bcde31bab6839d7e95c5359a3";
    unit.lightId = 3;
    
    unit.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    unit.intensity = 64;
    
    //STAssertNoThrow([[TILightingManager sharedManager] updateIntensityOfLightingUnit:unit], @"test_single_hue_unit_intensity");
}

- (void)test_dmx_unit_dictionary
{
    TIDMXLightingUnit *unit = [TIDMXLightingUnit new];
    
    unit.uniqueId = @"abc";
    unit.name = @"test light";
    unit.ipAddress = @"10.0.0.3";
    unit.universe = 0;
    unit.channel = 1;
    unit.type = kDMXUnitTypeRGB;
    unit.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    unit.intensity = 255;
    
    NSMutableDictionary *dictionary = [unit dictionary];
    
    STAssertNotNil([dictionary valueForKey:kDataKeyClass], @"Dictionary requires a 'class' key");
}

- (void)test_dmx_unit_create_from_dictionary
{
    TIDMXLightingUnit *unit = [TIDMXLightingUnit new];
    
    unit.uniqueId = @"abc";
    unit.name = @"test light";
    unit.ipAddress = @"10.0.0.3";
    unit.universe = 0;
    unit.channel = 1;
    unit.type = kDMXUnitTypeRGB;
    unit.color = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    unit.intensity = 255;
    
    NSMutableDictionary *dictionary = [unit dictionary];
    
    TILightingUnit *result = [TILightingUnit createFromDictionary:dictionary];
    
    STAssertTrue([result isKindOfClass:[TIDMXLightingUnit class]], @"Proper lighting unit not derived from dictionary");
}

*/

- (void)test_hue_connection
{
    NSString *apiKey;
    bool result = [TILightingManager connectToHueHost:@"10.0.0.2" apiKey:&apiKey];
    
    while(!result)
    {
        [NSThread sleepForTimeInterval:0.5f];
    }
}

@end
