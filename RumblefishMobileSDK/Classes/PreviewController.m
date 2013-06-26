#import "PreviewController.h"
#import "PreviewView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerPlaybackView.h"

NSString * const kPlayableKey = @"playable";
NSString * const kStatusKey   = @"status";

@interface PreviewController ()

@property (nonatomic, strong) PreviewView *view;
@property (nonatomic, strong) NSURL *movieURL, *musicURL;

@property (nonatomic, strong) AVPlayerItem *musicPlayerItem, *moviePlayerItem;
@property (nonatomic, strong) AVPlayer *musicPlayer, *moviePlayer;
@property (nonatomic, strong) void(^completion)();

@end

@implementation PreviewController

@dynamic view;

- (id)initWithMovieURL:(NSURL *)movieURL musicURL:(NSURL *)musicURL {
    if (self = [super init]) {
        _movieURL = movieURL;
        _musicURL = musicURL;
    }
    return self;
}

- (void)loadView {
    self.view = [[PreviewView alloc] initWithFrame:CGRectZero];
    [self.view.dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [self startPlayback];
}

- (void)startPlayback {
    [self.view.activityIndicator startAnimating];
    self.view.playbackView.hidden = YES;
    [self loadMoviePlayer];
    [self loadMusicPlayer];
}

- (void)playIfPossible {
    BOOL musicPlayable = _musicPlayerItem.playbackLikelyToKeepUp;
    BOOL moviePlayable = _moviePlayerItem.playbackLikelyToKeepUp;
    
    if (musicPlayable && moviePlayable) {
        [self.view.activityIndicator stopAnimating];
        self.view.playbackView.hidden = NO;
        [_musicPlayer play];
        [_moviePlayer play];
    }
}

- (void)stopPlayback {
    [_musicPlayer pause];
    [self ejectMusicPlayer];
    [self ejectMoviePlayer];
}

- (void)loadMoviePlayer {
    _moviePlayerItem = [[AVPlayerItem alloc] initWithURL:_movieURL];
    
    [_moviePlayerItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    [_moviePlayerItem addObserver:self
                       forKeyPath:@"playbackLikelyToKeepUp"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_moviePlayerItem];
    
    _moviePlayer = [[AVPlayer alloc] initWithPlayerItem:_moviePlayerItem];
    [self.view.playbackView setPlayer:_moviePlayer];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)ejectMoviePlayer {
    [_moviePlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [_moviePlayerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_moviePlayerItem];
    _moviePlayerItem = nil;
    _moviePlayer = nil;
    [self.view.playbackView setPlayer:nil];
}

- (void)loadMusicPlayer {
    _musicPlayerItem = [[AVPlayerItem alloc] initWithURL:_musicURL];
    
    [_musicPlayerItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    [_musicPlayerItem addObserver:self
                       forKeyPath:@"playbackLikelyToKeepUp"
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_musicPlayerItem];
    
    _musicPlayer = [[AVPlayer alloc] initWithPlayerItem:_musicPlayerItem];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)ejectMusicPlayer {
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
            if ([item isEqual:_moviePlayerItem])
                [self ejectMoviePlayer];
            else
                [self ejectMusicPlayer];
        }
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        if ([item isEqual:_moviePlayerItem])
            NSLog(@"_moviePlayerItem.playbackLikelyToKeepUp = %d", _musicPlayerItem.playbackLikelyToKeepUp);
        else
            NSLog(@"_musicPlayerItem.playbackLikelyToKeepUp = %d", _musicPlayerItem.playbackLikelyToKeepUp);
        [self playIfPossible];
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self stopPlayback];
}

- (void)presentInView:(UIView *)container withCompletion:(void(^)())completion {
    NSAssert(completion != nil, @"Competion must not be nil");
    
//    container = UIApplication.sharedApplication.keyWindow;
    _completion = completion;
    UIView *v = self.view;
    assert(v != nil);
    assert(container != nil);
    v.frame = container.bounds;
    [v sizeToFit];
    NSLog(@"view bounds, %@", NSStringFromCGRect(v.frame));
    [self viewWillAppear:YES];
    [container addSubview:v];
    [container bringSubviewToFront:v];
}

- (void)dismiss {
    [self.view removeFromSuperview];
//    _completion();
}

@end

