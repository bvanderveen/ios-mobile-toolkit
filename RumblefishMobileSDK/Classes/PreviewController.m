#import "PreviewController.h"
#import "PreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerPlaybackView.h"
#import "Player.h"

@interface PreviewController () <PlayerDelegate>

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) PreviewView *view;
@property (nonatomic, strong) Player *moviePlayer, *musicPlayer;
@property (nonatomic) BOOL volControlsShown, playing;

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
        _volControlsShown = NO;
        _playing = NO;
    }
    return self;
}

- (void)show
{
    UIView *newParentView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    self.view.frame = newParentView.bounds;
    self.view.auditionBackgroundView.alpha = 0;
    self.view.alpha = 0;
    [newParentView addSubview:self.view];
    [UIView animateWithDuration:0.125
                     animations:^{
                         self.view.alpha = 1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.05
                                          animations:^{
                                              self.view.auditionBackgroundView.alpha = 1;
                                          } completion:nil];
                     }];
    [self startPlayback];
}

- (void)loadView {
    self.view = [[PreviewView alloc] initWithMedia:_media];
    [self.view.dismissButton addTarget:self
                                action:@selector(dismiss)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.view.volumeSlider addTarget:self
                               action:@selector(volumeSliderTouched)
                     forControlEvents:UIControlEventTouchDown];
    [self.view.volumeSlider addTarget:self
                               action:@selector(volumeSliderChanged:)
                     forControlEvents:UIControlEventValueChanged];
    
    [self.view.volumeSlider addTarget:self
                               action:@selector(volumeSliderDoneBeingTouched)
                     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view.replayButton addTarget:self
                               action:@selector(startPlayback)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view.buyButton addTarget:self
                            action:@selector(buySong)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view setNeedsLayout];
}

- (void)startPlayback {
    self.view.replayButton.hidden = YES;
    [self.view.activityIndicator startAnimating];
    self.view.playbackView.hidden = YES;
    [self.view.playbackView setPlayer:_moviePlayer.player];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideVolumeControls)
                                               object:nil];
    
    [self showVolumeControls];
}

- (void)showVolumeControls {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.sliderContainerView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(hideVolumeControls)
                                    withObject:nil
                                    afterDelay:2.25];
                     }];
}

- (void)hideVolumeControls {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.sliderContainerView.alpha = 0;
                     } completion:nil];
}

#pragma mark - Button Methods

- (void)buySong {
    License *license = nil;
    license = [RFAPI singleton].didInitiatePurchase(license);
    if (license) {
        Producer postLicense = [[RFAPI singleton] postLicense:license];
        postLicense(^(id result) {
            [RFAPI singleton].didCompletePurchase(license);
        }, ^(NSError *error) {
            [RFAPI singleton].didFailToCompletePurchase(license, error);
        });
    }
    NSLog(@"Buy Song!");
}

- (void)dismiss {
    [UIView animateWithDuration:0.05 animations:^{
        self.view.auditionBackgroundView.alpha = 0;
    }];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_musicPlayer.player pause];
                         [_moviePlayer.player pause];
                         [self.view removeFromSuperview];
                     }];
}

- (void)volumeSliderTouched {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideVolumeControls)
                                               object:nil];
}

- (void)volumeSliderChanged:(UISlider *)slider {
    float val = slider.value;
    float musicVolume = (val > 100) ? 200 - val : 100;
    float movieVolume = (val <= 100) ? val : 100;
    [_musicPlayer updateVolume:musicVolume];
    [_moviePlayer updateVolume:movieVolume];
    
}

- (void)volumeSliderDoneBeingTouched {
    [self performSelector:@selector(hideVolumeControls) withObject:nil afterDelay:0.8];
}

#pragma mark - PlayerDelegate

- (void)playerIsReadyToPlay {
    BOOL musicPlayable = _musicPlayer.playerItem.playbackLikelyToKeepUp;
    BOOL moviePlayable = _moviePlayer.playerItem.playbackLikelyToKeepUp;
    
    if (musicPlayable && moviePlayable && !_playing) {
        _playing = YES;
        [self.view.activityIndicator stopAnimating];
        self.view.playbackView.hidden = NO;
        [_musicPlayer.player play];
        [_moviePlayer.player play];
        if (!_volControlsShown)
            [self showVolumeControls];
        _volControlsShown = YES;
    }
}

- (void)playerDidReachEnd {
    _playing = NO;
    [_moviePlayer.player pause];
    [_musicPlayer.player pause];
    [_moviePlayer.player seekToTime:kCMTimeZero completionHandler:nil];
    [_musicPlayer.player seekToTime:kCMTimeZero completionHandler:nil];
}

@end

