//
//  HeaderView.h
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/18/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFAPI.h"

@protocol HeaderViewDataSource <NSObject>

@required
- (NSInteger)numberOfPlaylists;
- (Playlist *)playlistForPageNumber:(NSInteger)pageNumber;

@end

@interface HeaderView : UIView

@property (nonatomic, weak) id<HeaderViewDataSource>dataSource;

- (void)reloadData;

@end
