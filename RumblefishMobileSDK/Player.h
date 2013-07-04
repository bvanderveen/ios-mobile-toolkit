
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "RFAPI.h"

@protocol PlayerDelegate <NSObject>

@required
- (void)playerIsReadyToPlay;
- (void)playerDidReachEnd;

@end

@interface Player : NSObject

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, weak) id<PlayerDelegate> delegate;

- (id)initWithMediaURL:(NSURL *)url isVideo:(BOOL)isVideo;
- (void)updateVolume:(float)volume;

@end
