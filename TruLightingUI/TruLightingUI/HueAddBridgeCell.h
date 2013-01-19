//
//  HueAddBridgeCell.h
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HueAddBridgeCellDelegate;

@interface HueAddBridgeCell : UITableViewCell

@property (weak, nonatomic) id<HueAddBridgeCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtBridgeAddress;

- (IBAction)btnAddBridge_Touched:(id)sender;

@end

@protocol HueAddBridgeCellDelegate <NSObject>

- (void)cellAddBridgeTouched:(HueAddBridgeCell *)cell;

@end
