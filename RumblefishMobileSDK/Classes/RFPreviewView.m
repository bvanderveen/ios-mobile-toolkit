#import "RFPreviewView.h"
#import "RFColor.h"
#import "RFFont.h"
#import "UIImage+RumblefishSDKResources.h"

#define PADDING 10
#define SLIDERIMAGEWIDTH 22

@interface RFPreviewView ()

@end

@implementation RFPreviewView

- (id)initWithMedia:(RFMedia *)media;
{
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        
        _auditionBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _auditionBackgroundView.backgroundColor = [RFColor lightBlue];
        [self addSubview:_auditionBackgroundView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"Music Previewer";
        _titleLabel.font = [RFFont fontWithSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        [_auditionBackgroundView addSubview:_titleLabel];
        
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setImage:[UIImage imageInResourceBundleNamed:@"preview_close.png"] forState:UIControlStateNormal];
        [_auditionBackgroundView addSubview:_dismissButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor blackColor];
        [_auditionBackgroundView addSubview:_contentView];
    
        _videoContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _videoContainerView.backgroundColor = [UIColor blackColor];
        [_contentView addSubview:_videoContainerView];
        
        _playbackView = [[RFPlayerPlaybackView alloc] initWithFrame:CGRectZero];
        _playbackView.backgroundColor = [UIColor blackColor];
        [_videoContainerView addSubview:_playbackView];
        
        _videoSliderContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _videoSliderContainerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        _videoSliderContainerView.alpha = 0;
        [_playbackView addSubview:_videoSliderContainerView];
        
        _videoSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _videoSlider.minimumValue = 0;
        _videoSlider.maximumValue = 100;
        _videoSlider.value = 50;
        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.maximumTrackTintColor = [UIColor whiteColor];
        [_videoSlider setThumbImage:[UIImage imageInResourceBundleNamed:@"video_thumb.png"]
                            forState:UIControlStateNormal];
        [_videoSliderContainerView addSubview:_videoSlider];
        
        int durationFontSize = 13;
        _durationMinimumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _durationMinimumLabel.text = @"0:00";
        _durationMinimumLabel.font = [RFFont fontWithSize:durationFontSize];
        _durationMinimumLabel.textColor = [UIColor blackColor];
        _durationMinimumLabel.backgroundColor = [UIColor clearColor];
        [_videoSliderContainerView addSubview:_durationMinimumLabel];

        _durationMaximumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _durationMaximumLabel.text = @"2:54";
        _durationMaximumLabel.font = [RFFont fontWithSize:durationFontSize];
        _durationMaximumLabel.textColor = [UIColor blackColor];
        _durationMaximumLabel.backgroundColor = [UIColor clearColor];
        [_videoSliderContainerView addSubview:_durationMaximumLabel];
        
        _volumeSliderContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _volumeSliderContainerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        _volumeSliderContainerView.alpha = 0;
        [_playbackView addSubview:_volumeSliderContainerView];
        
        _minimumVolumeSliderImageView = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"volume_music.png"]];
        [_volumeSliderContainerView addSubview:_minimumVolumeSliderImageView];
        
        _maximumVolumeSliderImageView = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"volume_film.png"]];
        [_volumeSliderContainerView addSubview:_maximumVolumeSliderImageView];
        
        _volumeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _volumeSlider.minimumValue = 0;
        _volumeSlider.maximumValue = 200;
        [_volumeSlider setThumbImage:[UIImage imageInResourceBundleNamed:@"volume_thumb.png"]
                            forState:UIControlStateNormal];
        _volumeSlider.value = 100;
        _volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
        _volumeSlider.maximumTrackTintColor = [UIColor whiteColor];
        [_volumeSliderContainerView addSubview:_volumeSlider];
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_videoContainerView addSubview:_activityIndicator];
        
        _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replayButton setTitle:@"REPLAY" forState:UIControlStateNormal];
        _replayButton.titleLabel.font = [RFFont fontWithSize:22];
        _replayButton.titleLabel.textColor = [UIColor whiteColor];
        _replayButton.backgroundColor = [UIColor clearColor];
        [_videoContainerView addSubview:_replayButton];
        
        _songNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _songNameLabel.text = media.title;
        _songNameLabel.font = [RFFont fontWithSize:18];
        _songNameLabel.textColor = [UIColor whiteColor];
        _songNameLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_songNameLabel];
        
        _genreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _genreLabel.text = media.genre;
        _genreLabel.font = [RFFont fontWithSize:14];
        _genreLabel.textColor = [RFColor lightGray];
        _genreLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_genreLabel];
    
        _buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_buyButton setTitle:@"$0.99 | Buy" forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [RFFont fontWithSize:18];
        [_buyButton setTitleColor:[RFColor lightBlue] forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _buyButton.titleLabel.textColor = [RFColor darkBlue];
        _buyButton.backgroundColor = [UIColor whiteColor];
        
        [_contentView addSubview:_buyButton];
    }
    return self;
}

- (void)layoutSubviews
{
    
    _auditionBackgroundView.frame = CGRectMake(0,
                                               0,
                                               self.bounds.size.width,
                                               260);
    _auditionBackgroundView.center = self.center;
    
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(_auditionBackgroundView.center.x - PADDING,
                                     13);
    
    _dismissButton.frame = CGRectMake(0,0,30,30);
    _dismissButton.center = CGPointMake(_auditionBackgroundView.bounds.size.width - 14,
                                        13);
    
    _contentView.frame = CGRectMake(0,
                                    26,
                                    _auditionBackgroundView.bounds.size.width,
                                    _auditionBackgroundView.bounds.size.height - 26 - 1);
    
    _videoContainerView.frame = CGRectMake(0,
                                           0,
                                           _contentView.bounds.size.width,
                                           181);
    
    _playbackView.frame = _videoContainerView.bounds;
    
    _videoSliderContainerView.frame = CGRectMake(0,
                                                 0,
                                                 _videoContainerView.bounds.size.width,
                                                 _videoContainerView.bounds.size.height * .20);
    
    _videoSlider.frame = CGRectMake(PADDING * 2 + _minimumVolumeSliderImageView.frame.size.width,
                                    0,
                                    _videoSliderContainerView.bounds.size.width - (SLIDERIMAGEWIDTH*2 +PADDING*4),
                                    20);
    
    _videoSlider.center = CGPointMake(_videoSliderContainerView.center.x,
                                      _videoSliderContainerView.bounds.size.height/2);
    
    _durationMinimumLabel.frame = CGRectMake(PADDING,
                                             PADDING,
                                             SLIDERIMAGEWIDTH,
                                             SLIDERIMAGEWIDTH);
    
    _durationMinimumLabel.center = CGPointMake(_durationMinimumLabel.center.x,
                                               _videoSliderContainerView.bounds.size.height/2);
    
    _durationMaximumLabel.frame = CGRectMake(_videoSliderContainerView.bounds.size.width - PADDING - SLIDERIMAGEWIDTH,
                                             PADDING,
                                             SLIDERIMAGEWIDTH,
                                             SLIDERIMAGEWIDTH);
    
    _durationMaximumLabel.center = CGPointMake(_durationMaximumLabel.center.x,
                                               _videoSliderContainerView.bounds.size.height/2);
    
    _volumeSliderContainerView.frame = CGRectMake(0,
                                                  _videoContainerView.bounds.size.height * .80,
                                                  _videoContainerView.bounds.size.width,
                                                  _videoContainerView.bounds.size.height * .20);
    
    _minimumVolumeSliderImageView.frame = CGRectMake(PADDING,
                                                     PADDING,
                                                     SLIDERIMAGEWIDTH,
                                                     SLIDERIMAGEWIDTH);
    
    _minimumVolumeSliderImageView.center = CGPointMake(_minimumVolumeSliderImageView.center.x,
                                                 _volumeSliderContainerView.bounds.size.height/2);
    
    _volumeSlider.frame = CGRectMake(PADDING * 2 + _minimumVolumeSliderImageView.frame.size.width,
                                     0,
                                     _volumeSliderContainerView.bounds.size.width - (SLIDERIMAGEWIDTH*2 +PADDING*4),
                                     20);
    
    _volumeSlider.center = CGPointMake(_volumeSliderContainerView.center.x,
                                       _volumeSliderContainerView.bounds.size.height/2);
    
    _maximumVolumeSliderImageView.frame = CGRectMake(_volumeSliderContainerView.bounds.size.width - PADDING - SLIDERIMAGEWIDTH,
                                                     PADDING,
                                                     SLIDERIMAGEWIDTH,
                                                     SLIDERIMAGEWIDTH);

    _maximumVolumeSliderImageView.center = CGPointMake(_maximumVolumeSliderImageView.center.x,
                                                  _volumeSliderContainerView.bounds.size.height/2);
    
    _activityIndicator.center = _playbackView.center;
    
    [_replayButton sizeToFit];
    _replayButton.frame = CGRectMake(0, 0, 100, 40);
    _replayButton.center = _playbackView.center;
    
    _buyButton.frame = CGRectMake(_contentView.bounds.size.width - PADDING - 100,
                                  _videoContainerView.frame.size.height + 10,
                                  100,
                                  30);
    
    [_songNameLabel sizeToFit];
    CGRect songNameFrame = _songNameLabel.bounds;
    songNameFrame.origin = CGPointMake(PADDING,
                                       _videoContainerView.frame.size.height + 6);
    songNameFrame.size.width = _contentView.bounds.size.width - PADDING*2 - _buyButton.bounds.size.width;
    _songNameLabel.frame = songNameFrame;
    
    [_genreLabel sizeToFit];
    CGRect genreFrame = _genreLabel.bounds;
    genreFrame.origin = CGPointMake(PADDING,
                                    _songNameLabel.frame.origin.y + PADDING*2);
    genreFrame.size.width = _contentView.bounds.size.width - PADDING*2 - _buyButton.bounds.size.width;
    _genreLabel.frame = genreFrame;
}

@end
