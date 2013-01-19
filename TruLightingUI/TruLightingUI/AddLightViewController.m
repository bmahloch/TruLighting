//
//  AddLightViewController.m
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "AddLightViewController.h"

@interface AddLightViewController ()

@end

@implementation AddLightViewController
{
    NSArray *_dataSource;
}

#pragma mark - Constants

NSString *const DMX_SEGUE = @"AddDMX";
NSString *const HUE_SEGUE = @"AddHue";

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
    
    _dataSource = [NSArray arrayWithObjects:@"Hue", @"Art-NET DMX", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate Implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        [self performSegueWithIdentifier:HUE_SEGUE sender:self];
    else
        [self performSegueWithIdentifier:DMX_SEGUE sender:self];
}

@end
