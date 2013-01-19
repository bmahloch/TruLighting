//
//  NSString+Extensions.m
//  TruLightingLib
//
//  Created by bmahloch on 1/12/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+ (NSString *)guid
{
    CFUUIDRef result = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, result);
    
    return (__bridge NSString *)string;
}

@end
