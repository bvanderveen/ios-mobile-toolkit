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


#import "RFHomeView.h"

@interface RFHomeView ()

@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL viewDoneLoading;

@end
@implementation RFHomeView

- (id)initWithViewController:(id)viewController
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        //Create header view
        _headerView = [[RFHomeHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.dataSource = viewController;
        _headerView.delegate = viewController;
        [self addSubview:_headerView];
        
        //Create TableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = [UIColor blackColor];
        _tableView.delegate = viewController;
        _tableView.dataSource = viewController;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0); //fixes tab bar overlap on last tableview cell
        [self addSubview:_tableView];
        
        //Loading Views
        _viewDoneLoading = NO;
        _loadingView = [[UIView alloc] init];
        _loadingView.backgroundColor = [UIColor blackColor];
        [self addSubview:_loadingView];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicator startAnimating];
        [_loadingView addSubview:_activityIndicator];
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect headerFrame = CGRectMake(0, 0, self.frame.size.width, 158+44);
    _headerView.frame = headerFrame;
    
    CGRect tableViewFrame = CGRectMake(0, headerFrame.origin.y + headerFrame.size.height, self.frame.size.width, self.frame.size.height - headerFrame.size.height);
    _tableView.frame = tableViewFrame;
    
    if (!_viewDoneLoading) {
        _loadingView.frame = self.bounds;
        _activityIndicator.center = _loadingView.center;
    }
}

- (void)hideLoadingView
{
    _viewDoneLoading = YES;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _loadingView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [_activityIndicator stopAnimating];
                         [_loadingView removeFromSuperview];
                     }];
}

@end