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

#import "RFAlbumController.h"
#import "SBJson/SBJson.h"
#import "RFLocalPlaylist.h"
#import "NSObject+AssociateProducer.h"
#import "UIImage+RumblefishSDKResources.h"
#import "RFPreviewController.h"
#import "RFSongCell.h"

@interface RFAlbumController ()

@property (nonatomic, strong) RFPlaylist *playlist;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) RFPreviewController *previewController;

@end

@implementation RFAlbumController

@synthesize playlist, activityIndicator;

- (id)initWithPlaylist:(RFPlaylist *)lePlaylist {
    if (self = [super init]) {
        self.playlist = lePlaylist;
        self.title = playlist.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    
    self.tableView.rowHeight = 60;
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.125f green:0.125f blue:0.125f alpha:1.0f];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; //removes ugly separators for blank cells
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator sizeToFit];
    activityIndicator.frame = CGRectMake(
                                         (self.tableView.frame.size.width - activityIndicator.frame.size.width) / 2,
                                         (self.tableView.frame.size.height - activityIndicator.frame.size.height) / 2,
                                         activityIndicator.frame.size.width,
                                         activityIndicator.frame.size.height);
    [self.view addSubview:activityIndicator];
    
    [self getPlaylistFromServer:NO];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    // force cells to re-layout
//    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playlist.media.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFMedia *currentMedia = [playlist.media objectAtIndex:indexPath.row];
    
    if (indexPath.row < 2)
        currentMedia.price = @"FREE";
    
    RFSongCell *cell = [RFSongCell cellForMedia:currentMedia tableView:tableView buttonAction:^{
        if ([[RFLocalPlaylist sharedPlaylist] existsInPlaylist:currentMedia])
            [[RFLocalPlaylist sharedPlaylist] removeFromPlaylist:currentMedia];
        else
            [[RFLocalPlaylist sharedPlaylist] addToPlaylist:currentMedia];
        
        [tableView reloadData];
    }];
    
    cell.songIsSaved = [[RFLocalPlaylist sharedPlaylist] existsInPlaylist:currentMedia];
    
    return cell;
}

- (void)getPlaylistFromServer:(BOOL)play {
    Producer getPlaylist = [[RFAPI singleton] getPlaylist:playlist.ID];
    [activityIndicator startAnimating];
    
    [self associateProducer:getPlaylist callback:^ (id result) {
        self.playlist = (RFPlaylist *)result;
        
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFMedia *currentMedia = [playlist.media objectAtIndex:indexPath.row];
    _previewController = [[RFPreviewController alloc] initWithMedia:currentMedia];
    [_previewController show];    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
