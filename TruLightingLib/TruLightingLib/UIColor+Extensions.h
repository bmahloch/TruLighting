//
//  UIColor+Extensions.h
//  TruLightingLib
//
//  Created by bmahloch on 1/7/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

- (void)r:(NSInteger *)r g:(NSInteger *)g b:(NSInteger *)b;
- (void)h:(CGFloat *)h s:(CGFloat *)s v:(CGFloat *)v;

@end
