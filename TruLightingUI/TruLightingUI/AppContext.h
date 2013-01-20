//
//  AppContext.h
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMessageHueApiKeyNotFound @"Api key not found. Access denied."
#define kMessageHueBridgeExists @"Bridge already configured with the specified address."

@class AppRepository;

@interface AppContext : NSObject

@property (strong, nonatomic) AppRepository *repository;

+ (AppContext *)sharedContext;

- (void)displayMessages:(NSArray *)messages;
- (void)displayMessage:(NSString *)message;

@end
