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

#import "TILightingManager.h"

@interface AddHueLightViewController ()


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
            return [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_BRIDGE forIndexPath:indexPath];
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
    
}

#pragma mark - HueAddBridgeCellDelegate Implementation

- (void)cellAddBridgeTouched:(HueAddBridgeCell *)cell
{
    NSString *apiKey = nil;
    NSString *ipAddress = cell.txtBridgeAddress.text;

    [TILightingManager connectToHueHost:ipAddress apiKey:&apiKey completionBlock:^(bool success, NSMutableArray *messages) {
    
        if(success)
        {
            [TILightingManager getStatusOfHueHost:ipAddress apiKey:apiKey success:^(NSDictionary *status){
                
                NSMutableDictionary *configuration = [status valueForKey:kDataKeyHueConfiguration];
                
                [configuration setValue:apiKey forKey:kDataKeyHueApiKey];
                [[AppContext sharedContext].repository saveHueConfiguration:configuration];
                
                _lightsDataSource = [status valueForKey:kDataKeyHueLights];
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }failure:^(NSMutableArray *errors){
                
                [[AppContext sharedContext] displayMessages:errors];
                
            }];
        }
        else
            [[AppContext sharedContext] displayMessages:messages];
        
    }];
}

@end
