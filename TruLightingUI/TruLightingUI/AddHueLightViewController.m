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

#import "TILightingManager.h"

@interface AddHueLightViewController ()

- (void)loadConfigurationForBridge:(NSDictionary *)bridge;

@end

@implementation AddHueLightViewController
{
    NSMutableArray *_bridgesDataSource;
    NSMutableArray *_lightsDataSource;
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
    
    _bridgesDataSource = [[AppContext sharedContext].repository getHueConfiguration];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return _bridgesDataSource.count + 1;
    
    return _lightsDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == _bridgesDataSource.count)
        {
            HueAddBridgeCell *cell = (HueAddBridgeCell*)[tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ADD_BRIDGE forIndexPath:indexPath];
            
            cell.delegate = self;
            
            return cell;
        }
        else
        {
            NSDictionary *bridge = [_bridgesDataSource objectAtIndex:indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BRIDGE forIndexPath:indexPath];
            
            cell.textLabel.text = [bridge valueForKey:kDataKeyHueBridgeName];
            cell.detailTextLabel.text = [bridge valueForKey:kDataKeyHueBridgeIpAddress];
            
            return cell;
        }
    }

    return [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BRIDGE forIndexPath:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableViewDelegate Implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSDictionary *bridge = [_bridgesDataSource objectAtIndex:indexPath.row];
        [self loadConfigurationForBridge:bridge];
    }
}

#pragma mark - HueAddBridgeCellDelegate Implementation

- (void)cellAddBridgeTouched:(HueAddBridgeCell *)cell
{
    NSString *ipAddress = cell.txtBridgeAddress.text;

    if([HueConfiguration bridgeExists:_bridgesDataSource byHost:ipAddress])
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
                [_bridgesDataSource addObject:configuration];
                [[AppContext sharedContext].repository saveHueConfiguration:_bridgesDataSource];
                
                _lightsDataSource = [status valueForKey:kDataKeyHueLights];
                
                [self.tableView reloadData];
                
            }failure:^(NSInteger statusCode, NSArray *errors){
                
                [[AppContext sharedContext] displayMessages:errors];
                
            }];
        }
        
    }failure:^(NSInteger statusCode, NSArray *errors){
        
        [[AppContext sharedContext] displayMessages:errors];
        
    }];
}

- (void)loadConfigurationForBridge:(NSDictionary *)bridge
{
    [TILightingManager getStatusOfHueHost:[bridge valueForKey:kDataKeyHueBridgeIpAddress] apiKey:[bridge valueForKey:kDataKeyHueApiKey] success:^(NSDictionary *status){
        
        //NSMutableDictionary *configuration = [status valueForKey:kDataKeyHueConfiguration];
        
        _lightsDataSource = [status valueForKey:kDataKeyHueLights];
        
        [self.tableView reloadData];
        
    }failure:^(NSInteger statusCode, NSArray *errors){
        
        [[AppContext sharedContext] displayMessages:errors];
        
    }];
}

@end
