//
//  HomeView.m
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/18/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

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