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


#import "HeaderPageView.h"
#import "UIImage+RumblefishSDKResources.h"
#import "RFFont.h"

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
        _imageView.image = playlist.image;
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
        _titleLabel.font = [RFFont fontWithSize:34];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.text = playlist.title;
        [_contentBox addSubview:_titleLabel];
        
        //Subtitle
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.font = [RFFont fontWithSize:18];
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.shadowColor = [UIColor blackColor];
        _subtitleLabel.shadowOffset = CGSizeMake(0, 1);
        _subtitleLabel.text = playlist.strippedEditorial;
        [_contentBox addSubview:_subtitleLabel];
        
        _displayAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_displayAlbumButton];
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
    
    _displayAlbumButton.frame = self.bounds;
}

@end
