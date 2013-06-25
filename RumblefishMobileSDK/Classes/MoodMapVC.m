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

#import "MoodMapVC.h"
#import "PlaylistVC.h"
#import "SBJson/SBJson.h"
#import "NSObject+AssociateProducer.h"
#import "LocalPlaylist.h"
#import "UIImage+RumblefishSDKResources.h"
#import "NSBundle+RumblefishMobileSDKResources.h"
#import "SongCell.h"
#import "TabBarViewController.h"

@implementation MoodMapControllerView

@synthesize tableView, activityIndicator;

- (void)awakeFromNib {
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self addSubview:activityIndicator];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        tableView.frame = CGRectMake(320, 0, self.bounds.size.width - 320, self.bounds.size.height);
    else
        tableView.frame = CGRectMake(0, 320, self.bounds.size.width, self.bounds.size.height - 320);
    
    [activityIndicator sizeToFit];
    activityIndicator.center = tableView.center;
}

@end

@interface MoodMapVC ()

@property (nonatomic, strong) Playlist *playlist;
@property (nonatomic, strong) MoodMapControllerView *controllerView;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, weak) TabBarViewController *tabBarVC;

@end

@implementation MoodMapVC

@synthesize playlist, controllerView;

UIColor *selectedColor;
int idArray[12][12] = {0,  0,  0,  1,  2,  3, 31, 32, 33,  0,  0,  0,
                       0,  0,  4,  5,  6,  7, 34, 35, 36, 37,  0,  0,
                       0,  8,  9, 10, 11, 12, 38, 39, 40, 41, 42,  0,
                      13, 14, 15, 16, 17, 18, 43, 44, 45, 46, 47, 48,
                      19, 20, 21, 22, 23, 24, 49, 50, 51, 52, 53, 54,
                      25, 26, 27, 28, 29, 30, 55, 56, 57, 58, 59, 60,
                      91, 92, 93, 94, 95, 96, 61, 62, 63, 64, 65, 66,
                      97, 98, 99,100,101,102, 67, 68, 69, 70, 71, 72,
                     103,104,105,106,107,108, 73, 74, 75, 76, 77, 78,
                       0,109,110,111,112,113, 79, 80, 81, 82, 83,  0,
                       0,  0,114,115,116,117, 84, 85, 86, 87,  0,  0,
                       0,  0,  0,118,119,120, 88, 89, 90,  0,  0,  0};


- (id)initWithTabBarVC:(TabBarViewController *)tabBarVC
{
    if (self = [super initWithNibName:@"MoodMapVC" bundle:[NSBundle rumblefishResourcesBundle]]) {
        _tabBarVC = tabBarVC;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.controllerView = (MoodMapControllerView *)self.view;
    [super viewDidLoad];
    
    tabView.separatorColor = [UIColor colorWithRed:0.08f green:0.08f blue:0.08f alpha:1.0f];
    glow.alpha = 0;
    ring.alpha = 0;
    selector.alpha = 0;
    
    selectedColor = [[UIColor alloc] init];
    
    // First time load
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    if (![userdef boolForKey:@"fmisused"]) {
        welcome.hidden = NO;
        [userdef setBool:YES forKey:@"fmisused"];
    }
    else {
        welcome.hidden = YES;
    }
}

- (void)viewDidUnload
{
    self.controllerView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    selectedColor = nil;
}

- (void)updateStatusBarForOrientation:(UIInterfaceOrientation)orientation {
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    
    [[UIApplication sharedApplication] setStatusBarHidden:isLandscape withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
    [self updateStatusBarForOrientation:self.interfaceOrientation];
    [tabView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [tabView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
    
    [self updateStatusBarForOrientation:toInterfaceOrientation];
}

- (IBAction)doneButtonPressed {
    [_tabBarVC cancelModalView];
}

- (IBAction)filterButtonPressed {
    //// currently unavailable  ////
    UIImageView *filters_image = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"filters_coming_soon.png"]];
    filters_image.frame = CGRectMake(62.5, 200, 195, 56);
    filters_image.alpha = 0;
    [self.view addSubview:filters_image];
    [UIView animateWithDuration:1.5 animations:^{
        filters_image.alpha = 1.0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            filters_image.alpha = 0;
        }completion:^(BOOL finished) {
            [filters_image removeFromSuperview];
        }];
    }];
    return;
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playlist.media.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Media *currentMedia = (Media *)[playlist.media objectAtIndex:indexPath.row];
    
    SongCell *cell = [SongCell cellForMedia:currentMedia tableView:tableView buttonAction:^{
        if ([[LocalPlaylist sharedPlaylist] existsInPlaylist:currentMedia])
            [[LocalPlaylist sharedPlaylist] removeFromPlaylist:currentMedia];
        else
            [[LocalPlaylist sharedPlaylist] addToPlaylist:currentMedia];
        
        [tableView reloadData];
    }];
    
    cell.songIsSaved = [[LocalPlaylist sharedPlaylist] existsInPlaylist:currentMedia];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// image methods
- (UIImage *)imageByFillingColor:(UIColor *)color inImage:(UIImage *)image
{
	UIGraphicsBeginImageContext(image.size);
	[image drawAtPoint:CGPointZero];
	CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    [color setStroke];
    [[UIColor clearColor] setStroke];
	CGRect outrect = CGRectMake(15, 14, image.size.width-30, image.size.height-28);
    CGRect inrect = CGRectMake(25, 24, image.size.width-50, image.size.height-48);
    CGContextAddEllipseInRect(context, outrect);
    CGContextAddEllipseInRect(context, inrect);
    CGContextEOFillPath(context);
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	return retImage;
}


- (void)colorOfPoint:(CGPoint)point {
/*    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(moodmap.image.CGImage));
    const UInt8 *data = CFDataGetBytePtr(pixelData);
    int pixelInfo = ((moodmap.image.size.width * point.y) + point.x) * 4;
    
    UInt8 red = data[pixelInfo];
    UInt8 green = data[(pixelInfo + 1)];
    UInt8 blue = data[pixelInfo + 2];
    CFRelease(pixelData);
    
    [selectedColor release];
    selectedColor = [[UIColor alloc] initWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
*/
    
    NSObject *colors[12][12] = {
        [NSNull null], [NSNull null], [NSNull null],
        [UIColor colorWithRed:0.2549f green:0.7647f blue:0.2078f alpha:1.0f],   //1
        [UIColor colorWithRed:0.4078f green:0.7804f blue:0.1412f alpha:1.0f],   //2
        [UIColor colorWithRed:0.5451f green:0.7922f blue:0.0863f alpha:1.0f],   //3
        [UIColor colorWithRed:0.698f green:0.8275f blue:0.0157f alpha:1.0f],    //31
        [UIColor colorWithRed:0.8353f green:0.8235f blue:0.0039f alpha:1.0f],   //32
        [UIColor colorWithRed:0.8784f green:0.7804f blue:0.0039f alpha:1.0f],   //33
        [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [UIColor colorWithRed:0.1725f green:0.7176f blue:0.3176f alpha:1.0f],   //4
        [UIColor colorWithRed:0.298f green:0.7098f blue:0.2392f alpha:1.0f],    //5
        [UIColor colorWithRed:0.4471f green:0.7176f blue:0.1804f alpha:1.0f],   //6
        [UIColor colorWithRed:0.5922f green:0.7373f blue:0.1294f alpha:1.0f],   //7
        [UIColor colorWithRed:0.7412f green:0.7647f blue:0.0588f alpha:1.0f],   //34
        [UIColor colorWithRed:0.8627f green:0.7686f blue:0.0039f alpha:1.0f],   //35
        [UIColor colorWithRed:0.902f green:0.7608f blue:0.0039f alpha:1.0f],    //36
        [UIColor colorWithRed:0.9255f green:0.7333f blue:0.0039f alpha:1.0f],   //37
        [NSNull null], [NSNull null], [NSNull null],
        [UIColor colorWithRed:0.1098f green:0.6745f blue:0.4471f alpha:1.0f],   //8
        [UIColor colorWithRed:0.2157f green:0.6549f blue:0.3529f alpha:1.0f],   //9
        [UIColor colorWithRed:0.3373f green:0.6392f blue:0.2706f alpha:1.0f],   //10
        [UIColor colorWithRed:0.4824f green:0.6588f blue:0.2157f alpha:1.0f],   //11
        [UIColor colorWithRed:0.6275f green:0.6784f blue:0.1569f alpha:1.0f],   //12
        [UIColor colorWithRed:0.7569f green:0.6784f blue:0.0941f alpha:1.0f],   //38
        [UIColor colorWithRed:0.8784f green:0.702f blue:0.0039f alpha:1.0f],    //39
        [UIColor colorWithRed:0.9255f green:0.7176f blue:0.0039f alpha:1.0f],   //40
        [UIColor colorWithRed:0.9451f green:0.7137f blue:0.0039f alpha:1.0f],   //41
        [UIColor colorWithRed:0.9647f green:0.6902f blue:0.0039f alpha:1.0f],   //42
        [NSNull null],
        [UIColor colorWithRed:0.0627f green:0.6314f blue:0.5608f alpha:1.0f],   //13
        [UIColor colorWithRed:0.1569f green:0.6118f blue:0.4745f alpha:1.0f],   //14
        [UIColor colorWithRed:0.2706f green:0.5922f blue:0.3804f alpha:1.0f],   //15
        [UIColor colorWithRed:0.3922f green:0.5843f blue:0.3059f alpha:1.0f],   //16
        [UIColor colorWithRed:0.5255f green:0.5961f blue:0.2588f alpha:1.0f],   //17
        [UIColor colorWithRed:0.6549f green:0.6157f blue:0.1882f alpha:1.0f],   //18
        [UIColor colorWithRed:0.7608f green:0.6039f blue:0.1137f alpha:1.0f],   //43
        [UIColor colorWithRed:0.8706f green:0.6196f blue:0.0431f alpha:1.0f],   //44
        [UIColor colorWithRed:0.9333f green:0.6353f blue:0.0039f alpha:1.0f],   //45
        [UIColor colorWithRed:0.9647f green:0.6745f blue:0.0039f alpha:1.0f],   //46
        [UIColor colorWithRed:0.9765f green:0.6824f blue:0.0039f alpha:1.0f],   //47
        [UIColor colorWithRed:0.9804f green:0.6745f blue:0.0078f alpha:1.0f],   //48
        [UIColor colorWithRed:0.0941f green:0.5725f blue:0.5961f alpha:1.0f],   //19
        [UIColor colorWithRed:0.2157f green:0.549f blue:0.498f alpha:1.0f],     //20
        [UIColor colorWithRed:0.3176f green:0.5216f blue:0.4157f alpha:1.0f],   //21
        [UIColor colorWithRed:0.4275f green:0.5216f blue:0.3412f alpha:1.0f],   //22
        [UIColor colorWithRed:0.5608f green:0.5333f blue:0.2863f alpha:1.0f],   //23
        [UIColor colorWithRed:0.6627f green:0.5294f blue:0.2078f alpha:1.0f],   //24
        [UIColor colorWithRed:0.7647f green:0.5333f blue:0.1412f alpha:1.0f],   //49
        [UIColor colorWithRed:0.8588f green:0.5451f blue:0.0706f alpha:1.0f],   //50
        [UIColor colorWithRed:0.9529f green:0.5686f blue:0.0039f alpha:1.0f],   //51
        [UIColor colorWithRed:0.9725f green:0.5961f blue:0.0039f alpha:1.0f],   //52
        [UIColor colorWithRed:0.9804f green:0.6314f blue:0.0039f alpha:1.0f],   //53
        [UIColor colorWithRed:0.9804f green:0.651f blue:0.0196f alpha:1.0f],    //54
        [UIColor colorWithRed:0.1333f green:0.4941f blue:0.6078f alpha:1.0f],   //25
        [UIColor colorWithRed:0.251f green:0.4745f blue:0.5294f alpha:1.0f],    //26
        [UIColor colorWithRed:0.3569f green:0.4667f blue:0.4431f alpha:1.0f],   //27
        [UIColor colorWithRed:0.4706f green:0.4667f blue:0.3725f alpha:1.0f],   //28
        [UIColor colorWithRed:0.5765f green:0.4667f blue:0.302f alpha:1.0f],    //29
        [UIColor colorWithRed:0.6627f green:0.4667f blue:0.2392f alpha:1.0f],   //30
        [UIColor colorWithRed:0.7608f green:0.4706f blue:0.1647f alpha:1.0f],   //55
        [UIColor colorWithRed:0.8549f green:0.4824f blue:0.098f alpha:1.0f],    //56
        [UIColor colorWithRed:0.9373f green:0.4941f blue:0.0353f alpha:1.0f],   //57
        [UIColor colorWithRed:0.9804f green:0.5176f blue:0.0039f alpha:1.0f],   //58
        [UIColor colorWithRed:0.9804f green:0.549f blue:0.0196f alpha:1.0f],    //59
        [UIColor colorWithRed:0.9804f green:0.5765f blue:0.0275f alpha:1.0f],   //60
        [UIColor colorWithRed:0.1373f green:0.3961f blue:0.6471f alpha:1.0f],   //91
        [UIColor colorWithRed:0.2706f green:0.3961f blue:0.5451f alpha:1.0f],   //92
        [UIColor colorWithRed:0.3725f green:0.4f blue:0.4627f alpha:1.0f],      //93
        [UIColor colorWithRed:0.4784f green:0.4f blue:0.3961f alpha:1.0f],      //94
        [UIColor colorWithRed:0.5765f green:0.3961f blue:0.3255f alpha:1.0f],   //95
        [UIColor colorWithRed:0.6667f green:0.4039f blue:0.2627f alpha:1.0f],   //96
        [UIColor colorWithRed:0.7569f green:0.4118f blue:0.2f alpha:1.0f],      //61
        [UIColor colorWithRed:0.8392f green:0.4157f blue:0.1333f alpha:1.0f],   //62
        [UIColor colorWithRed:0.9255f green:0.4431f blue:0.0667f alpha:1.0f],   //63
        [UIColor colorWithRed:0.9804f green:0.4627f blue:0.0196f alpha:1.0f],   //64
        [UIColor colorWithRed:0.9804f green:0.4863f blue:0.0314f alpha:1.0f],   //65
        [UIColor colorWithRed:0.9804f green:0.4745f blue:0.0275f alpha:1.0f],   //66
        [UIColor colorWithRed:0.1294f green:0.298f blue:0.7137f alpha:1.0f],    //97
        [UIColor colorWithRed:0.251f green:0.3137f blue:0.6118f alpha:1.0f],    //98
        [UIColor colorWithRed:0.3882f green:0.3294f blue:0.5098f alpha:1.0f],   //99
        [UIColor colorWithRed:0.5059f green:0.3412f blue:0.4431f alpha:1.0f],   //100
        [UIColor colorWithRed:0.5843f green:0.3373f blue:0.349f alpha:1.0f],    //101
        [UIColor colorWithRed:0.6667f green:0.3373f blue:0.2863f alpha:1.0f],   //102
        [UIColor colorWithRed:0.749f green:0.3529f blue:0.2235f alpha:1.0f],    //67
        [UIColor colorWithRed:0.8235f green:0.3686f blue:0.1608f alpha:1.0f],   //68
        [UIColor colorWithRed:0.8941f green:0.3843f blue:0.1059f alpha:1.0f],   //69
        [UIColor colorWithRed:0.9529f green:0.4039f blue:0.0549f alpha:1.0f],   //70
        [UIColor colorWithRed:0.9804f green:0.3922f blue:0.0275f alpha:1.0f],   //71
        [UIColor colorWithRed:0.9804f green:0.3098f blue:0.0275f alpha:1.0f],   //72
        [UIColor colorWithRed:0.1529f green:0.2471f blue:0.7333f alpha:1.0f],   //103
        [UIColor colorWithRed:0.2275f green:0.2314f blue:0.6784f alpha:1.0f],   //104
        [UIColor colorWithRed:0.3647f green:0.2667f blue:0.5882f alpha:1.0f],   //105
        [UIColor colorWithRed:0.5137f green:0.298f blue:0.498f alpha:1.0f],     //106
        [UIColor colorWithRed:0.5961f green:0.2941f blue:0.4039f alpha:1.0f],   //107
        [UIColor colorWithRed:0.6588f green:0.2902f blue:0.3176f alpha:1.0f],   //108
        [UIColor colorWithRed:0.7373f green:0.298f blue:0.2549f alpha:1.0f],    //73
        [UIColor colorWithRed:0.8039f green:0.3137f blue:0.2f alpha:1.0f],      //74
        [UIColor colorWithRed:0.8627f green:0.3373f blue:0.1412f alpha:1.0f],   //75
        [UIColor colorWithRed:0.9294f green:0.3451f blue:0.0824f alpha:1.0f],   //76
        [UIColor colorWithRed:0.9804f green:0.298f blue:0.0196f alpha:1.0f],    //77
        [UIColor colorWithRed:0.9804f green:0.2627f blue:0.0235f alpha:1.0f],   //78
        [NSNull null],
        [UIColor colorWithRed:0.2392f green:0.2f blue:0.7098f alpha:1.0f],      //109
        [UIColor colorWithRed:0.3137f green:0.2039f blue:0.6784f alpha:1.0f],   //110
        [UIColor colorWithRed:0.4627f green:0.2431f blue:0.5804f alpha:1.0f],   //111
        [UIColor colorWithRed:0.5922f green:0.2471f blue:0.4627f alpha:1.0f],   //112
        [UIColor colorWithRed:0.6667f green:0.2549f blue:0.3765f alpha:1.0f],   //113
        [UIColor colorWithRed:0.7137f green:0.2588f blue:0.298f alpha:1.0f],    //79
        [UIColor colorWithRed:0.7725f green:0.2667f blue:0.2353f alpha:1.0f],   //80
        [UIColor colorWithRed:0.8392f green:0.2784f blue:0.1725f alpha:1.0f],   //81
        [UIColor colorWithRed:0.9176f green:0.2549f blue:0.0863f alpha:1.0f],   //82
        [UIColor colorWithRed:0.9804f green:0.2118f blue:0.0235f alpha:1.0f],   //83
        [NSNull null], [NSNull null], [NSNull null],
        [UIColor colorWithRed:0.3255f green:0.1843f blue:0.698f alpha:1.0f],    //114
        [UIColor colorWithRed:0.4f green:0.1882f blue:0.6627f alpha:1.0f],      //115
        [UIColor colorWithRed:0.5569f green:0.2196f blue:0.5569f alpha:1.0f],   //116
        [UIColor colorWithRed:0.6471f green:0.2196f blue:0.4314f alpha:1.0f],   //117
        [UIColor colorWithRed:0.7176f green:0.2196f blue:0.3373f alpha:1.0f],   //84
        [UIColor colorWithRed:0.7843f green:0.2039f blue:0.2353f alpha:1.0f],   //85
        [UIColor colorWithRed:0.8667f green:0.1725f blue:0.1412f alpha:1.0f],   //86
        [UIColor colorWithRed:0.9412f green:0.1412f blue:0.0667f alpha:1.0f],   //87
        [NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null],
        [UIColor colorWithRed:0.3922f green:0.1647f blue:0.6902f alpha:1.0f],   //118
        [UIColor colorWithRed:0.4784f green:0.1725f blue:0.6314f alpha:1.0f],   //119
        [UIColor colorWithRed:0.6353f green:0.1765f blue:0.4824f alpha:1.0f],   //120
        [UIColor colorWithRed:0.7608f green:0.1451f blue:0.3059f alpha:1.0f],   //88
        [UIColor colorWithRed:0.8863f green:0.0824f blue:0.149f alpha:1.0f],    //89
        [UIColor colorWithRed:0.9216f green:0.0745f blue:0.0863f alpha:1.0f],   //90
        [NSNull null], [NSNull null], [NSNull null]
    };

    int x = point.x/20.166;
    int y = point.y/20.166;
    while (colors[y][x] == [NSNull null]) {     //going into valid area
        if (x >= 6) {
            x--;
        } else {
            x++;
        }
        if (y >= 6) {
            y--;
        } else {
            y++;
        }
    }

    selectedColor = [[UIColor alloc] initWithCGColor:((UIColor *)colors[y][x]).CGColor];
    
    //setting adjacent colors
    NSMutableArray *array = [[NSMutableArray alloc] init];
    x--;    //2
    y--;
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
    x++;    //3
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
    x++;    //4
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
    y++;    //5
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
    x-=2;    //6
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
    y++;    //7
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
    x++;    //8
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
    x++;    //9
    if (x >= 0 && x <= 11 && y >= 0 && y <= 11) {
        [array addObject:colors[y][x]];
    }
}


// touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:moodmap];
    // see if touched point is on moodmap
    float d = sqrtf(powf(121.0f-point.x, 2) + powf(121.0f-point.y, 2));
    if (d <= 121.0f) {
        welcome.hidden = YES;
        [selector setCenter:CGPointMake(point.x+moodmap.frame.origin.x, point.y+moodmap.frame.origin.y)];
        selector.alpha = 1.0;
        [self colorOfPoint:point];
        [ring setImage:[self imageByFillingColor:selectedColor inImage:ring.image]];
        [UIView beginAnimations:@"glowAnimation" context:nil];
        [UIView setAnimationDuration:0.3];
        glow.alpha = 1.0;
        ring.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:moodmap];
    float d = sqrtf(powf(121.0f-point.x, 2) + powf(121.0f-point.y, 2));
    if (d <= 121.0f) {
        [selector setCenter:CGPointMake(point.x+moodmap.frame.origin.x, point.y+moodmap.frame.origin.y)];
        [self colorOfPoint:point];
        [ring setImage:[self imageByFillingColor:selectedColor inImage:ring.image]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView beginAnimations:@"glowAnimation" context:nil];
    [UIView setAnimationDuration:0.3];
    glow.alpha = 0;
    ring.alpha = 0;
    [UIView commitAnimations];
    
    CGPoint point = [[touches anyObject] locationInView:moodmap];
    float d = sqrtf(powf(121.0f-point.x, 2) + powf(121.0f-point.y, 2));
    if (d <= 121.0f) {
        // get the ID
        int x = point.x/20.166;
        int y = point.y/20.166;
        playlistID = idArray[y][x];
        [self getPlaylistFromServer];
    }
}


// Alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self getPlaylistFromServer];
    }
}


// server API
- (void)getPlaylistFromServer {
    Producer getMedia = [[RFAPI singleton] getPlaylist:playlistID + 187];
    
    self.playlist = nil;
    [tabView reloadData];
    
    [self.controllerView.activityIndicator startAnimating];
    [self associateProducer:getMedia callback:^ (id result) {
        self.playlist = (Playlist *)result;
        [self.controllerView.activityIndicator stopAnimating];
        doneButton.enabled = YES;
        [tabView reloadData];
    }];

}


@end
