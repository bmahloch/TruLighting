//
//  ViewController.m
//  TruLightingUI
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "ViewController.h"
#import "TILightingGroup.h"
#import "TIDMXLightingUnit.h"
#import "TIHueLightingUnit.h"
#import "TILightingUnit.h"
#import "TILightingManager.h"

@interface ViewController ()

@end

@implementation ViewController
{
    TILightingGroup *_group;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(10.0, 40.0, 200.0, 200.0)];
    
	[_colorPicker setDelegate:self];
	[_colorPicker setBrightness:1.0];
	[_colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
	[_colorPicker setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_colorPicker];
    
    _group = [TILightingGroup new];
    TIDMXLightingUnit *unit = [TIDMXLightingUnit new];
    
    unit.uniqueId = @"A";
    unit.ipAddress = @"10.0.0.3";
    unit.universe = 0;
    unit.channel = 1;
    unit.type = kDMXUnitTypeRGB;
    
    TIHueLightingUnit *unit2 = [TIHueLightingUnit new];
    
    unit2.uniqueId = @"B";
    unit2.ipAddress = @"10.0.0.45";
    unit2.apiKey = @"3c2e023bcde31bab6839d7e95c5359a3";
    unit2.lightId = 3;
    
    TIHueLightingUnit *unit3 = [TIHueLightingUnit new];
    
    unit3.uniqueId = @"C";
    unit3.ipAddress = @"10.0.0.45";
    unit3.apiKey = @"3c2e023bcde31bab6839d7e95c5359a3";
    unit3.lightId = 2;
    
    TIHueLightingUnit *unit4 = [TIHueLightingUnit new];
    
    unit4.uniqueId = @"D";
    unit4.ipAddress = @"10.0.0.45";
    unit4.apiKey = @"3c2e023bcde31bab6839d7e95c5359a3";
    unit4.lightId = 1;
    
    [_group.lightingUnits addObject:unit];
    [_group.lightingUnits addObject:unit2];
    [_group.lightingUnits addObject:unit3];
    [_group.lightingUnits addObject:unit4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RSColorPickerViewDelegate Implementation

-(void)colorPickerDidChangeSelection:(RSColorPickerView*)cp
{
    _group.color = cp.selectionColor;
    _group.intensity = (int)_sldrIntensity.value;
    
    [_group updateColor];
}

- (IBAction)sldrChanged:(id)sender
{
    _group.intensity = (int)_sldrIntensity.value;
    
    [_group updateIntensity];
}

- (IBAction)btnFadeOffTapped:(id)sender
{
    [_group fadeOff];
    //[_group blink];
}

- (IBAction)btnFadeOnTapped:(id)sender
{
    _group.intensity = (int)_sldrIntensity.value;
    
    [_group fadeOn];
}

- (IBAction)btnHueTapped:(id)sender
{
    
}

- (void)viewDidUnload
{
    [self setSldrIntensity:nil];
    [super viewDidUnload];
}
@end
