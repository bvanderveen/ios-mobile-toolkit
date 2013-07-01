#import "PreviewController.h"
#import "PreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerPlaybackView.h"
#import "Player.h"

@interface PreviewController () <PlayerDelegate>

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) PreviewView *view;
@property (nonatomic, strong) Player *moviePlayer, *musicPlayer;
@property (nonatomic) BOOL volControlsShown;

@end

@implementation PreviewController

@dynamic view;

- (id)initWithMedia:(Media *)media {
    if (self = [super init]) {
        [self setUpPlayersForMedia:media];
        _media = media;
        _volControlsShown = NO;
    }
    return self;
}

- (void)setUpPlayersForMedia:(Media *)media
{
    _moviePlayer = [[Player alloc] initWithMediaURL:[RFAPI singleton].videoURL isVideo:YES];
    _musicPlayer = [[Player alloc] initWithMediaURL:media.previewURL isVideo:NO];
    _moviePlayer.delegate = self;
    _musicPlayer.delegate = self;
}

- (void)show
{
    UIView *newParentView = [UIApplication sharedApplication].keyWindow.rootViewController.view;  // This appears to be the same thing MPMoviePlayerController uses.
    self.view.frame = newParentView.bounds;
    [newParentView addSubview:self.view];
    [self startPlayback];
}

- (void)loadView {
    self.view = [[PreviewView alloc] initWithMedia:_media];
    [self.view.dismissButton addTarget:self
                                action:@selector(dismiss)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.view.volumeSlider addTarget:self
                               action:@selector(volumeSliderChanged:)
                     forControlEvents:UIControlEventValueChanged];
    [self.view.replayButton addTarget:self
                               action:@selector(startPlayback)
                     forControlEvents:UIControlEventTouchUpInside];    
    [self.view setNeedsLayout];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideVolumeControls)
                                               object:nil];
    
    if (self.view.sliderContainerView.alpha == 0) {
        [self showVolumeControls];
    }
}

- (void)showVolumeControls
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.sliderContainerView.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(hideVolumeControls) withObject:nil afterDelay:2];
                     }];
}

- (void)hideVolumeControls
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.sliderContainerView.alpha = 0;
                     }
                     completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
}

- (void)startPlayback {
    self.view.replayButton.hidden = YES;
    [self.view.activityIndicator startAnimating];
    self.view.playbackView.hidden = YES;
    [self.view.playbackView setPlayer:_moviePlayer.player];
}

#pragma mark - Button Methods

- (void)dismiss {
    [self stopPlayback];

    [self.view removeFromSuperview];
}

- (void)volumeSliderChanged:(UISlider *)slider {
    float val = slider.value;
    float musicVolume = (val > 100) ? 200 - val : 100;
    float movieVolume = (val <= 100) ? val : 100;
    [_musicPlayer updateVolume:musicVolume];
    [_moviePlayer updateVolume:movieVolume];
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
        if (!_volControlsShown)
            [self showVolumeControls];
        _volControlsShown = YES;
    }
}

- (void)stopPlayback {
    self.view.replayButton.hidden = NO;
    [_moviePlayer ejectPlayer];
    [_musicPlayer ejectPlayer];
    [self.view.playbackView setPlayer:nil];
}

@end

