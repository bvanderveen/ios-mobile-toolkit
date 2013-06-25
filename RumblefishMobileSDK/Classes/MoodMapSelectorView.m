//
//  MoodMapSelectorView.m
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/24/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import "MoodMapSelectorView.h"
#import "UIImage+RumblefishSDKResources.h"

@implementation MoodMapSelectorView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _backgroundSuround = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"bg_surround.png"]];
        [self addSubview:_backgroundSuround];
        
        _logo = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"logo.png"]];
        [self addSubview:_logo];
        
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setImage:[UIImage imageInResourceBundleNamed:@"btn_done.png"] forState:UIControlStateNormal];
        _doneButton.adjustsImageWhenHighlighted = YES;
        [self addSubview:_doneButton];
        
        _filtersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filtersButton setImage:[UIImage imageInResourceBundleNamed:@"btn_filters_OFF.png"] forState:UIControlStateNormal];
        _filtersButton.adjustsImageWhenHighlighted = YES;
        [self addSubview:_filtersButton];
        
        _moodmapIcons = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"moodmap_icons.png"]];
        [self addSubview:_moodmapIcons];
        
        _moodmap = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"moodmap.png"]];
        [self addSubview:_moodmap];
        
        _crosshairs = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"crosshairs.png"]];
        [self addSubview:_crosshairs];
        
        _selector = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"selector.png"]];
        [self addSubview:_selector];
        
        _moodmapRing = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"moodmap_ring.png"]];
        [self addSubview:_moodmapRing];
        
        _moodmapGlow = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"moodmap_glow.png"]];
        [self addSubview:_moodmapGlow];
        
        _startMessage = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"start_message.png"]];
        [self addSubview:_startMessage];  
    }
    return self;
}


- (void)layoutSubviews
{
    _backgroundSuround.frame = self.bounds;
    _logo.frame = CGRectMake(211, 5, 103, 29);
    _doneButton.frame = CGRectMake(2, 2, 107, 103);
    _filtersButton.frame = CGRectMake(1, 214, 107, 104);
    _moodmapIcons.frame = CGRectMake(8, 11, 302, 302);
    _moodmap.frame = CGRectMake(39, 41, 242, 242);
    _crosshairs.frame = _moodmap.frame;
    _selector.frame = CGRectMake(137, 139, 45, 45);
    _moodmapRing.frame = CGRectMake(24, 28, 271, 268);
    _moodmapGlow.frame = _moodmapRing.frame;
    _startMessage.frame = CGRectMake(63, 134, 195, 56);
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
    
    _selectedColor = [[UIColor alloc] initWithCGColor:((UIColor *)colors[y][x]).CGColor];
    [_delegate updateSelectedColorWithColor:_selectedColor];
    
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

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_delegate stopScrolling];
    
    CGPoint point = [[touches anyObject] locationInView:_moodmap];
    // see if touched point is on moodmap
    float d = sqrtf(powf(121.0f-point.x, 2) + powf(121.0f-point.y, 2));
    if (d <= 121.0f) {
        _startMessage.hidden = YES;
        [_selector setCenter:CGPointMake(point.x+_moodmap.frame.origin.x, point.y+_moodmap.frame.origin.y)];
        _selector.alpha = 1.0;
        [self colorOfPoint:point];
        [_moodmapRing setImage:[self imageByFillingColor:_selectedColor inImage:_moodmapRing.image]];
        [UIView beginAnimations:@"glowAnimation" context:nil];
        [UIView setAnimationDuration:0.3];
        _moodmapGlow.alpha = 1.0;
        _moodmapRing.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:_moodmap];
    float d = sqrtf(powf(121.0f-point.x, 2) + powf(121.0f-point.y, 2));
    if (d <= 121.0f) {
        [_selector setCenter:CGPointMake(point.x+_moodmap.frame.origin.x, point.y+_moodmap.frame.origin.y)];
        [self colorOfPoint:point];
        [_moodmapRing setImage:[self imageByFillingColor:_selectedColor inImage:_moodmapRing.image]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView beginAnimations:@"glowAnimation" context:nil];
    [UIView setAnimationDuration:0.3];
    _moodmapGlow.alpha = 0;
    _moodmapRing.alpha = 0;
    [UIView commitAnimations];
    
    CGPoint point = [[touches anyObject] locationInView:_moodmap];
    float d = sqrtf(powf(121.0f-point.x, 2) + powf(121.0f-point.y, 2));
    if (d <= 121.0f) {
        // get the ID
        int x = point.x/20.166;
        int y = point.y/20.166;
        [_delegate updatePlaylistIdWithX:x andY:y];
    }
    
    [_delegate startScrolling];
}
 -(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_delegate startScrolling];
}

@end
