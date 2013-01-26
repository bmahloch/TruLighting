//
//  NSObject+Extensions.h
//  TruLightingUI
//
//  Created by bmahloch on 1/21/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extensions)

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSArray *)propertyKeys;
- (NSMutableDictionary *)dictionary;

@end
