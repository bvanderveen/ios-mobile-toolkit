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

#import "DemoController.h"
#import "RumblefishMobileSDK/RumblefishMobileSDK.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LogoViewController.h"
#include "TargetConditionals.h"

@interface DemoController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) RFRootController *rfController;

@end

@implementation DemoController

- (void)emailLinkClicked {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?subject=%@", [@"info@rumblefish.com" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [@"Friendly Music Info" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)displayRumblefishSDK {
    _rfController = [RFRootController controller];
    [_rfController presentWithParentController:self animated:YES];
}

- (void)setupRumblefishSDKWithVideoURL:(NSURL *)videoUrl {
    // PLEASE SPECIFY A VALID public key and password. Contact developers@rumblefish.com for more info.
    [RFAPI rumbleWithEnvironment:RFAPIEnvSandbox
                       publicKey:@"sandbox"
                        password:@"sandbox"
                        videoURL:videoUrl
             didInitiatePurchase:^ (RFPurchase *purchase) {
                 LogoViewController *logoViewController = [[LogoViewController alloc] init];
                 UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:logoViewController];
                 navController.navigationBar.barStyle = UIBarStyleBlack;
                 [_rfController presentModalViewController:navController animated:YES];
                 
                 purchase.license.firstname = @"John";
                 purchase.license.lastname = @"Doe";
                 
                 purchase.didCompletePurchase = ^ {
                     NSLog(@"Puchase completed sucessfully!");
                 };
                 purchase.didFailToCompletePurchase = ^ (NSError *e) {
                     NSLog(@"Did fail to complete purchase: %@", e);
                 };
                 [purchase commitPurchase];
             }];
    
}

#if TARGET_IPHONE_SIMULATOR

- (IBAction)start {
    NSURL *videoURL = [NSURL URLWithString:@"http://vimeo.com/48931301/download?t=1371599214&v=116073593&s=1d4de25bc703d2c8eec8dbcd166d5e3c"];
    [self setupRumblefishSDKWithVideoURL:videoURL];
    [self displayRumblefishSDK];
}

#else

- (IBAction)start {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePickerController animated:YES];
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
    imagePickerController.delegate = self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL *pickedURL = info[@"UIImagePickerControllerMediaURL"];
    
    [self setupRumblefishSDKWithVideoURL:pickedURL];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self displayRumblefishSDK];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#endif

@end