//
//  LogoViewController.m
//  RumblefishMobileSDKDemo
//
//  Created by Benjamin van der Veen on 8/1/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import "LogoViewController.h"

@interface LogoViewController ()

@end

@implementation LogoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    self.view.backgroundColor = [UIColor blueColor];
	// Do any additional setup after loading the view.
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
