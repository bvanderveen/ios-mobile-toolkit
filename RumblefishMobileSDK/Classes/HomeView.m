//
//  HomeView.m
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/18/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Create header view
        _headerView = [[HeaderView alloc] init];
        [self addSubview:_headerView];
        
        //Create TableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = [UIColor blackColor];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [_headerView sizeToFit];
#warning Do i need this?
    CGRect headerFrame = CGRectMake(0, 0, self.frame.size.width, 158);
    _headerView.frame = headerFrame;
    
    CGRect tableViewFrame = CGRectMake(0, headerFrame.origin.y + headerFrame.size.height, self.frame.size.width, self.frame.size.height - headerFrame.size.height);
    _tableView.frame = tableViewFrame;
}

@end