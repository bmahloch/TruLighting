//
//  UnitControlViewController.m
//  TruLightingUI
//
//  Created by bmahloch on 1/29/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "UnitControlViewController.h"
#import "TILightingUnit.h"
#import "LightingUnit.h"

@interface UnitControlViewController ()

@end

@implementation UnitControlViewController

#pragma mark - Constructors

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {

    }
    
    return self;
}

#pragma mark - Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Event Handlers

- (IBAction)switchOn_Changed:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    
    if(sw.on)
    {
        _controllableUnit.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _controllableUnit.intensity = 255;
    }
    else
    {
        _controllableUnit.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        _controllableUnit.intensity = 0;
    }
    
    [_controllableUnit updateColor];
}

@end
