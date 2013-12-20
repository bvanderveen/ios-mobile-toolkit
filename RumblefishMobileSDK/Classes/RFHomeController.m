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

#import "RFHomeController.h"
#import "RFHomeCell.h"
#import "RFHomeView.h"
#import "RFHomeHeaderView.h"
#import "RFAPI.h"
#import "RFColor.h"
#import "RFFont.h"
#import "Sequence.h"
#import "NSObject+AssociateProducer.h"
#import "RFAlbumController.h"

#define kHeaderViewItemOffset 3

@interface RFHomeController () <UITableViewDataSource, UITableViewDelegate, RFHomeHeaderViewDataSource>

@property (nonatomic, strong) RFHomeView *view;
@property (nonatomic, strong) NSArray *headerPlaylists;
@property (nonatomic, strong) NSArray *tablePlaylists;

@end


@implementation RFHomeController

@dynamic view;

- (void)loadView
{
    self.view = [[RFHomeView alloc] initWithViewController:self];
    self.view.headerView.dataSource = self;
    self.view.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    Producer getPlaylists = [[RFAPI singleton] getHome];
    [self associateProducer:getPlaylists callback:^ (id results) {
        _headerPlaylists = (NSArray *)[results take:kHeaderViewItemOffset];
        _tablePlaylists = (NSArray *)[results skip:kHeaderViewItemOffset];
        [self.view.tableView reloadData];
        [self.view.headerView reloadData];
        [self.view hideLoadingView];
    }];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[RFHomeCell alloc] initWithReuseIdentifier:@"Cell"];
    
    RFPlaylist *playlist = [_tablePlaylists objectAtIndex:indexPath.row];
    cell.textLabel.text = playlist.title;
    cell.detailTextLabel.text = playlist.strippedEditorial;
    cell.imageURL = playlist.imageURL;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tablePlaylists.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [RFColor darkGray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RFPlaylist *playlist = [_tablePlaylists objectAtIndex:indexPath.row];
    
	RFAlbumController *albumController = [[RFAlbumController alloc] initWithPlaylist:playlist];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumController];
    navigationController.navigationBar.tintColor = BAR_TINT_COLOR;
    
    [albumController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navigationController animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark HeaderViewDataSource

- (RFPlaylist *)playlistForPageNumber:(NSInteger)pageNumber
{
    return _headerPlaylists[pageNumber];
}

- (NSInteger)numberOfPlaylists
{
    return _headerPlaylists.count;
}

#pragma mark HeaderViewDelegate

- (void)headerViewTappedWithIndex:(NSInteger)index
{
	RFAlbumController *albumController = [[RFAlbumController alloc] initWithPlaylist:_headerPlaylists[index]];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:albumController];
    navigationController.navigationBar.tintColor = BAR_TINT_COLOR;
    [albumController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end