//
//  HeaderPageView.m
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/18/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import "HeaderPageView.h"
#import "UIImage+RumblefishSDKResources.h"

@interface HeaderPageView ()

@property (nonatomic, strong) Playlist *playlist;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *contentBox;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end


@implementation HeaderPageView

- (id)initWithPlaylist:(Playlist *)playlist
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _playlist = playlist;
        
        NSLog(@"Creating View for playlist: %@", _playlist.title);
        
        //Create image views for each page
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.image = [UIImage imageInResourceBundleNamed:@"moodmap@2x.png"];
        [self addSubview:_imageView];
                
        //Create content box for words
        _contentBox = [[UIView alloc] initWithFrame:CGRectZero];
        _contentBox.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        [_imageView addSubview:_contentBox];
        
        //Title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:34];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.text = playlist.title;
        [_contentBox addSubview:_titleLabel];
        
        //Subtitle
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = [UIFont systemFontOfSize:18];
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.shadowColor = [UIColor blackColor];
        _subtitleLabel.shadowOffset = CGSizeMake(0, 1);
        _subtitleLabel.text = playlist.editorial;
        [_contentBox addSubview:_subtitleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    _imageView.frame = self.bounds;
    
    CGFloat boxHeight = 80;
    _contentBox.frame = CGRectMake(0, 0, boxHeight * 3, boxHeight);
    _contentBox.center = CGPointMake(_imageView.bounds.size.width / 2,
                                     _imageView.bounds.size.height - (boxHeight / 2));
    
    int padding = 2;
    _titleLabel.frame = CGRectMake(padding,
                                   padding,
                                   _contentBox.bounds.size.width - (padding * 2),
                                   _titleLabel.font.lineHeight);
    
    _subtitleLabel.frame = CGRectMake(padding,
                                      _titleLabel.bounds.size.height + _titleLabel.frame.origin.y,
                                      _contentBox.bounds.size.width - (padding * 2),
                                      _subtitleLabel.font.lineHeight);
}

@end
