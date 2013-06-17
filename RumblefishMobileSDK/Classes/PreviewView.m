#import "PreviewView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface PreviewView ()

@property (nonatomic, strong) NSURL *movieURL, *musicURL;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) AVPlayerItem *musicPlayerItem;
@property (nonatomic, strong) AVPlayer *musicPlayer;
@property (nonatomic, assign) BOOL moviePlayable, musicPlayable;

@end

@implementation PreviewView

- (id)initWithMovieURL:(NSURL *)movieURL musicURL:(NSURL *)musicURL {
    if (self = [super initWithFrame:CGRectZero]) {
        _movieURL = movieURL;
        _musicURL = musicURL;
    }
    return self;
}

- (void)layoutSubviews {
    _moviePlayer.view.frame = self.bounds;
}

- (void)playIfPossible {
    if (_moviePlayable && _musicPlayable) {
        NSLog(@"Playing");
        [_moviePlayer play];
        [_musicPlayer play];
    }
}

- (void)startPlayback {
    [self loadMoviePlayer];
    [self loadMusicPlayer];
}

- (void)stopPlayback {
    [_moviePlayer stop];
    [_musicPlayer pause];
    [self ejectMusicPlayer];
    [self ejectMoviePlayer];
}

- (void)loadMoviePlayer {
    NSLog(@"Loading with movieURL = %@", _movieURL);
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:_movieURL];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.shouldAutoplay = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_moviePlayer];
    
    [_moviePlayer prepareToPlay];
    
    [self addSubview:_moviePlayer.view];
}

- (void)ejectMoviePlayer {
    _moviePlayable = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayer];
    _moviePlayer = nil;
}

- (void)loadMusicPlayer {
    _musicPlayerItem = [[AVPlayerItem alloc] initWithURL:_musicURL];
    [_musicPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [_musicPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_musicPlayerItem];
    
    _musicPlayer = [[AVPlayer alloc] initWithPlayerItem:_musicPlayerItem];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)ejectMusicPlayer {
    _musicPlayable = NO;
    [_musicPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [_musicPlayerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_musicPlayerItem];
    _musicPlayerItem = nil;
    _musicPlayer = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([item status] == AVPlayerItemStatusFailed) {
            [self ejectMusicPlayer];
        }
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        NSLog(@"_musicPlayerItem.playbackLikelyToKeepUp = %d", _musicPlayerItem.playbackLikelyToKeepUp);
        _musicPlayable = _musicPlayerItem.playbackLikelyToKeepUp;
        [self playIfPossible];
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification {
    NSLog(@"_moviePlayer.loadState = %d", _moviePlayer.loadState);
    _moviePlayable = (_moviePlayer.loadState & MPMovieLoadStatePlaythroughOK) > 0;
    [self playIfPossible];
}

- (void)moviePlayerPlaybackStateDidChange:(NSNotification *)notification {
    NSLog(@"_moviePlayer.playbackState = %d", _moviePlayer.playbackState);
    if (_moviePlayer.playbackState == MPMoviePlaybackStateStopped || _moviePlayer.playbackState == MPMoviePlaybackStateInterrupted || _moviePlayer.playbackState == MPMoviePlaybackStatePaused) {
        [self stopPlayback];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self stopPlayback];
}

@end
