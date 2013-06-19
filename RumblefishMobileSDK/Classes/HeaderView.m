//
//  HeaderView.m
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/18/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import "HeaderView.h"
#import "UIImage+RumblefishSDKResources.h"
#import "HeaderPageView.h"

@interface HeaderView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *blueLine;
@property (nonatomic, strong) UIView *blackLine;

@property (nonatomic) BOOL pageControlUsed;

@end

@implementation HeaderView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectZero])
    {
        //add lines to the bottom
        _blueLine = [[UIView alloc] init];
        _blueLine.backgroundColor = [UIColor blueColor];
        [self addSubview:_blueLine];
        
        _blackLine = [[UIView alloc] init];
        _blackLine.backgroundColor = [UIColor blackColor];
        [self addSubview:_blackLine];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor purpleColor];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
//        _pageControl.numberOfPages = items.count;
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        self.backgroundColor = [UIColor blackColor];
//        _items = items;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //Add lines to the bottom
    _blueLine.frame = CGRectMake(0, self.bounds.size.height - 2, self.bounds.size.width, 1);
    _blackLine.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    
    //Set up scroll view
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 2);
    
    [_pageControl sizeToFit];
    _pageControl.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 10);
}

- (void)reloadData
{
    int numberOfPlaylists = [_dataSource numberOfPlaylists];
    _pageControl.numberOfPages = numberOfPlaylists;
    [self populateScrollView];
}

- (void)populateScrollView
{
    int numberOfPlaylists = [_dataSource numberOfPlaylists];
    
    //Create a "page" for each item
    for (int i = 0; i < numberOfPlaylists; i++) {
        
        Playlist *playlist = [_dataSource playlistForPageNumber:i];
        
        CGRect pageFrame;
        pageFrame.origin.x = self.scrollView.frame.size.width * i;
        pageFrame.origin.y = 0;
        pageFrame.size = self.scrollView.frame.size;
        
        HeaderPageView *headerPageView = [[HeaderPageView alloc] initWithPlaylist:playlist];
        headerPageView.frame = pageFrame;
        
        
        //Create image views for each cell
        UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:pageFrame];
        pageImageView.contentMode = UIViewContentModeScaleAspectFill;
        pageImageView.backgroundColor = [UIColor blackColor];
#warning DEV
        pageImageView.image = [UIImage imageInResourceBundleNamed:@"moodmap@2x.png"];
#warning endDEV
        [self.scrollView addSubview:pageImageView];
        
        //Create content box for words
        UIView *contentBox = [[UIView alloc] initWithFrame:CGRectZero];
        contentBox.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        [pageImageView addSubview:contentBox];
        CGFloat boxHeight = 80;
        contentBox.frame = CGRectMake(0, 0, boxHeight * 3, boxHeight);
        contentBox.center = CGPointMake(pageImageView.bounds.size.width / 2,
                                        pageImageView.bounds.size.height - (boxHeight / 2));
        
        //Add labels inside content box
        int padding = 2;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:34];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = playlist.title;
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        [contentBox addSubview:titleLabel];
        titleLabel.frame = CGRectMake(padding,
                                      padding,
                                      contentBox.bounds.size.width - (padding * 2),
                                      titleLabel.font.lineHeight);
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.font = [UIFont systemFontOfSize:18];
        subtitleLabel.adjustsFontSizeToFitWidth = YES;
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.text = playlist.editorial;
        subtitleLabel.shadowColor = [UIColor blackColor];
        subtitleLabel.shadowOffset = CGSizeMake(0, 1);
        [contentBox addSubview:subtitleLabel];
        subtitleLabel.frame = CGRectMake(padding,
                                         titleLabel.bounds.size.height + titleLabel.frame.origin.y,
                                         contentBox.bounds.size.width - (padding * 2),
                                         subtitleLabel.font.lineHeight);
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * numberOfPlaylists,
                                             self.scrollView.frame.size.height);
    
    _pageControl.numberOfPages = numberOfPlaylists;
}

#pragma mark UIScrollViewDelegate
- (void)changePage
{
    _pageControlUsed = YES;
    CGFloat pageWidth = _scrollView.contentSize.width /_pageControl.numberOfPages;
    CGFloat x = _pageControl.currentPage * pageWidth;
    [_scrollView scrollRectToVisible:CGRectMake(x, 0, pageWidth, _scrollView.frame.size.height) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!_pageControlUsed)
        _pageControl.currentPage = lround(_scrollView.contentOffset.x /
                                          (_scrollView.contentSize.width / _pageControl.numberOfPages));
}

@end
