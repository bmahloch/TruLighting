//
//  AddDMXLightViewController.m
//  TruLightingUI
//
//  Created by bmahloch on 1/11/13.
//  Copyright (c) 2013 bmahloch. All rights reserved.
//

#import "AddDMXLightViewController.h"
#import "DMXLightingUnit.h"
#import "AppRepository.h"

@interface AddDMXLightViewController ()

@end

@implementation AddDMXLightViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setTxtHost:nil];
    [self setTxtUniverse:nil];
    [self setTxtChannel:nil];
    [self setTxtName:nil];
    [self setSegType:nil];
    [super viewDidUnload];
}

- (IBAction)done:(id)sender
{
    DMXLightingUnit *dmx = [[AppContext sharedContext].repository createEntity:ENTITY_DMX_LIGHTING_UNIT];
    
    dmx.ip = _txtHost.text;
    dmx.channel = [NSNumber numberWithInteger:[_txtChannel.text integerValue]];
    dmx.universe = [NSNumber numberWithInteger:[_txtUniverse.text integerValue]];
    dmx.kind = [NSNumber numberWithInteger:_segType.selectedSegmentIndex];
    dmx.name = _txtName.text;
    
    [[AppContext sharedContext].repository save:^(){
    
        [self dismissModalViewControllerAnimated:YES];
        
    }failure:^(NSError *error){
       
        [[AppContext sharedContext] displayMessage:[error localizedDescription]];
        
    }];
}

@end
