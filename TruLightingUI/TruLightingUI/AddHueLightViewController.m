//
//  AddHueLightViewController.m
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "AddHueLightViewController.h"
#import "AppRepository.h"

#import "HueHelper.h"
#import "HueLightingUnit.h"

#import "TILightingManager.h"

@interface AddHueLightViewController()

- (void)loadBridges;
- (BOOL)bridgeExistsForHost:(NSString *)host;

@end

@implementation AddHueLightViewController
{
    NSMutableArray *_dataSource;
}

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
    [self loadBridges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource Implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _dataSource.count)
    {
        HueAddBridgeCell *cell = (HueAddBridgeCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ADD_BRIDGE forIndexPath:indexPath];
        
        cell.delegate = self;
        
        return cell;
    }
    else
    {
        NSDictionary *bridge = [_dataSource objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BRIDGE forIndexPath:indexPath];
        
        cell.textLabel.text = [bridge valueForKey:DATA_KEY_HUE_BRIDGE_NAME];
        cell.detailTextLabel.text = [bridge valueForKey:DATA_KEY_HUE_BRIDGE_IP_ADDRESS];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate Implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *bridge = [_dataSource objectAtIndex:indexPath.row];
    NSString *ip = [bridge valueForKey:DATA_KEY_HUE_BRIDGE_IP_ADDRESS];
    NSString *apiKey = [bridge valueForKey:DATA_KEY_HUE_API_KEY];
    
    [TILightingManager getStatusOfHueHost:ip apiKey:apiKey success:^(NSDictionary *status){
        
        [HueHelper updateStatus:status withApiKey:apiKey];
        
    }failure:^(NSInteger statusCode, NSArray *errors){
        
        [[AppContext sharedContext] displayMessages:errors];
        
    }];
}

#pragma mark - HueAddBridgeCellDelegate Implementation

- (void)cellAddBridgeTouched:(HueAddBridgeCell *)cell
{
    NSString *ipAddress = cell.txtBridgeAddress.text;
    
    if([self bridgeExistsForHost:ipAddress])
    {
        [[AppContext sharedContext] displayMessage:kMessageHueBridgeExists];
        return;
    }
    
    [TILightingManager connectToHueHost:ipAddress success:^(NSArray *result){
        
        NSString *apiKey = nil;
        
        for(NSDictionary *item in result)
        {
            if(apiKey != nil)
                break;
            
            for(NSString *key in [item allKeys])
            {
                if([key isEqualToString:DATA_KEY_HUE_REQUEST_SUCCESS])
                    apiKey = [[item valueForKey:key] valueForKey:DATA_KEY_HUE_BRIDGE_USERNAME];
            }
        }
        
        if(apiKey == nil)
            [[AppContext sharedContext] displayMessage:kMessageHueApiKeyNotFound];
        else
        {
            [TILightingManager getStatusOfHueHost:ipAddress apiKey:apiKey success:^(NSDictionary *status){
                
                [HueHelper updateStatus:status withApiKey:apiKey];
                [self loadBridges];
                
            }failure:^(NSInteger statusCode, NSArray *errors){
                
                [[AppContext sharedContext] displayMessages:errors];
                
            }];
        }
        
    }failure:^(NSInteger statusCode, NSArray *errors){
        
        [[AppContext sharedContext] displayMessages:errors];
        
    }];
}

#pragma mark - Private Methods

- (void)loadBridges
{
    _dataSource = [[AppContext sharedContext].repository getHueBridges];
    [self.tableView reloadData];
}

- (BOOL)bridgeExistsForHost:(NSString *)host
{
    return NO;
}

@end
