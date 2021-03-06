
#import "RFPlayer.h"

@interface RFPlayer ()

@property (nonatomic) BOOL isVideo;

@end


@implementation RFPlayer

- (id)initWithMediaURL:(NSURL *)url isVideo:(BOOL)isVideo
{
    if (self = [super init])
    {
        _playerItem = [[AVPlayerItem alloc] initWithURL:url];
        
        [_playerItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        
        [_playerItem addObserver:self
                      forKeyPath:@"playbackLikelyToKeepUp"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_playerItem];
        
        _player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}

- (void)play {
    [_player play];
}

- (void)pause {
    [_player pause];
}

- (void)dealloc
{
    [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:_playerItem];
    _playerItem = nil;
    _player = nil;
}

- (void)updateVolume:(float)volume;
{
    NSArray *audioTracks = [_playerItem.asset tracksWithMediaType:AVMediaTypeAudio];

    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams =
        [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:volume/100 atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    
    [_playerItem setAudioMix:audioMix];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([item status] == AVPlayerItemStatusFailed) {
//            [self ejectPlayer];
        }   
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        [_delegate playerIsReadyToPlay];
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [_delegate playerDidReachEnd];
}

@end