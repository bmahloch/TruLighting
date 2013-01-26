//
//  LightingState.h
//  TruLightingUI
//
//  Created by bmahloch on 1/25/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LightingState : NSManagedObject

@property (nonatomic, retain) NSString * lightingStateId;
@property (nonatomic, retain) NSNumber * red;
@property (nonatomic, retain) NSNumber * green;
@property (nonatomic, retain) NSNumber * blue;
@property (nonatomic, retain) NSNumber * intensity;
@property (nonatomic, retain) NSNumber * warmth;
@property (nonatomic, retain) NSNumber * on;

@end
