//
//  UnitControlViewController.h
//  TruLightingUI
//
//  Created by bmahloch on 1/29/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TILightingUnit;

@interface UnitControlViewController : UITableViewController

@property (strong, nonatomic) TILightingUnit *controllableUnit;
- (IBAction)switchOn_Changed:(id)sender;

@end
