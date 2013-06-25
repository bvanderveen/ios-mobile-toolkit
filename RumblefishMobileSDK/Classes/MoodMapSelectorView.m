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

#warning Make the whole thing programmatically. I know it's a pain but what are you gonna do?

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

        
        _filtersButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filtersButton setImage:[UIImage imageInResourceBundleNamed:@"btn_filters_OFF.png"] forState:UIControlStateNormal];
        _filtersButton.adjustsImageWhenHighlighted = YES;
        [self addSubview:_filtersButton];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
