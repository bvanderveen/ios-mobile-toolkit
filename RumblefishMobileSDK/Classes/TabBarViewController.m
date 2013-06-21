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

#import "TabBarViewController.h"
#import "MoodMapVC.h"
#import "OccasionVC.h"
#import "CoverFlowVC.h"
#import "PlaylistVC.h"
#import "HomeController.h"
#import "UIImage+RumblefishSDKResources.h"

typedef enum RFTabView {
    RFTabViewHome = 0,
    RFTabViewMood,
    RFTabViewOccasion,
    RFTabViewHot,
    RFTabViewSaved
} RFTabView;

@interface TabBarViewController ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation TabBarViewController

- (void)loadView
{
    //Set up the content view
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor lightGrayColor];
	self.view = contentView;
    
    //Create an empty tab controller and set it to fill the screen minus the top title bar
    _tabBarController = [[UITabBarController alloc] init];
	_tabBarController.view.frame = self.view.bounds;
    

    //Set VCs
    [_tabBarController setViewControllers:@[
                                            [self cancelableNavControllerWithTabView:RFTabViewHome],
                                            [self cancelableNavControllerWithTabView:RFTabViewMood],
                                            [self cancelableNavControllerWithTabView:RFTabViewOccasion],
                                            [self cancelableNavControllerWithTabView:RFTabViewHot],
                                            [self cancelableNavControllerWithTabView:RFTabViewSaved]
                                            ]];
    [self.view addSubview:_tabBarController.view];
}

- (UINavigationController *)cancelableNavControllerWithTabView:(RFTabView)tabView
{
    UIViewController *viewController;
    NSString *title;
    switch (tabView) {
        case RFTabViewHome:
            viewController = [[HomeController alloc] init];
            title = @"Home";
            break;
        case RFTabViewMood:
            viewController = [[MoodMapVC alloc] init];
            title = @"Mood";
            break;
        case RFTabViewOccasion:
            viewController = [[OccasionVC alloc] init];
            title = @"Occasion";
            break;
        case RFTabViewHot:
            viewController = [[CoverFlowVC alloc] init];
            title = @"Hot";
            break;
        case RFTabViewSaved:
            viewController = [[PlaylistVC alloc] init];
            title = @"Saved";
        default:
            break;
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(cancelModalView)];
    viewController.navigationItem.leftBarButtonItem = cancelButton;
    navController.tabBarItem.title = title;
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"friendlymusic_logo.png"]];
    viewController.navigationItem.titleView = titleView;
    
    return navController;
}

- (void)cancelModalView
{
    NSLog(@"Cancel");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
