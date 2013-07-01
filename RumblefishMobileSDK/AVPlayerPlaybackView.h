
#import <UIKit/UIKit.h>

@class AVPlayer;

@interface AVPlayerPlaybackView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
