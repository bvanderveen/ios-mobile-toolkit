//
//  Player.h
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/26/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "RFAPI.h"

@protocol PlayerDelegate <NSObject>

@required
- (void)playIfPossible;
- (void)stopPlayback;

@end

@interface Player : NSObject

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isVideo;
@property (nonatomic, weak) id<PlayerDelegate> delegate;

- (id)initWithMediaURL:(NSURL *)url isVideo:(BOOL)isVideo;
- (void)ejectPlayer;
- (void)updateVolume:(float)volume;

@end
