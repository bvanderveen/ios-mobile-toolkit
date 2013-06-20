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


#import "HomeView.h"

@implementation HomeView

- (id)initWithDataSource:(id)viewController
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        //Create header view
        _headerView = [[HeaderView alloc] initWithFrame:CGRectZero];
        [self addSubview:_headerView];
        
        //Create TableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = [UIColor blackColor];
        _tableView.delegate = viewController;
        _tableView.dataSource = viewController;
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect headerFrame = CGRectMake(0, 0, self.frame.size.width, 158);
    _headerView.frame = headerFrame;
    
    CGRect tableViewFrame = CGRectMake(0, headerFrame.origin.y + headerFrame.size.height, self.frame.size.width, self.frame.size.height - headerFrame.size.height);
    _tableView.frame = tableViewFrame;
}

@end