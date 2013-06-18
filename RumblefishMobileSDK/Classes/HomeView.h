//
//  HomeView.h
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/18/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface HomeView : UIView

@property (nonatomic, strong) HeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;

@end
