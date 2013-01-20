//
//  TIHueLightingUnit.m
//  TruLightingLib
//
//  Created by bmahloch on 1/6/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "TIHueLightingUnit.h"
#import "UIColor+Extensions.h"
#import "ServiceManager.h"

@interface TIHueLightingUnit ()

- (NSMutableDictionary *)getColorState;
- (void)updateState:(NSMutableDictionary *)state;
- (dispatch_queue_t)getDispatchQueue;

@end

@implementation TIHueLightingUnit
{
    NSMutableDictionary *_commandState;
    dispatch_source_t _timer;
    dispatch_queue_t _queue;
}

#pragma mark - TILightingController Implementation

- (void)updateColor
{
    [self updateState:[self getColorState]];
}

- (void)updateIntensity
{
    NSMutableDictionary *state = [NSMutableDictionary dictionary];
    
    [state setValue:[NSNumber numberWithInteger:self.intensity] forKey:kStateKeyBrightness];
    [state setValue:[NSNumber numberWithBool:YES] forKey:kStateKeyOn];
    
    [self updateState:state];
}

- (void)fadeOff
{
    [self fadeOffOverDuration:kDefaultFadeDuration];
}

- (void)fadeOffOverDuration:(float)duration
{
    NSMutableDictionary *state = [NSMutableDictionary dictionary];
    
    [state setValue:[NSNumber numberWithBool:NO] forKey:kStateKeyOn];
    
    [self updateState:state];
}

- (void)fadeOn
{
    [self fadeOnOverDuration:kDefaultFadeDuration];
}

- (void)fadeOnOverDuration:(float)duration
{
    [self updateColor];
}

- (void)blink
{
    [self blinkForDuration:kDefaultBlinkDuration];
}

- (void)blinkForDuration:(float)duration
{
    NSMutableDictionary *state = [NSMutableDictionary dictionary];
    
    [state setValue:kStateValueFlashRepeat forKey:kStateKeyAlert];
    
    [self updateState:state];
}

#pragma mark - Private Methods

- (NSMutableDictionary *)getColorState
{
    CGFloat h,s,v;
    NSInteger hue, saturation;
    
    [self.color h:&h s:&s v:&v];
    
    hue = HueToScale(h);
    saturation = SaturationToScale(s);
    
    NSMutableDictionary *state = [NSMutableDictionary dictionary];
    
    [state setValue:[NSNumber numberWithInteger:self.intensity] forKey:kStateKeyBrightness];
    [state setValue:[NSNumber numberWithInteger:hue] forKey:kStateKeyHue];
    [state setValue:[NSNumber numberWithInteger:saturation] forKey:kStateKeySaturation];
    [state setValue:[NSNumber numberWithBool:YES] forKey:kStateKeyOn];
    
    return state;
}

- (void)updateState:(NSMutableDictionary *)state
{
    _commandState = state;
    
    if(!_timer)
    {
        _queue = [self getDispatchQueue];
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        
        if(_timer)
        {
            dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), kHueLoopingCommandDelay * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(_timer, ^(){
               
                @synchronized(self)
                {
                    if(_commandState == nil)
                    {
                        dispatch_source_cancel(_timer);
                        _timer = nil;
                    }
                    else
                        [[ServiceManager defaultManager] setHueLightingUnit:self withState:_commandState];
                    
                    _commandState = nil;
                }
                
            });
            
            dispatch_resume(_timer);
        }
    }
}

- (dispatch_queue_t)getDispatchQueue
{
    if(_queue == nil)
    {
        NSString *queueLabel = [NSString stringWithFormat:kHueDispatchQueueNameFormat, self.uniqueId];
        _queue = dispatch_queue_create([queueLabel cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    }
    
    return _queue;
}

@end
