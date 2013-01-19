//
//  HueAddBridgeCell.m
//  TruLightingUI
//
//  Created by bmahloch on 1/19/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "HueAddBridgeCell.h"

@implementation HueAddBridgeCell

#pragma mark - Constructors

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {

    }
    
    return self;
}

#pragma mark - Overrides

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Event Handlers

- (IBAction)btnAddBridge_Touched:(id)sender
{
    if(_delegate != nil)
        [_delegate cellAddBridgeTouched:self];
}

@end
