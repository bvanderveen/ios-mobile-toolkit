//
//  HeaderPageView.m
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/18/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import "HeaderPageView.h"

@interface HeaderPageView ()

@property (nonatomic, copy) Playlist *playlist;

@end


@implementation HeaderPageView

- (id)initWithPlaylist:(Playlist *)playlist
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _playlist = playlist;
    }
    return self;
}

- (void)layoutSubviews
{
//    CGRect frame;
//    frame.origin.x = self.scrollView.frame.size.width * i;
//    frame.origin.y = 0;
//    frame.size = self.scrollView.frame.size;
//    
//    //Create image views for each cell
//    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:frame];
//    pageImageView.contentMode = UIViewContentModeScaleAspectFill;
//    pageImageView.backgroundColor = [UIColor blackColor];
//#warning DEV
//    pageImageView.image = [UIImage imageInResourceBundleNamed:@"moodmap@2x.png"];
//#warning endDEV
//    [self.scrollView addSubview:pageImageView];
//    
//    //Create content box for words
//    UIView *contentBox = [[UIView alloc] initWithFrame:CGRectZero];
//    contentBox.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
//    [pageImageView addSubview:contentBox];
//    CGFloat boxHeight = 80;
//    contentBox.frame = CGRectMake(0, 0, boxHeight * 3, boxHeight);
//    contentBox.center = CGPointMake(pageImageView.bounds.size.width / 2,
//                                    pageImageView.bounds.size.height - (boxHeight / 2));
//    
//    //Add labels inside content box
//    int padding = 2;
//    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLabel.adjustsFontSizeToFitWidth = YES;
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont systemFontOfSize:34];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text = item[@"Title"];
//    titleLabel.shadowColor = [UIColor blackColor];
//    titleLabel.shadowOffset = CGSizeMake(0, 1);
//    [contentBox addSubview:titleLabel];
//    titleLabel.frame = CGRectMake(padding,
//                                  padding,
//                                  contentBox.bounds.size.width - (padding * 2),
//                                  titleLabel.font.lineHeight);
//    
//    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    subtitleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
//    subtitleLabel.textAlignment = NSTextAlignmentCenter;
//    subtitleLabel.font = [UIFont systemFontOfSize:18];
//    subtitleLabel.adjustsFontSizeToFitWidth = YES;
//    subtitleLabel.backgroundColor = [UIColor clearColor];
//    subtitleLabel.text = item[@"Subtitle"];
//    subtitleLabel.shadowColor = [UIColor blackColor];
//    subtitleLabel.shadowOffset = CGSizeMake(0, 1);
//    [contentBox addSubview:subtitleLabel];
//    subtitleLabel.frame = CGRectMake(padding,
//                                     titleLabel.bounds.size.height + titleLabel.frame.origin.y,
//                                     contentBox.bounds.size.width - (padding * 2),
//                                     subtitleLabel.font.lineHeight);
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
