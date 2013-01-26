//
//  HueHelper.h
//  TruLightingUI
//
//  Created by bmahloch on 1/26/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HueHelper : NSObject

+ (void)updateStatus:(NSDictionary *)status withApiKey:(NSString *)apiKey;

@end
