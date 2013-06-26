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

#import "AlbumVC.h"
#import "SBJson/SBJson.h"
#import "LocalPlaylist.h"
#import "NSObject+AssociateProducer.h"
#import "UIImage+RumblefishSDKResources.h"
#import "PreviewController.h"
#import "SongCell.h"

@interface AlbumVC ()

@property (nonatomic, strong) Playlist *playlist;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) PreviewController *previewController;

@end

@implementation AlbumVC

@synthesize playlist, activityIndicator;

- (id)initWithPlaylist:(Playlist *)lePlaylist {
    if (self = [super init]) {
        self.playlist = lePlaylist;
        self.title = playlist.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    
    self.tableView.rowHeight = 60;
    self.tableView.separatorColor = [UIColor colorWithRed:0.08f green:0.08f blue:0.08f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.125f green:0.125f blue:0.125f alpha:1.0f];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
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
    Media *currentMedia = [playlist.media objectAtIndex:indexPath.row];
    
    SongCell *cell = [SongCell cellForMedia:currentMedia tableView:tableView buttonAction:^{
        if ([[LocalPlaylist sharedPlaylist] existsInPlaylist:currentMedia])
            [[LocalPlaylist sharedPlaylist] removeFromPlaylist:currentMedia];
        else
            [[LocalPlaylist sharedPlaylist] addToPlaylist:currentMedia];
        
        [tableView reloadData];
    }];
    
    cell.songIsSaved = [[LocalPlaylist sharedPlaylist] existsInPlaylist:currentMedia];
    
    return cell;
}

- (void)getPlaylistFromServer:(BOOL)play {
    Producer getPlaylist = [[RFAPI singleton] getPlaylist:playlist.ID];
    [activityIndicator startAnimating];
    
    [self associateProducer:getPlaylist callback:^ (id result) {
        self.playlist = (Playlist *)result;
        
        [self.tableView reloadData];
        [activityIndicator stopAnimating];
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Media *currentMedia = [playlist.media objectAtIndex:indexPath.row];
    _previewController = [[PreviewController alloc] initWithMedia:currentMedia];
    _previewController.view.frame = self.view.bounds;
    [self.view addSubview:_previewController.view];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
