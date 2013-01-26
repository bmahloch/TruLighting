//
//  AddHueLightViewController.m
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "AddHueLightViewController.h"
#import "AppContext.h"
#import "AppRepository.h"

#import "HueConfiguration.h"
#import "HueLightingUnit.h"

#import "TILightingManager.h"

@interface AddHueLightViewController ()

- (void)updateLightingUnitsWithStatus:(NSDictionary *)status forApiKey:(NSString *)apiKey;

@end

@implementation AddHueLightViewController
{
    NSMutableArray *_dataSource;
}

#pragma mark - Constants

NSString *const CELL_IDENTIFIER_ADD_BRIDGE = @"HueAddBridgeCell";
NSString *const CELL_IDENTIFIER_BRIDGE = @"HueBridgeCell";

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
    
    _dataSource = [[AppContext sharedContext].repository getHueConfiguration];
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
        
        cell.textLabel.text = [bridge valueForKey:kDataKeyHueBridgeName];
        cell.detailTextLabel.text = [bridge valueForKey:kDataKeyHueBridgeIpAddress];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate Implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *bridge = [_dataSource objectAtIndex:indexPath.row];
    NSString *ip = [bridge valueForKey:kDataKeyHueBridgeIpAddress];
    NSString *apiKey = [bridge valueForKey:kDataKeyHueApiKey];
    
    [TILightingManager getStatusOfHueHost:ip apiKey:apiKey success:^(NSDictionary *status){
        
        [self updateLightingUnitsWithStatus:status forApiKey:apiKey];
        
    }failure:^(NSInteger statusCode, NSArray *errors){
        
        [[AppContext sharedContext] displayMessages:errors];
        
    }];
}

#pragma mark - HueAddBridgeCellDelegate Implementation

- (void)cellAddBridgeTouched:(HueAddBridgeCell *)cell
{
    NSString *ipAddress = cell.txtBridgeAddress.text;

    if([HueConfiguration bridgeExists:_dataSource byHost:ipAddress])
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
                if([key isEqualToString:kDataKeyHueSuccess])
                    apiKey = [[item valueForKey:key] valueForKey:kDataKeyHueUsername];
            }
        }
        
        if(apiKey == nil)
            [[AppContext sharedContext] displayMessage:kMessageHueApiKeyNotFound];
        else
        {
            [TILightingManager getStatusOfHueHost:ipAddress apiKey:apiKey success:^(NSDictionary *status){

                NSMutableDictionary *configuration = [status valueForKey:kDataKeyHueConfiguration];
                
                [configuration setValue:apiKey forKey:kDataKeyHueApiKey];
                [_dataSource addObject:configuration];
                [[AppContext sharedContext].repository saveHueConfiguration:_dataSource];
                [self updateLightingUnitsWithStatus:status forApiKey:apiKey];
                [self.tableView reloadData];
                
            }failure:^(NSInteger statusCode, NSArray *errors){
                
                [[AppContext sharedContext] displayMessages:errors];
                
            }];
        }
        
    }failure:^(NSInteger statusCode, NSArray *errors){
        
        [[AppContext sharedContext] displayMessages:errors];
        
    }];
}

- (void)updateLightingUnitsWithStatus:(NSDictionary *)status forApiKey:(NSString *)apiKey
{
    NSDictionary *bridge = [status valueForKey:kDataKeyHueConfiguration];
    NSString *ip = [bridge valueForKey:kDataKeyHueBridgeIpAddress];
    
    [[AppContext sharedContext].repository getHueLightingUnitsForApiKey:apiKey success:^(NSArray *existingLightingUnits){
        
        NSDictionary *currentLightingUnits = [status valueForKey:kDataKeyHueLights];
        
        for(NSString *key in [currentLightingUnits allKeys])
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lightId == %@", key];
            NSArray *found = [existingLightingUnits filteredArrayUsingPredicate:predicate];
            NSDictionary *current = [currentLightingUnits valueForKey:key];
            
            if(found == nil || found.count == 0)
            {
                HueLightingUnit *new = (HueLightingUnit *)[[AppContext sharedContext].repository createEntity:@"HueLightingUnit"];
                
                new.lightId = [NSNumber numberWithInteger:[key integerValue]];
                new.name = [current valueForKey:kDataKeyHueLightName];
                new.apiKey = apiKey;
                new.ip = ip;
            }
            else
            {
                HueLightingUnit *existing = [found objectAtIndex:0];
                
                existing.name = [current valueForKey:kDataKeyHueLightName];
                existing.ip = ip;
            }
        }
        
        [[AppContext sharedContext].repository save];
        
    }failure:^(NSError *error){
        
        [[AppContext sharedContext] displayMessage:[error localizedDescription]];
        
    }];
}

@end
