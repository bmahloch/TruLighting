//
//  ModelBase.h
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBase : NSObject

@property (strong, nonatomic) NSMutableDictionary *dictionary;

- (id)initWithDictionary:(NSMutableDictionary *)dictionary;

@end
