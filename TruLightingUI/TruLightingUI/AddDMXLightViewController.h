//
//  AddDMXLightViewController.h
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDMXLightViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *txtHost;
@property (weak, nonatomic) IBOutlet UITextField *txtUniverse;
@property (weak, nonatomic) IBOutlet UITextField *txtChannel;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segType;

- (IBAction)done:(id)sender;

@end
