#import "PreviewController.h"
#import "PreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerPlaybackView.h"
#import "Player.h"

@interface PreviewController () <PlayerDelegate>

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) PreviewView *view;
@property (nonatomic, strong) Player *moviePlayer, *musicPlayer;

@end

@implementation PreviewController

@dynamic view;

- (id)initWithMedia:(Media *)media {
    if (self = [super init]) {
        _moviePlayer = [[Player alloc] initWithMediaURL:[RFAPI singleton].videoURL isVideo:YES];
        _musicPlayer = [[Player alloc] initWithMediaURL:media.previewURL isVideo:NO];
        _moviePlayer.delegate = self;
        _musicPlayer.delegate = self;
        _media = media;
    }
    return self;
}

- (void)loadView {
    self.view = [[PreviewView alloc] initWithMedia:_media];
    [self.view.dismissButton addTarget:self
                                action:@selector(dismiss)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.view setNeedsLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [self startPlayback];
}

- (void)startPlayback {
    [self.view.activityIndicator startAnimating];
    self.view.playbackView.hidden = YES;
    [self.view.playbackView setPlayer:_moviePlayer.player];
}

- (void)dismiss {
    [self.view removeFromSuperview];
}

#pragma mark - PlayerDelegate

- (void)playIfPossible {
    BOOL musicPlayable = _musicPlayer.playerItem.playbackLikelyToKeepUp;
    BOOL moviePlayable = _moviePlayer.playerItem.playbackLikelyToKeepUp;
    
    if (musicPlayable && moviePlayable) {
        [self.view.activityIndicator stopAnimating];
        self.view.playbackView.hidden = NO;
        [_musicPlayer.player play];
        [_moviePlayer.player play];
    }
}

- (void)stopPlayback {
    [_moviePlayer ejectPlayer];
    [_musicPlayer ejectPlayer];
    [self.view.playbackView setPlayer:nil];
}

@end

