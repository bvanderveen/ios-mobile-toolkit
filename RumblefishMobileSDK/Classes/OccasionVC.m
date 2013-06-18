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

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "OccasionVC.h"
#import "SBJson/SBJson.h"
#import "PlaylistVC.h"
#import "NSObject+AssociateProducer.h"
#import "Sequence.h"
#import "LocalPlaylist.h"
#import "NSBundle+RumblefishMobileSDKResources.h"
#import "UIImage+RumblefishSDKResources.h"
#import "SongCell.h"

@class OccasionControllerView;

@interface NSObject (OccasionControllerViewDelegate)

- (UIInterfaceOrientation)occasionControllerViewCurrentOrientation:(OccasionControllerView *)controllerView;
- (void)occasionControllerView:(OccasionControllerView *)controllerView tappedHomeButtonAtIndex:(NSUInteger)index;

@end

@interface OccasionControllerView : UIView

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL buttonsHidden;
@property (nonatomic, strong) NSArray *rootButtons;

@end

@implementation OccasionControllerView

@synthesize delegate, buttonsHidden = _buttonsHidden, rootButtons;

#define imageWidth 116
#define imageHeight 115
#define imageMargin 6

- (void)awakeFromNib {
    self.rootButtons = [@[ @"mood.png", @"celebration.png", @"themes.png", @"currentevents.png", @"sports.png", @"holiday.png" ] map:^ id (id imageName) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageInResourceBundleNamed:imageName] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        return button;
    }];
}

- (void)makeRootButtonsVisible {
    [rootButtons each:^(id x) {
        UIView *b = (UIView *)x;
        b.layer.rasterizationScale = 1.0;
        b.alpha = 1.0;
    }];
}

- (void)makeRootButtonsInvisible {
    [rootButtons each:^(id x) {
        UIView *b = (UIView *)x;
        b.layer.rasterizationScale = 1.0;
        b.layer.shouldRasterize = YES;
        b.alpha = 0;
    }];
}

- (void)layoutButtonsVisible {
    CGFloat itemWidth = imageWidth + imageMargin * 2;
    CGFloat itemsFittingH = MIN(3, floorf(self.bounds.size.width / itemWidth));
    
    CGFloat itemHeight = imageHeight + imageMargin * 2;
    CGFloat itemsFittingV = MIN(3, floorf(self.bounds.size.height / itemHeight));
    
    itemWidth = self.bounds.size.width / itemsFittingH;
    CGFloat calculatedXmargin = (self.bounds.size.width - (imageWidth * itemsFittingH)) / (itemsFittingH * 2 + 2);
    
    itemHeight = self.bounds.size.height / itemsFittingV;
    CGFloat calculatedYmargin = (self.bounds.size.height - (imageHeight * itemsFittingV)) / (itemsFittingV * 2 + 2);
    
    CGFloat xInit = calculatedXmargin;
    CGFloat yInit = calculatedYmargin;
    CGFloat xInterval = imageWidth + calculatedXmargin * 2;
    CGFloat yInterval = imageHeight + calculatedYmargin * 2;
    
    //NSLog(@"xInit = %f, yInit = %f, xInterval = %f, yInterval = %f", xInit, yInit, xInterval, yInterval);
    
    __block CGFloat x = xInit, y = yInit;
    [rootButtons each:^(id i) {
        if (x + xInterval > self.bounds.size.width) {
            x = xInit;
            y += yInterval;
        }
        UIView *b = (UIView *)i;
        b.frame = CGRectMake(x + calculatedXmargin, y + imageMargin, imageWidth, imageHeight);
        x += xInterval;
    }];
}

- (void)layoutButtonsInvisible {
    [self layoutButtonsVisible];
    
    if (UIInterfaceOrientationIsPortrait([delegate occasionControllerViewCurrentOrientation:self])) {
        for (int i = 0; i < rootButtons.count; i++) {
            UIView *b = (UIView *)rootButtons[i];
            
            CGFloat y = b.frame.origin.y;
            if (i < 2)
                y = -imageHeight;
            if (i > 3)
                y = self.bounds.size.height;
            
            BOOL left = (i % 2) == 0;
            b.frame = CGRectMake(left ? -imageWidth : self.bounds.size.width, y, imageWidth, imageHeight);
        }
    }
    else {
        for (int i = 0; i < rootButtons.count; i ++) {
            UIView *b = (UIView *)rootButtons[i];
            
            CGFloat x = b.frame.origin.x;
            
            if (i == 0 || i == 3)
                x = -imageWidth;
            if (i == 2 || i == 5)
                x = self.bounds.size.width;
            
            BOOL top = (i < 3);
            b.frame = CGRectMake(x, top ? -imageHeight : self.bounds.size.height, imageWidth, imageHeight);
        }
    }
}

- (void)setDisplaysHomeButtons:(BOOL)value animated:(BOOL)animated {
    if (value) {
        if (animated) {
            [UIView animateWithDuration:0.5f animations:^{
                [self layoutButtonsVisible];
                [self makeRootButtonsVisible];
            }];
        }
        else {
            [self layoutButtonsVisible];
            [self makeRootButtonsVisible];
        }
    }
    else {
        if (animated) {
            [UIView animateWithDuration:0.5f animations:^{
                [self layoutButtonsInvisible];
                [self makeRootButtonsInvisible];
            }];
        }
        else {
            [self layoutButtonsInvisible];
            [self makeRootButtonsInvisible];            
        }
    }
    _buttonsHidden = value;
}

- (void)layoutSubviews {
    if (_buttonsHidden) {
        [self layoutButtonsVisible];
    }
    else {
        [self layoutButtonsInvisible];
    }
    [super layoutSubviews];
}

- (void)buttonTapped:(UIButton *)button {
    [self.delegate occasionControllerView:self tappedHomeButtonAtIndex:[self.rootButtons indexOfObject:button]];
}

@end

@interface OccasionVC ()

@property (nonatomic, copy) NSArray *occasions;
@property (nonatomic, strong) NSMutableArray *occasionStack;
@property (nonatomic, strong) Occasion *displayedOccasion;
@property (nonatomic, copy) NSArray *displayedPlaylists;
@property (nonatomic, copy) NSArray *occasionImages;
@property (nonatomic, strong) OccasionControllerView *controllerView;

@end

@implementation OccasionVC

@synthesize displayedOccasion, displayedPlaylists, occasions, occasionStack, occasionImages, controllerView;

NSMutableArray *secondButtons, *thirdButtons;
int level;
PlaylistVC *playlist;
CGRect thirdRect, secondRect;

NSTimer *rotateImagesTimer;


#pragma mark - View lifecycle

- (id)init {
    if (self = [super initWithNibName:@"OccasionVC" bundle:[NSBundle rumblefishResourcesBundle]]) {
        self.occasionStack = [NSMutableArray array];
    }
    return self;
}

- (OccasionControllerView *)controllerView {
    return (OccasionControllerView *)self.view;
}

- (void)viewDidLoad
{
    self.controllerView.delegate = self;
    [self.controllerView setDisplaysHomeButtons:NO animated:NO];
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    level = 1;
    table.alpha = 0;
    
    table.separatorColor = [UIColor colorWithRed:0.08f green:0.08f blue:0.08f alpha:1.0f];
    table.rowHeight = 60;
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"friendlymusic_logo.png"]];
    self.navigationItem.titleView = titleView;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Playlist" style: UIBarButtonItemStyleBordered target:self action:@selector(gotoPlaylist)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    firstButton.frame = CGRectMake(0, 0, scroller.bounds.size.width, 35);
    firstButton.alpha = 0;
    firstButton.titleLabel.font = [UIFont systemFontOfSize:32];
    [firstButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [firstButton addTarget:self action:@selector(animateToHomeScreen) forControlEvents:UIControlEventTouchUpInside];
    [firstButton setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [[firstButton layer] setMasksToBounds:YES];
    [[firstButton layer] setBorderWidth:0.5];
    [[firstButton layer] setBorderColor:[[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f] CGColor]];
    [self.view addSubview:firstButton];
    
    secondButtons = [[NSMutableArray alloc] init];
    thirdButtons = [[NSMutableArray alloc] init];
    
    bigSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                  UIActivityIndicatorViewStyleWhiteLarge];
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    bigSpinner.center = topWindow.center;
    [topWindow addSubview:bigSpinner];
    
    [self loadOccasionImages];
    
    for (int i = 0; i < occasionImages.count; i++)
        [self updateBackgroundImageForButtonAtIndex:i];
        
    rotateImagesTimer = [NSTimer scheduledTimerWithTimeInterval:OCCASION_IMAGE_SWITCH_DELAY target:self selector:@selector(updateBackgroundImageForRandomButton) userInfo:nil repeats:YES];
    
    [self.controllerView setDisplaysHomeButtons:NO animated:NO];
    
    [self getOccasionsFromServer];
    
    // Registers this class as the delegate of the audio session.
    [[AVAudioSession sharedInstance] setDelegate:self];    
    // Allow the app sound to continue to play when the screen is locked.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)viewDidUnload
{
    for (UIButton *b in secondButtons) {
        [b removeFromSuperview];
    }
    for (UIButton *b in thirdButtons) {
        [b removeFromSuperview];
    }
    [thirdButtons removeAllObjects];
    [secondButtons removeAllObjects];
    thirdFontColor = nil;
    thirdLevelColor = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [table reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [rotateImagesTimer invalidate];

    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // force cells to re-layout
    
    [table performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}

- (void)loadOccasionImages {
    NSBundle *bundle = [NSBundle rumblefishResourcesBundle];
    NSString *plistPath = [bundle pathForResource:@"occasion_image_cache" ofType:@"plist"];
    self.occasionImages = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)pushOccasionNamed:(NSString *)name {
    Occasion *occasion = [[occasions filter:^ BOOL (id o) { return [((Occasion *)o).name isEqual:name]; }] objectAtIndex:0];
    [occasionStack addObject:occasion];
    
    NSArray *children = occasion.children;
    
    for (int i=0; i < children.count; i++) {
        Occasion *child = [occasion.children objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(0, scroller.frame.size.height + i*129, self.view.bounds.size.width, 129);
        button.alpha = 0;
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        button.backgroundColor = secondLevelColor;
        button.titleLabel.font = [UIFont systemFontOfSize:100];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        [button setTitleColor:secondFontColor forState:UIControlStateNormal];
        [button setTitle:[child.name lowercaseString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showThirdLevel:) forControlEvents:UIControlEventTouchUpInside];
        [[button layer] setMasksToBounds:YES];
        [[button layer] setBorderWidth:0.5];
        [[button layer] setBorderColor:[[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f] CGColor]];
        [scroller addSubview:button];
        [secondButtons addObject:button];
    }
    scroller.contentSize = CGSizeMake(self.view.bounds.size.width, children.count * 129);
}

- (void)pushOccasion:(Occasion *)occasion {
    [occasionStack addObject:occasion];
    
    for (int i=0; i< occasion.children.count; i++) {
        Occasion *child = [occasion.children objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(0, 70 + scroller.bounds.size.height + i * 56, scroller.bounds.size.width, 56);
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        button.backgroundColor = thirdLevelColor;
        button.titleLabel.font = [UIFont systemFontOfSize:50];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
        button.alpha = 0;
        [button setTitleColor:thirdFontColor forState:UIControlStateNormal];
        [button setTitle:[child.name lowercaseString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loadPlaylist:) forControlEvents:UIControlEventTouchUpInside];
        [[button layer] setMasksToBounds:YES];
        [[button layer] setBorderWidth:0.5];
        [[button layer] setBorderColor:[[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f] CGColor]];
        [scroller addSubview:button];
        [thirdButtons addObject:button];
    }
    scroller.contentSize = CGSizeMake(scroller.bounds.size.width, 70 + occasion.children.count * 56);

}

- (void)popOccasion {
    [self.occasionStack removeLastObject];
}

- (UIInterfaceOrientation)occasionControllerViewCurrentOrientation:(OccasionControllerView *)controllerView {
    return self.interfaceOrientation;
}

- (void)occasionControllerView:(OccasionControllerView *)controllerView tappedHomeButtonAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            firstLevelColor = [UIColor colorWithRed:0.55f green:0.32f blue:0.68f alpha:1.0f];
            secondLevelColor = [UIColor colorWithRed:0.51f green:0.4f blue:0.58f alpha:1.0f];
            thirdLevelColor = [[UIColor alloc] initWithRed:0.506f green:0.45f blue:0.53f alpha:1.0f];
            secondFontColor = [UIColor colorWithRed:0.26f green:0.219f blue:0.278f alpha:1.0f];
            thirdFontColor = [[UIColor alloc] initWithRed:0.26f green:0.223f blue:0.282f alpha:1.0f];
            [firstButton setTitle:@"mood" forState:UIControlStateNormal];
            [self pushOccasionNamed:@"Moods"];
            break;
            
        case 1:
            firstLevelColor = [UIColor colorWithRed:0.33f green:0.537f blue:0.156f alpha:1.0f];
            secondLevelColor = [UIColor colorWithRed:0.455f green:0.6f blue:0.33f alpha:1.0f];
            thirdLevelColor = [[UIColor alloc] initWithRed:0.474f green:0.537f blue:0.42f alpha:1.0f];
            secondFontColor = [UIColor colorWithRed:0.235f green:0.337f blue:0.152f alpha:1.0f];
            thirdFontColor = [[UIColor alloc] initWithRed:0.231f green:0.278f blue:0.192f alpha:1.0f];
            [firstButton setTitle:@"celebration" forState:UIControlStateNormal];
            [self pushOccasionNamed:@"Celebrations"];
            break;
            
        case 2:
            firstLevelColor = [UIColor colorWithRed:0.66f green:0.576f blue:0.157f alpha:1.0f];
            secondLevelColor = [UIColor colorWithRed:0.71f green:0.64f blue:0.317f alpha:1.0f];
            thirdLevelColor = [[UIColor alloc] initWithRed:0.74f green:0.686f blue:0.435f alpha:1.0f];
            secondFontColor = [UIColor colorWithRed:0.455f green:0.4f blue:0.157f alpha:1.0f];
            thirdFontColor = [[UIColor alloc] initWithRed:0.443f green:0.4f blue:0.21f alpha:1.0f];
            [firstButton setTitle:@"themes" forState:UIControlStateNormal];
            [self pushOccasionNamed:@"Themes"];
            break;
            
        case 3:
            firstLevelColor = [UIColor colorWithRed:0.243f green:0.654f blue:0.63f alpha:1.0f];
            secondLevelColor = [UIColor colorWithRed:0.455f green:0.73f blue:0.713f alpha:1.0f];
            thirdLevelColor = [[UIColor alloc] initWithRed:0.6f green:0.713f blue:0.706f alpha:1.0f];
            secondFontColor = [UIColor colorWithRed:0.28f green:0.46f blue:0.455f alpha:1.0f];
            thirdFontColor = [[UIColor alloc] initWithRed:0.35f green:0.44f blue:0.435f alpha:1.0f];
            [firstButton setTitle:@"current events" forState:UIControlStateNormal];
            [self pushOccasionNamed:@"Current Events"];
            break;
            
        case 4:
            firstLevelColor = [UIColor colorWithRed:0.192f green:0.388f blue:0.63f alpha:1.0f];
            secondLevelColor = [UIColor colorWithRed:0.31f green:0.45f blue:0.627f alpha:1.0f];
            thirdLevelColor = [[UIColor alloc] initWithRed:0.5f green:0.584f blue:0.69f alpha:1.0f];
            secondFontColor = [UIColor colorWithRed:0.168f green:0.282f blue:0.427f alpha:1.0f];
            thirdFontColor = [[UIColor alloc] initWithRed:0.274f green:0.34f blue:0.423f alpha:1.0f];
            [firstButton setTitle:@"sports" forState:UIControlStateNormal];
            [self pushOccasionNamed:@"Sports"];
            break;
            
        case 5:
            firstLevelColor = [UIColor colorWithRed:0.647f green:0.2f blue:0.2f alpha:1.0f];
            secondLevelColor = [UIColor colorWithRed:0.745f green:0.32f blue:0.32f alpha:1.0f];
            thirdLevelColor = [[UIColor alloc] initWithRed:0.75f green:0.455f blue:0.455f alpha:1.0f];
            secondFontColor = [UIColor colorWithRed:0.51f green:0.172f blue:0.172f alpha:1.0f];
            thirdFontColor = [[UIColor alloc] initWithRed:0.5f green:0.21f blue:0.21f alpha:1.0f];
            [firstButton setTitle:@"holiday" forState:UIControlStateNormal];
            [self pushOccasionNamed:@"Holidays"];
            break;
    }
            
    
    firstButton.backgroundColor = firstLevelColor;
    firstButton.titleLabel.textColor = [UIColor whiteColor];
    [self showSecondLevel];
}

- (void)animateToHomeScreen {
    while (occasionStack.count)
        [self popOccasion];
    
    [UIView animateWithDuration:0.5 animations:^ {
            firstButton.alpha = 0;
            table.alpha = 0;
            for (UIButton *b in secondButtons) {
                b.frame = CGRectMake(0, b.frame.origin.y+scroller.bounds.size.height, scroller.bounds.size.width, 129);
                b.alpha = 0;
            }
            for (UIButton *b in thirdButtons) {
                b.frame = CGRectMake(0, b.frame.origin.y+scroller.bounds.size.height, scroller.bounds.size.width, 56);
                b.alpha = 0;
            }
        }        
        completion:^(BOOL finished){
            scroller.hidden = YES;
            [self.controllerView setDisplaysHomeButtons:YES animated:YES];
            [thirdButtons removeAllObjects];
            [secondButtons removeAllObjects];
            [table reloadData];
        }];
    level = 1;
}

- (void)showSecondLevel {
    [self.controllerView setDisplaysHomeButtons:NO animated:YES];
    scroller.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        firstButton.alpha = 1.0;
        for (UIButton *b in secondButtons) {
            b.alpha = 1.0;
            b.frame = CGRectMake(0, b.frame.origin.y - scroller.frame.size.height + firstButton.frame.size.height, scroller.frame.size.width, 129);
        }
    }];
    level = 2;
}

- (void)showThirdLevel:(UIButton *)button {
    int tag = [button tag];
    
    if (level == 2) {
        Occasion *parent = [occasionStack objectAtIndex:0];
        Occasion *child = [parent.children objectAtIndex:button.tag];
        [self pushOccasion:child];
        
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        [UIView animateWithDuration:0.5 animations:^{
            //move
            secondRect = button.frame;
            button.frame = CGRectMake(0, 35, scroller.bounds.size.width, 35);
            for (UIButton *b in secondButtons) {
                if ([b tag] != tag) {
                    b.frame = CGRectMake(0, b.frame.origin.y+scroller.bounds.size.height, scroller.bounds.size.width, 129);
                    b.alpha = 0;
                }
            }
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.5 animations:^{
                for (UIButton *b in thirdButtons) {
                    b.alpha = 1.0;
                    b.frame = CGRectMake(0, b.frame.origin.y-scroller.bounds.size.height, scroller.bounds.size.width, 56);
                }
            }];
        }];
        level = 3;
    }
    else if (level == 3 || level == 4) {  //opposite direction of level 2
        [self popOccasion];
        
        [UIView animateWithDuration:0.5 animations:^{
            table.alpha = 0;
            for (UIButton *b in thirdButtons) {
                b.alpha = 0;
                b.frame = CGRectMake(0, b.frame.origin.y+scroller.bounds.size.height, scroller.bounds.size.width, 56);
            }
        }
        completion:^(BOOL finished) {
            for (UIButton *b in thirdButtons) {
                [b removeFromSuperview];
            }
            [UIView animateWithDuration:0.5 animations:^{
                //move
                button.frame = CGRectMake(0, secondRect.origin.y, scroller.bounds.size.width, 129);
                for (UIButton *b in secondButtons) {
                    if ([b tag] != tag) {
                        int index = [secondButtons indexOfObject:b];
                        b.frame = CGRectMake(0, 35 + index * 129, scroller.bounds.size.width, 129);
                        b.alpha = 1.0;
                    }
                }
                scroller.contentSize = CGSizeMake(scroller.bounds.size.width, 35 + [secondButtons count] * 129);
            }];
            button.titleLabel.font = [UIFont systemFontOfSize:100];
            [table reloadData];
            [thirdButtons removeAllObjects];
        }];
        level = 2;
    }
}

- (void)fetchPlaylistsForOccasion:(Occasion *)occasion {
    
    Producer mediaForOccasion = 
        [Async continueAfterProducer:[[RFAPI singleton] getOccasion:occasion.ID] withSelector:^ Producer (id result) {
            self.displayedOccasion = (Occasion *)result;
            
            return [[displayedOccasion.playlists map:^ id (id p) {
                return [[RFAPI singleton] getPlaylist:((Playlist *)p).ID];
            }] parallelProducer];
        }];
    
    [loadingIndicator startAnimating];
    
    [self associateProducer:mediaForOccasion callback:^ void (id result) {
        self.displayedPlaylists = (NSArray *)result;
        [table reloadData];
        table.alpha = 1.0;
        [loadingIndicator stopAnimating];
    }];
}

- (void)loadPlaylist:(UIButton *)button {
    thirdButton = button;
    int tag = [button tag];
    if (level == 3) {
        
        Occasion *parent = [occasionStack objectAtIndex:1];
        Occasion *child = [parent.children objectAtIndex:tag];
        
        [self fetchPlaylistsForOccasion:child];
        
        button.titleLabel.font = [UIFont systemFontOfSize:32];
        [UIView animateWithDuration:0.5 animations:^{
            //move
            thirdRect = button.frame;
            button.frame = CGRectMake(0, 70, scroller.bounds.size.width, 35);
            for (UIButton *b in thirdButtons) {
                if ([b tag] != tag) {
                    b.frame = CGRectMake(0, b.frame.origin.y+scroller.bounds.size.height, scroller.bounds.size.width, 56);
                    b.alpha = 0;
                }
            }
            scroller.contentSize = CGSizeMake(scroller.bounds.size.width, table.frame.size.height);
        }];
        level = 4;
    }
    else {  // opposite direction of level 3
        
        button.titleLabel.font = [UIFont systemFontOfSize:50];
        [UIView animateWithDuration:0.5 animations:^{
            table.alpha = 0;
            //move
            button.frame = CGRectMake(0, thirdRect.origin.y, scroller.bounds.size.width, 56);
            for (UIButton *b in thirdButtons) {
                if ([b tag] != tag) {
                    int index = [thirdButtons indexOfObject:b];
                    b.frame = CGRectMake(0, 70 + 56 * index, scroller.bounds.size.width, 56);
                    b.alpha = 1;
                }
            }
        }
        completion:^(BOOL finished) {
            self.displayedOccasion = nil;
            self.displayedPlaylists = nil;
            [table reloadData];
            scroller.contentSize = CGSizeMake(scroller.bounds.size.width, 70 + thirdButtons.count * 56);
        }];
        level = 3;
    }
}


- (void)addToPlaylist:(UIButton *)button {
    int row = [[table indexPathForCell:(UITableViewCell *)[[button superview] superview]] row];
    int section = [[table indexPathForCell:(UITableViewCell *)[[button superview] superview]] section];
    
    Media *currentMedia = [((Playlist *)[displayedPlaylists objectAtIndex:section]).media objectAtIndex:row];
    [[LocalPlaylist sharedPlaylist] addToPlaylist:currentMedia];
    
    button.hidden = YES;
    [[button superview] viewWithTag:8].hidden = NO;
}

- (void)removeFromPlaylist:(UIButton *)button {
    int row = [[table indexPathForCell:(UITableViewCell *)[[button superview] superview]] row];
    int section = [[table indexPathForCell:(UITableViewCell *)[[button superview] superview]] section];
    
    Media *currentMedia = [((Playlist *)[displayedPlaylists objectAtIndex:section]).media objectAtIndex:row];
    [[LocalPlaylist sharedPlaylist] removeFromPlaylist:currentMedia];
    
    button.hidden = YES;
    [[button superview] viewWithTag:5].hidden = NO;
}

- (void)gotoPlaylist {
    
    if (playlist == nil) {
        playlist = [[PlaylistVC alloc] init];
    }
    [self.navigationController pushViewController:playlist animated:YES];
}

- (void)updateBackgroundImageForButtonAtIndex:(NSUInteger)index {
    NSUInteger randomIndex = arc4random() % ((NSArray *)self.occasionImages[index]).count;
    UIButton *button = self.controllerView.rootButtons[index];
    [button setBackgroundImage:[UIImage imageWithData:self.occasionImages[index][randomIndex]] forState:UIControlStateNormal];
}

- (void)updateBackgroundImageForRandomButton {
    NSUInteger randomIndex = arc4random() % self.controllerView.rootButtons.count;
    [self updateBackgroundImageForButtonAtIndex:randomIndex];
}

- (void)getOccasionsFromServer {
    [loadingIndicator startAnimating];
    
    // we're going to filter out occasions whose names aren't among these:
    NSArray *displayedOccasionNames = [NSArray arrayWithObjects:@"Celebrations", @"Current Events", @"Holidays", @"Moods", @"Sports", @"Themes", nil];
    
    [self associateProducer:[[RFAPI singleton] getOccasions] callback:^ (id results) {
        self.occasions = [((NSArray *)results) filter:^ BOOL (id o) { 
            return [displayedOccasionNames any:^ BOOL (id n) {
                return [((Occasion *)o).name isEqual:n];
            }];
        }];
        
        [loadingIndicator stopAnimating];
        [self.controllerView setDisplaysHomeButtons:YES animated:YES];
    }];
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return displayedPlaylists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((Playlist *)[displayedPlaylists objectAtIndex:section]).media.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Playlist *playlist = [displayedPlaylists objectAtIndex:indexPath.section];
    Media *media = ((Media *)[playlist.media objectAtIndex:indexPath.row]);
    
    SongCell *cell = [SongCell cellForMedia:media tableView:tableView buttonAction:^{
        if ([[LocalPlaylist sharedPlaylist] existsInPlaylist:media])
            [[LocalPlaylist sharedPlaylist] removeFromPlaylist:media];
        else
            [[LocalPlaylist sharedPlaylist] addToPlaylist:media];
        
        [tableView reloadData];
    }];
    
    cell.songIsSaved = [[LocalPlaylist sharedPlaylist] existsInPlaylist:media];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Playlist *playlist = [displayedPlaylists objectAtIndex:section];
    
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    header.image = [UIImage imageInResourceBundleNamed:@"occasion_header_bg.png"];
    UIImageView *art = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    
    // XXX synchronous image download. gonna need to extract a view class here.
    if (playlist.image)
        art.image = playlist.image;
    [header addSubview:art];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 255, 20)];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:16];
    title.backgroundColor = [UIColor clearColor];
    title.text = playlist.title;
    [header addSubview:title];

    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(65, 25, 255, 40)];
    description.textColor = [UIColor whiteColor];
    description.font = [UIFont systemFontOfSize:16];
    description.backgroundColor = [UIColor clearColor];
    description.text = playlist.strippedEditorial;
    description.numberOfLines = 0;
    [header addSubview:description];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

@end
