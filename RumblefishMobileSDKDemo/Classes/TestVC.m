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

#import "TestVC.h"
#import "RumblefishMobileSDK/RumblefishMobileSDK.h"

@implementation TestVC

- (void)viewDidLoad {
    ((UIScrollView *)self.view.subviews[0]).contentSize = CGSizeMake(320, 480);
}

- (void)emailLinkClicked {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?subject=%@", [@"info@rumblefish.com" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [@"Friendly Music Info" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)viewWillAppear:(BOOL)animated {
    button.enabled = TRUE;
    
    // PLEASE SPECIFY A VALID public key and password. Contact developers@rumblefish.com for more info.
    // NSURL *url = [[NSBundle mainBundle] URLForResource:@"maiden_trashplane_1280x720" withExtension:@"mp4"];
    NSURL *url = [NSURL URLWithString:@"http://vimeo.com/48931301/download?t=1371599214&v=116073593&s=1d4de25bc703d2c8eec8dbcd166d5e3c"];
    [RFAPI rumbleWithEnvironment:RFAPIEnvSandbox
                       publicKey:@"sandbox"
                        password:@"sandbox"
                        videoURL:url];
}

- (IBAction)start {
    
    TabBarViewController *tabController = [[TabBarViewController alloc] init];
    [self.navigationController pushViewController:tabController animated:YES];
    [tabController release];
//    FriendlyMusic *friendlyMusic = [[FriendlyMusic alloc] init];
//    [friendlyMusic setOptions:friendlyMusic.FMMOODMAP | friendlyMusic.FMOCCASION | friendlyMusic.FMEDITORSPICKS];
//    [self.navigationController pushViewController:friendlyMusic animated:YES];
//    [friendlyMusic release];
}

@end