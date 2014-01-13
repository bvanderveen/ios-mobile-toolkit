#import "RFPreviewController.h"
#import "RFPreviewView.h"
#import <AVFoundation/AVFoundation.h>
#import "RFPlayerPlaybackView.h"
#import "RFPlayer.h"

@interface RFPreviewController () <RFPlayerDelegate>

@property (nonatomic, strong) RFMedia *media;
@property (nonatomic, strong) RFPreviewView *view;
@property (nonatomic, strong) RFPlayer *moviePlayer, *musicPlayer;
@property (nonatomic) BOOL volControlsShown, playing;
@property (nonatomic) id mTimeObserver;
@property (nonatomic) float mRestoreAfterScrubbingRate;

@end

@implementation RFPreviewController

@dynamic view;

- (id)initWithMedia:(RFMedia *)media {
    if (self = [super init]) {
        _moviePlayer = [[RFPlayer alloc] initWithMediaURL:[RFAPI singleton].videoURL isVideo:YES];
        _musicPlayer = [[RFPlayer alloc] initWithMediaURL:media.previewURL isVideo:NO];
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
    UIView *newParentView = [UIApplication sharedApplication].keyWindow;
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
    self.view = [[RFPreviewView alloc] initWithMedia:_media];
    [self.view.dismissButton addTarget:self
                                action:@selector(dismiss)
                      forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view.videoSlider addTarget:self
                               action:@selector(endScrubbing:)
                     forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.view.videoSlider addTarget:self
                              action:@selector(beginScrubbing:)
                    forControlEvents:UIControlEventTouchDown];
    
    [self.view.videoSlider addTarget:self
                              action:@selector(scrub:)
                    forControlEvents:UIControlEventTouchDragInside | UIControlEventValueChanged];
    
    
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
                                             selector:@selector(hideSliders)
                                               object:nil];
    
    [self showSliders];
}

- (void)showSliders {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.volumeSliderContainerView.alpha = 1;
                         self.view.videoSliderContainerView.alpha = 1;
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(hideSliders)
                                    withObject:nil
                                    afterDelay:2.25];
                     }];
}

- (void)hideSliders {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.volumeSliderContainerView.alpha = 0;
                         self.view.videoSliderContainerView.alpha = 0;
                     } completion:nil];
}

- (NSString *)formattedDuration {
    CMTime videoTime = self.moviePlayer.playerItem.duration;
    int duration = videoTime.value/videoTime.timescale;
    NSUInteger h = duration / 3600;
    NSUInteger m = ((duration / 60) % 60) + (60 * h);
    NSUInteger s = duration % 60;
    
    NSString *formattedTime =  (m > 99) ? [NSString stringWithFormat:@"%03u:%02u", m, s] :
                                (m > 9) ? [NSString stringWithFormat:@"%02u:%02u", m, s] :
                                          [NSString stringWithFormat:@"0:%02u", s];
    return formattedTime;
}


#pragma mark - Button Methods

- (void)pausePlayers {
    [_musicPlayer pause];
    [_moviePlayer pause];
}

- (void)playPlayers {
    [_musicPlayer play];
    [_moviePlayer play];
}

- (void)buySong {
    [self pausePlayers];
    RFPurchase *purchase = [[RFPurchase alloc] initWithMedia:_media completion:^{
        [self dismiss];
    }];
    [RFAPI singleton].didInitiatePurchase(purchase);
}

- (void)dismiss {
    [self pausePlayers];
    [UIView animateWithDuration:0.05 animations:^{
        self.view.auditionBackgroundView.alpha = 0;
    }];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (void)volumeSliderTouched {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideSliders)
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
    [self performSelector:@selector(hideSliders) withObject:nil afterDelay:0.8];
}


#pragma mark - PlayerDelegate

- (void)playerIsReadyToPlay {
    BOOL musicPlayable = _musicPlayer.playerItem.playbackLikelyToKeepUp;
    BOOL moviePlayable = _moviePlayer.playerItem.playbackLikelyToKeepUp;
    
    if (musicPlayable && moviePlayable && !_playing) {
        self.view.durationMaximumLabel.text = [self formattedDuration];
        _playing = YES;
        [self.view.activityIndicator stopAnimating];
        self.view.playbackView.hidden = NO;
        [self playPlayers];
        if (!_volControlsShown)
            [self showSliders];
        _volControlsShown = YES;
        [self initScrubberTimer];
    }
}

- (void)playerDidReachEnd {
    _playing = NO;
    [self pausePlayers];
    [_moviePlayer.player seekToTime:kCMTimeZero completionHandler:nil];
    [_musicPlayer.player seekToTime:kCMTimeZero completionHandler:nil];
}

#pragma mark - Scrubber

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)initScrubberTimer
{
	double interval = .1f;
	
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		return;
	}
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration))
	{
		CGFloat width = CGRectGetWidth([self.view.videoSlider bounds]);
		interval = 0.5f * duration / width;
	}
    
	/* Update the scrubber during normal playback. */
	self.mTimeObserver = [self.moviePlayer.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                                               queue:NULL
                                                                          usingBlock:^(CMTime time) {
                                                                                          [self syncScrubber];
                                                                                      }];
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		self.view.videoSlider.minimumValue = 0.0;
		return;
	}
    
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration))
	{
		float minValue = [self.view.videoSlider minimumValue];
		float maxValue = [self.view.videoSlider maximumValue];
		double time = CMTimeGetSeconds([self.moviePlayer.player currentTime]);
		
		[self.view.videoSlider setValue:(maxValue - minValue) * time / duration + minValue];
	}
}

/* The user is dragging the movie controller thumb to scrub through the movie. */
- (IBAction)beginScrubbing:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(hideSliders)
                                               object:nil];
    
	_mRestoreAfterScrubbingRate = [self.moviePlayer.player rate];
	[self.moviePlayer.player setRate:0.f];
	
	/* Remove previous timer. */
	[self removePlayerTimeObserver];
}

/* Set the player current time to match the scrubber position. */
- (IBAction)scrub:(id)sender
{
	if ([sender isKindOfClass:[UISlider class]])
	{
		UISlider* slider = sender;
		
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration)) {
			return;
		}
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
			float minValue = [slider minimumValue];
			float maxValue = [slider maximumValue];
			float value = [slider value];
			
			double time = duration * (value - minValue) / (maxValue - minValue);
			
			[self.moviePlayer.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
		}
	}
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (IBAction)endScrubbing:(id)sender
{
	if (!_mTimeObserver)
	{
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration))
		{
			return;
		}
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
			CGFloat width = CGRectGetWidth([self.view.videoSlider bounds]);
			double tolerance = 0.5f * duration / width;
            
			_mTimeObserver = [self.moviePlayer.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC)
                                                                                   queue:NULL
                                                                              usingBlock:^(CMTime time) {
                                                                                              [self syncScrubber];
                                                                                          }];
		}
	}
    
	if (_mRestoreAfterScrubbingRate)
	{
		[self.moviePlayer.player setRate:_mRestoreAfterScrubbingRate];
		_mRestoreAfterScrubbingRate = 0.f;
	}
    
    [self performSelector:@selector(hideSliders) withObject:nil afterDelay:0.8];
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.moviePlayer.player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
        return([playerItem duration]);
    return(kCMTimeInvalid);
}

/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (_mTimeObserver)
	{
		[self.moviePlayer.player removeTimeObserver:_mTimeObserver];
		_mTimeObserver = nil;
	}
}
                          
@end

