/*
 Rumblefish Mobile Toolkit for iOS
 
 Copyright 2012 Rumblefish, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License"); you may
 not use this file except in compliance with the License. You may obtain
 a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 License for the specific language governing permissions and limitations
 under the License.
 
 Use of the Rumblefish Sandbox in connection with this file is governed by
 the Sandbox Terms of Use found at https://sandbox.rumblefish.com/agreement
 
 Use of the Rumblefish API for any commercial purpose in connection with
 this file requires a written agreement with Rumblefish, Inc.
 */

#import "RFPlaylistController.h"
#import "SBJson/SBJson.h"
#import "RFLocalPlaylist.h"
#import "RFSongCell.h"
#import "RFPreviewController.h"

@interface RFPlaylistController ()

@property (nonatomic, strong) RFPreviewController *previewController;

@end

@implementation RFPlaylistController

- (void)viewDidLoad
{
    self.navigationItem.title = @"Playlist";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove all" style:UIBarButtonItemStyleBordered target:self action:@selector(removeAll)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:.88 green:0 blue:0 alpha:1];
    
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.1568f green:0.1529f blue:0.1451f alpha:1.0f];
    self.tableView.rowHeight = 60;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // force cells to re-layout
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}

- (void)removeAll {
    [[RFLocalPlaylist sharedPlaylist] clear];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [RFLocalPlaylist sharedPlaylist].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFMedia *media = [[RFLocalPlaylist sharedPlaylist] mediaAtIndex:indexPath.row];
    
    RFSongCell *cell = [RFSongCell removeButtonCellForMedia:media tableView:tableView buttonAction:^{
        [[RFLocalPlaylist sharedPlaylist] removeFromPlaylist:media];
        [tableView reloadData];
    }];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFMedia *currentMedia = [[RFLocalPlaylist sharedPlaylist] mediaAtIndex:indexPath.row];
    _previewController = [[RFPreviewController alloc] initWithMedia:currentMedia];
    [_previewController show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
