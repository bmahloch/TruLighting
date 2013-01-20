//
//  AppContext.m
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "AppContext.h"
#import "AppRepository.h"

static AppContext *_sharedContext;

@implementation AppContext

#pragma mark - Constructors

- (id)init
{
    if((self = [super init]))
    {
        _repository = [[AppRepository alloc] init];
    }
    
    return self;
}

#pragma mark - Public Methods

+ (AppContext *)sharedContext
{
    @synchronized(self)
    {
        if(_sharedContext == nil)
            _sharedContext = [[AppContext alloc] init];
    }
    
    return _sharedContext;
}

- (void)displayMessages:(NSArray *)messages
{
    [self displayMessage:[messages componentsJoinedByString:@","]];
}

- (void)displayMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}

@end
