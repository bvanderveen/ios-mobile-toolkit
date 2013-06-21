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


#import "HeaderView.h"
#import "UIImage+RumblefishSDKResources.h"
#import "HeaderPageView.h"
#import "RFColor.h"

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
        _blueLine.backgroundColor = [RFColor darkBlue];
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
        _pageControl.currentPage = 0;
        [_pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        self.backgroundColor = [UIColor blackColor];
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
    
    //Set up page control
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
        NSLog(@"Frame = %@", NSStringFromCGRect(pageFrame));
        
        HeaderPageView *headerPageView = [[HeaderPageView alloc] initWithPlaylist:playlist];
        headerPageView.frame = pageFrame;
        [self.scrollView addSubview:headerPageView];
        
        NSLog(@"Frame = %@", NSStringFromCGRect(headerPageView.frame));

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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!_pageControlUsed)
        _pageControl.currentPage = lround(_scrollView.contentOffset.x /
                                          (_scrollView.contentSize.width / _pageControl.numberOfPages));
}

@end
