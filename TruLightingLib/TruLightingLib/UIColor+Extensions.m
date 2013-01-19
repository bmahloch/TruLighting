//
//  UIColor+Extensions.m
//  TruLightingLib
//
//  Created by bmahloch on 1/7/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

- (void)r:(NSInteger *)r g:(NSInteger *)g b:(NSInteger *)b
{
    const CGFloat *colors = CGColorGetComponents(self.CGColor);
    
    *r = (NSInteger)(colors[0] * 255);
    *g = (NSInteger)(colors[1] * 255);
    *b = (NSInteger)(colors[2] * 255);
}

- (void)h:(CGFloat *)h s:(CGFloat *)s v:(CGFloat *)v
{
    NSInteger r,g,b;
    CGFloat hue,saturation,value;
    
    [self r:&r g:&g b:&b];
    
	// From Foley and Van Dam
	CGFloat max = MAX(r, MAX(g, b));
	CGFloat min = MIN(r, MIN(g, b));
	
	// Brightness
	value = max;
	
	// Saturation
	saturation = (max != 0.0f) ? ((max - min) / max) : 0.0f;
	
	if (saturation == 0.0f)
    {
		// No saturation, so undefined hue
		hue = 0.0f;
	}
    else
    {
		// Determine hue
		CGFloat rc = (max - r) / (max - min);		// Distance of color from red
		CGFloat gc = (max - g) / (max - min);		// Distance of color from green
		CGFloat bc = (max - b) / (max - min);		// Distance of color from blue
		
		if (r == max) hue = bc - gc;					// resulting color between yellow and magenta
		else if (g == max) hue = 2 + rc - bc;			// resulting color between cyan and yellow
		else /* if (b == max) */ hue = 4 + gc - rc;	// resulting color between magenta and cyan
              
        hue *= 60.0f;									// Convert to degrees
        if (hue < 0.0f) hue += 360.0f;					// Make non-negative
        hue /= 360.0f;                                // Convert to decimal
    }
              
    if (h) *h = hue;
    if (s) *s = saturation;
    if (v) *v = value;
}

@end
