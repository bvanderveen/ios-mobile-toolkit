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

#import "HomeController.h"
#import "HomeCell.h"
#import "HomeView.h"
#import "HeaderView.h"
#import "RFAPI.h"
#import "RFColor.h"
#import "RFFont.h"
#import "Sequence.h"
#import "NSObject+AssociateProducer.h"

#import "UIImage+RumblefishSDKResources.h"

#define kHeaderViewItemOffset 3

@interface HomeController () <UITableViewDataSource, UITableViewDelegate, HeaderViewDataSource>

@property (nonatomic, strong) HomeView *view;
@property (nonatomic, strong) NSArray *headerPlaylists;
@property (nonatomic, strong) NSArray *tablePlaylists;

@end


@implementation HomeController

@dynamic view;

- (void)loadView
{
    self.view = [[HomeView alloc] initWithDataSource:self];
    self.view.headerView.dataSource = self;
    
    Producer getPlaylists = [[RFAPI singleton] getHome];
    [self associateProducer:getPlaylists callback:^ (id results) {
        _headerPlaylists = (NSArray *)[results take:kHeaderViewItemOffset];
        _tablePlaylists = (NSArray *)[results skip:kHeaderViewItemOffset];
        [self.view.tableView reloadData];
        [self.view.headerView reloadData];
    }];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[HomeCell alloc] initWithReuseIdentifier:@"Cell"];
    
    Playlist *playlist = [_tablePlaylists objectAtIndex:indexPath.row];
    cell.textLabel.text = playlist.title;
    cell.detailTextLabel.text = playlist.editorial;
    cell.imageView.image = [UIImage imageInResourceBundleNamed:@"blank.jpg"];
    
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

#pragma mark HeaderViewDataSource

- (Playlist *)playlistForPageNumber:(NSInteger)pageNumber
{
    return _headerPlaylists[pageNumber];
}

- (NSInteger)numberOfPlaylists
{
    return _headerPlaylists.count;
}

@end