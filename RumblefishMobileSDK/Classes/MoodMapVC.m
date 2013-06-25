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

#import "MoodMapVC.h"
#import "PlaylistVC.h"
#import "SBJson/SBJson.h"
#import "NSObject+AssociateProducer.h"
#import "LocalPlaylist.h"
#import "UIImage+RumblefishSDKResources.h"
#import "NSBundle+RumblefishMobileSDKResources.h"
#import "SongCell.h"
#import "TabBarViewController.h"
#import "MoodMapSelectorView.h"
#import "RFColor.h"

@implementation MoodMapControllerView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [RFColor darkGray];
        _tableView.rowHeight = 60;
        [self addSubview:_tableView];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] init];
        [self addSubview:_activityIndicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [_activityIndicator sizeToFit];
    _activityIndicator.center = CGPointMake(_tableView.center.x, 320 + _tableView.rowHeight / 2);
}

@end

@interface MoodMapVC () <MoodMapSelectorViewDelegate>

//@property (nonatomic, strong) Playlist *playlist;
@property (nonatomic, strong) MoodMapControllerView *view;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) MoodMapSelectorView *moodmapSelectorView;
@property (nonatomic, weak) TabBarViewController *tabBarVC;

@end

@implementation MoodMapVC

UIColor *selectedColor;
int idArray[12][12] = {0,  0,  0,  1,  2,  3, 31, 32, 33,  0,  0,  0,
                       0,  0,  4,  5,  6,  7, 34, 35, 36, 37,  0,  0,
                       0,  8,  9, 10, 11, 12, 38, 39, 40, 41, 42,  0,
                      13, 14, 15, 16, 17, 18, 43, 44, 45, 46, 47, 48,
                      19, 20, 21, 22, 23, 24, 49, 50, 51, 52, 53, 54,
                      25, 26, 27, 28, 29, 30, 55, 56, 57, 58, 59, 60,
                      91, 92, 93, 94, 95, 96, 61, 62, 63, 64, 65, 66,
                      97, 98, 99,100,101,102, 67, 68, 69, 70, 71, 72,
                     103,104,105,106,107,108, 73, 74, 75, 76, 77, 78,
                       0,109,110,111,112,113, 79, 80, 81, 82, 83,  0,
                       0,  0,114,115,116,117, 84, 85, 86, 87,  0,  0,
                       0,  0,  0,118,119,120, 88, 89, 90,  0,  0,  0};

- (id)initWithTabBarVC:(TabBarViewController *)tabBarVC
{
    if (self = [super init]) {
        _tabBarVC = tabBarVC;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view = [[MoodMapControllerView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    self.view.tableView.delegate = self;
    self.view.tableView.dataSource = self;
    tabView = self.view.tableView;    
    tabView.separatorColor = [UIColor colorWithRed:0.08f green:0.08f blue:0.08f alpha:1.0f];


    /* Tableview is set up with an empty section 0 that has the MoodMapSelectionView as it's header view
        This gives us the right scrolling mechanisms we desire */
    _moodmapSelectorView = [[MoodMapSelectorView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _moodmapSelectorView.delegate = self;
    
    [_moodmapSelectorView.doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_moodmapSelectorView.filtersButton addTarget:self action:@selector(filterButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    _moodmapSelectorView.moodmapGlow.alpha = 0;
    _moodmapSelectorView.moodmapRing.alpha = 0;
    _moodmapSelectorView.selector.alpha = 0;
    
    selectedColor = [[UIColor alloc] init];
    
    // First time load
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (![userdef boolForKey:@"fmisused"]) {
        _moodmapSelectorView.startMessage.hidden = NO;
        [userdef setBool:YES forKey:@"fmisused"];
    }
    else {
        _moodmapSelectorView.startMessage.hidden = YES;
    }
    
}

- (void)viewDidUnload
{
    self.view = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    selectedColor = nil;
}

- (void)updateStatusBarForOrientation:(UIInterfaceOrientation)orientation {
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    
    [[UIApplication sharedApplication] setStatusBarHidden:isLandscape withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
    [self updateStatusBarForOrientation:self.interfaceOrientation];
    [tabView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [tabView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
    
    [self updateStatusBarForOrientation:toInterfaceOrientation];
}

- (IBAction)doneButtonPressed {
    [_tabBarVC cancelModalView];
}

- (IBAction)filterButtonPressed {
    //// currently unavailable  ////
    UIImageView *filters_image = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"filters_coming_soon.png"]];
    filters_image.frame = CGRectMake(62.5, 200, 195, 56);
    filters_image.alpha = 0;
    [self.view addSubview:filters_image];
    [UIView animateWithDuration:1.5 animations:^{
        filters_image.alpha = 1.0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            filters_image.alpha = 0;
        }completion:^(BOOL finished) {
            [filters_image removeFromSuperview];
        }];
    }];
    return;
}

#pragma mark - TableView methods



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 320 : 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? _moodmapSelectorView : nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0)? 0 : playlist.media.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Media *currentMedia = (Media *)[playlist.media objectAtIndex:indexPath.row];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// Alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self getPlaylistFromServer];
    }
}

// server API
- (void)getPlaylistFromServer {
    Producer getMedia = [[RFAPI singleton] getPlaylist:playlistID + 187];
    
    playlist = nil;
    [tabView reloadData];
    
    [self.view.activityIndicator startAnimating];
    [self associateProducer:getMedia callback:^ (id result) {
        playlist = (Playlist *)result;
        [self.view.activityIndicator stopAnimating];
        _moodmapSelectorView.doneButton.enabled = YES;
        [tabView reloadData];
    }];

}

#pragma mark - MoodMapSelectorViewDelegate

- (void)stopScrolling
{
    tabView.scrollEnabled = NO;
}

- (void)startScrolling
{
    tabView.scrollEnabled = YES;
}

- (void)updateSelectedColorWithColor:(UIColor *)color
{
    _selectedColor = color;
}

- (void)updatePlaylistIdWithX:(int)x andY:(int)y
{
    playlistID = idArray[y][x];
    [self getPlaylistFromServer];
}

@end
