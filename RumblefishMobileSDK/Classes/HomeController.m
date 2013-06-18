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
#import "UIImage+RumblefishSDKResources.h"

#pragma mark - HeaderView
@interface HeaderView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIView *blueLine;
@property (nonatomic, strong) UIView *blackLine;

@end

@implementation HeaderView

-(id)initWithItems:(NSArray *)items
{
    if (self = [super initWithFrame:CGRectZero])
    {
        //add lines to the bottom
        _blueLine = [[UIView alloc] init];
        _blueLine.backgroundColor = [UIColor blueColor];
        [self addSubview:_blueLine];
        
        _blackLine = [[UIView alloc] init];
        _blackLine.backgroundColor = [UIColor blackColor];
        [self addSubview:_blackLine];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor purpleColor];
        [self addSubview:_scrollView];
        
        self.backgroundColor = [UIColor greenColor];
        _items = items;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, size.width / 4 * 3);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //add lines to the bottom
    _blueLine.frame = CGRectMake(0, self.bounds.size.height - 2, self.bounds.size.width, 1);
    _blackLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);

    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 2);
    
    [self populateScrollView];
}

- (void)populateScrollView
{
    //Create a "page" for each item
    for (int i = 0; i < _items.count; i++) {
        
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        //Create image views for each cell
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        UIColor *backgroundColor;
        if (i == 0)
            backgroundColor = [UIColor brownColor];
        else if (i == 1)
            backgroundColor = [UIColor blueColor];
        else
            backgroundColor = [UIColor orangeColor];
        
        subview.backgroundColor = backgroundColor;
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _items.count,
                                             self.scrollView.frame.size.height);
}

@end


#pragma mark - HomeController

@interface HomeController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HomeController

- (void)viewDidLoad
{
#warning switch to loadView
    [super viewDidLoad];
    
#warning DEV
    NSArray *featuredItems = @[
                       @{@"Title": @"Skating",
                         @"Subtitle": @"Shredding 101",
                         @"ThumbnailURL": @"URLHERE"
                         },
                       @{@"Title": @"Party",
                         @"Subtitle": @"Radical",
                         @"ThumbnailURL": @"URLHERE"
                         },
                       @{@"Title": @"Sports",
                         @"Subtitle": @"Super Sports",
                         @"ThumbnailURL": @"URLHERE"
                         }
                       ];
    
    //Create header view
    HeaderView *headerView = [[HeaderView alloc] initWithItems:featuredItems];
    [headerView sizeToFit];
    CGRect headerFrame = CGRectMake(0, 0, self.view.frame.size.width, 158);
    headerView.frame = headerFrame;
    [self.view addSubview:headerView];
    
    //Create TableView
    CGRect tableViewFrame = CGRectMake(0, headerFrame.origin.y + headerFrame.size.height, self.view.frame.size.width, self.view.frame.size.height - headerFrame.size.height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.alpha = 0.5;
    [self.view addSubview:tableView];
}


#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
        cell = [[HomeCell alloc] initWithReuseIdentifier:@"Cell"];
    
    cell.textLabel.text = @"Skateboarding";
    cell.detailTextLabel.text = @"Shreading 101";
    cell.imageView.image = [UIImage imageInResourceBundleNamed:@"blank.jpg"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    cell.backgroundColor = [UIColor darkGrayColor];
}

@end
