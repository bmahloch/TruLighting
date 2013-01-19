//
//  AppContext.h
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppRepository;

@interface AppContext : NSObject

@property (strong, nonatomic) AppRepository *repository;

+ (AppContext *)sharedContext;

@end
