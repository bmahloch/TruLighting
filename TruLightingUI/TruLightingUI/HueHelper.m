//
//  HueHelper.m
//  TruLightingUI
//
//  Created by bmahloch on 1/26/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "HueHelper.h"
#import "AppRepository.h"
#import "HueLightingUnit.h"

@implementation HueHelper

#pragma mark - Public Methods

+ (void)updateStatus:(NSDictionary *)status withApiKey:(NSString *)apiKey
{
    NSDictionary *bridge = [status valueForKey:DATA_KEY_HUE_BRIDGE_CONFIGURATION];
    NSString *ip = [bridge valueForKey:DATA_KEY_HUE_BRIDGE_IP_ADDRESS];
    
    if([[AppContext sharedContext].repository saveHueBridge:bridge withApiKey:apiKey])
    {
        [[AppContext sharedContext].repository getHueLightingUnitsForApiKey:apiKey success:^(NSArray *existingLightingUnits){
            
            NSDictionary *currentLightingUnits = [status valueForKey:DATA_KEY_HUE_BRIDGE_LIGHTS];
            NSUInteger inserts = 0, updates = 0;
            
            for(NSString *key in [currentLightingUnits allKeys])
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", DATA_KEY_HUE_LIGHT_ID, [NSNumber numberWithInteger:[key integerValue]]];
                NSArray *found = [existingLightingUnits filteredArrayUsingPredicate:predicate];
                NSDictionary *current = [currentLightingUnits valueForKey:key];
                
                if(found == nil || found.count == 0)
                {
                    HueLightingUnit *new = (HueLightingUnit *)[[AppContext sharedContext].repository createEntity:ENTITY_HUE_LIGHTING_UNIT];
                    
                    new.lightId = [NSNumber numberWithInteger:[key integerValue]];
                    new.name = [current valueForKey:DATA_KEY_LIGHTING_UNIT_NAME];
                    new.apiKey = apiKey;
                    new.ip = ip;
                    
                    inserts++;
                }
                else
                {
                    HueLightingUnit *existing = [found objectAtIndex:0];
                    
                    existing.name = [current valueForKey:DATA_KEY_LIGHTING_UNIT_NAME];
                    existing.ip = ip;
                    
                    updates++;
                }
            }
            
            [[AppContext sharedContext].repository save:^(void){
                
                // return counts;
                
            }failure:^(NSError *error){
                
                [[AppContext sharedContext] displayMessage:[error localizedDescription]];
                
            }];
            
        }failure:^(NSError *error){
            
            [[AppContext sharedContext] displayMessage:[error localizedDescription]];
            
        }];
    }
}

@end
