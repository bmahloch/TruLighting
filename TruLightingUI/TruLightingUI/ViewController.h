//
//  ViewController.h
//  TruLightingUI
//
//  Created by bmahloch on 1/4/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"

@interface ViewController : UIViewController <RSColorPickerViewDelegate>

@property (strong, nonatomic) RSColorPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UISlider *sldrIntensity;
- (IBAction)sldrChanged:(id)sender;
- (IBAction)btnFadeOffTapped:(id)sender;
- (IBAction)btnFadeOnTapped:(id)sender;
- (IBAction)btnHueTapped:(id)sender;

@end
