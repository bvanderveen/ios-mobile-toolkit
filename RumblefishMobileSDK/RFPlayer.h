
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "RFAPI.h"

@protocol RFPlayerDelegate <NSObject>

@required
- (void)playerIsReadyToPlay;
- (void)playerDidReachEnd;

@end

@interface RFPlayer : NSObject

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, weak) id<RFPlayerDelegate> delegate;

- (id)initWithMediaURL:(NSURL *)url isVideo:(BOOL)isVideo;
- (void)updateVolume:(float)volume;

- (void)play;
- (void)pause;

@end
