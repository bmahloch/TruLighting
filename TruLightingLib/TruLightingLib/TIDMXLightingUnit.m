//
//  TIDMXLightingUnit.m
//  TruLightingLib
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "TIDMXLightingUnit.h"
#import "UIColor+Extensions.h"

@interface TIDMXLightingUnit ()

- (void)initializeArtnetPacket;
- (void)updateArtnetPacketWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue intensity:(NSInteger)intensity;
- (void)sendArtnetPacket;
- (dispatch_queue_t)getDispatchQueue;

@end

@implementation TIDMXLightingUnit
{
    NSMutableData *_artnetPacket;
    GCDAsyncUdpSocket *_socket;
    dispatch_queue_t _queue;
}

#pragma mark - Constants

const int ARTNET_PORT = 0x1936;
const int DMX_DATA_OFFSET = 0x12;
const int ARTNET_ZERO = 0x00;
const int ARTNET_OPCODE = 0x50;
const int ARTNET_PROTOCOL_VERSION = 0x0E;
const int ARTNET_DATA_MAX = 0xFF;
NSString *const ARTNET_PROTOCOL_STRING = @"Art-Net";

#pragma mark - TILightingController Implementation

- (void)update
{
    
}

- (void)updateColor
{
    NSInteger r,g,b;
    [self.color r:&r g:&g b:&b];
    
    [self initializeArtnetPacket];
    [self updateArtnetPacketWithRed:r green:g blue:b intensity:self.intensity];
    [self sendArtnetPacket];
}

- (void)updateIntensity
{
    [self updateColor];
}

- (void)fadeOff
{
    [self fadeOffOverDuration:kDefaultFadeDuration];
}

- (void)fadeOffOverDuration:(float)duration
{
    dispatch_async([self getDispatchQueue], ^(){
        
        NSDate *startTime = [NSDate date];
        NSTimeInterval elapsed = fabs([startTime timeIntervalSinceNow]);
        NSInteger intensity = self.intensity;
        
        while(elapsed < duration)
        {
            self.intensity = intensity - (intensity * (elapsed / duration));
            
            [self updateIntensity];
            
            [NSThread sleepForTimeInterval:kDMXLoopingCommandDelay];
            elapsed = fabs([startTime timeIntervalSinceNow]);
        }
        
        self.intensity = 0;
        
        [self updateIntensity];
        
    });
}

- (void)fadeOn
{
    [self fadeOnOverDuration:kDefaultFadeDuration];
}

- (void)fadeOnOverDuration:(float)duration
{
    dispatch_async([self getDispatchQueue], ^(){
        
        NSDate *startTime = [NSDate date];
        NSTimeInterval elapsed = fabs([startTime timeIntervalSinceNow]);
        NSInteger intensity = self.intensity;
        
        while(elapsed < duration)
        {
            self.intensity = intensity * (elapsed / duration);
            
            [self updateIntensity];
            
            [NSThread sleepForTimeInterval:kDMXLoopingCommandDelay];
            elapsed = fabs([startTime timeIntervalSinceNow]);
        }
        
        self.intensity = intensity;
        
        [self updateIntensity];
        
    });
}

- (void)blink
{
    [self blinkForDuration:kDefaultBlinkDuration];
}

- (void)blinkForDuration:(float)duration
{
    dispatch_async([self getDispatchQueue], ^(){
       
        NSDate *startTime = [NSDate date];
        NSTimeInterval elapsed = fabs([startTime timeIntervalSinceNow]);
        NSInteger intensity = self.intensity;
        
        while(elapsed < duration)
        {
            self.intensity = self.intensity == 64 ? 255 : 64;
            
            [self updateIntensity];
            
            [NSThread sleepForTimeInterval:kBlinkDelay];
            elapsed = fabs([startTime timeIntervalSinceNow]);
        }
        
        self.intensity = intensity;
        
        [self updateIntensity];
        
    });
}

#pragma mark - Private Methods

- (void)initializeArtnetPacket
{
    if(_artnetPacket != nil)
        return;
    
    _artnetPacket = [[NSMutableData alloc] initWithLength:(DMX_DATA_OFFSET + ARTNET_DATA_MAX)];
    
    [_artnetPacket replaceBytesInRange:NSMakeRange(0, 7) withBytes:[[ARTNET_PROTOCOL_STRING dataUsingEncoding:NSASCIIStringEncoding] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(7, 1) withBytes:[[NSData dataWithBytes:&ARTNET_ZERO length:sizeof(ARTNET_ZERO)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(8, 1) withBytes:[[NSData dataWithBytes:&ARTNET_ZERO length:sizeof(ARTNET_ZERO)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(9, 1) withBytes:[[NSData dataWithBytes:&ARTNET_OPCODE length:sizeof(ARTNET_OPCODE)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(10, 1) withBytes:[[NSData dataWithBytes:&ARTNET_ZERO length:sizeof(ARTNET_ZERO)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(11, 1) withBytes:[[NSData dataWithBytes:&ARTNET_PROTOCOL_VERSION length:sizeof(ARTNET_PROTOCOL_VERSION)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(12, 1) withBytes:[[NSData dataWithBytes:&ARTNET_ZERO length:sizeof(ARTNET_ZERO)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(13, 1) withBytes:[[NSData dataWithBytes:&ARTNET_ZERO length:sizeof(ARTNET_ZERO)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(15, 1) withBytes:[[NSData dataWithBytes:&ARTNET_ZERO length:sizeof(ARTNET_ZERO)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(16, 1) withBytes:[[NSData dataWithBytes:&ARTNET_ZERO length:sizeof(ARTNET_ZERO)] bytes]];
    [_artnetPacket replaceBytesInRange:NSMakeRange(17, 1) withBytes:[[NSData dataWithBytes:&ARTNET_DATA_MAX length:sizeof(ARTNET_DATA_MAX)] bytes]];
}

- (void)updateArtnetPacketWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue intensity:(NSInteger)intensity
{
    NSInteger universe = self.universe;
    NSInteger channelCount = self.type == kDMXUnitTypeRGB ? 3 : 1;
    NSMutableData *dmxData = [[NSMutableData alloc] initWithLength:channelCount];
    
    [_artnetPacket replaceBytesInRange:NSMakeRange(14, 1) withBytes:[[NSData dataWithBytes:&universe length:sizeof(universe)] bytes]];
    
    if(channelCount == 1)
        [dmxData replaceBytesInRange:NSMakeRange(0, 1) withBytes:[[NSData dataWithBytes:&intensity length:sizeof(intensity)] bytes]];
    else
    {
        float intensityFactor = (float)intensity / 255;
        NSInteger r, g, b;
        
        r = red * intensityFactor;
        g = green * intensityFactor;
        b = blue * intensityFactor;
        
        [dmxData replaceBytesInRange:NSMakeRange(0, 1) withBytes:[[NSData dataWithBytes:&r length:sizeof(r)] bytes]];
        [dmxData replaceBytesInRange:NSMakeRange(1, 1) withBytes:[[NSData dataWithBytes:&g length:sizeof(g)] bytes]];
        [dmxData replaceBytesInRange:NSMakeRange(2, 1) withBytes:[[NSData dataWithBytes:&b length:sizeof(b)] bytes]];
    }
    
    [_artnetPacket replaceBytesInRange:NSMakeRange((DMX_DATA_OFFSET - 1) + self.channel, channelCount) withBytes:[dmxData bytes]];
}

- (void)sendArtnetPacket
{
    if(_socket == nil)
        _socket = [[GCDAsyncUdpSocket alloc] init];
    
    [_socket sendData:_artnetPacket toHost:self.ip port:ARTNET_PORT withTimeout:-1 tag:1];
}

- (dispatch_queue_t)getDispatchQueue
{
    if(_queue == nil)
    {
        NSString *queueLabel = [NSString stringWithFormat:kDMXDispatchQueueNameFormat, self.channel];
        _queue = dispatch_queue_create([queueLabel cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    }
    
    return _queue;
}

@end
