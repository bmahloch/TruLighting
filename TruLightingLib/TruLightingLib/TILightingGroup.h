//
//  TILightingGroup.h
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TILightingUnit.h"

@interface TILightingGroup : TILightingUnit

@property (strong, nonatomic) NSMutableArray *lightingUnits;

- (id)init;

@end
