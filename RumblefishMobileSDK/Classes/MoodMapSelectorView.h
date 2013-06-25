//
//  MoodMapSelectorView.h
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/24/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoodMapSelectorViewDelegate <NSObject>

- (void)stopScrolling;
- (void)startScrolling;
- (void)updateSelectedColorWithColor:(UIColor *)color;
- (void)updatePlaylistIdWithX:(int)x andY:(int)y;

@end

@interface MoodMapSelectorView : UIView

@property (nonatomic, strong) UIImageView *backgroundSuround, *logo, *moodmapIcons, *moodmap, *crosshairs, *selector, *moodmapRing, *moodmapGlow, *startMessage;

@property (nonatomic, strong) UIButton *doneButton, *filtersButton;

@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, weak) id <MoodMapSelectorViewDelegate>delegate;

@end
