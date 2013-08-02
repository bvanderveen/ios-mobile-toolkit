#import "PreviewView.h"
#import "RFColor.h"
#import "RFFont.h"
#import "UIImage+RumblefishSDKResources.h"

#define PADDING 10
#define SLIDERIMAGEWIDTH 22

@interface PreviewView ()

@end

@implementation PreviewView

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
        
        _playbackView = [[AVPlayerPlaybackView alloc] initWithFrame:CGRectZero];
        _playbackView.backgroundColor = [UIColor clearColor];
        [_videoContainerView addSubview:_playbackView];
        
        _sliderContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _sliderContainerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        _sliderContainerView.alpha = 0;
        [_playbackView addSubview:_sliderContainerView];
        
        _minimumSliderImageView = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"volume_music.png"]];
        [_sliderContainerView addSubview:_minimumSliderImageView];
        
        _maximumSliderImageView = [[UIImageView alloc] initWithImage:[UIImage imageInResourceBundleNamed:@"volume_film.png"]];
        [_sliderContainerView addSubview:_maximumSliderImageView];
        
        _volumeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _volumeSlider.minimumValue = 0;
        _volumeSlider.maximumValue = 200;
        [_volumeSlider setThumbImage:[UIImage imageInResourceBundleNamed:@"volume_thumb.png"]
                            forState:UIControlStateNormal];
        _volumeSlider.value = 100;
        _volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
        _volumeSlider.maximumTrackTintColor = [UIColor whiteColor];
        [_sliderContainerView addSubview:_volumeSlider];
        
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
        
        [_contentView addSubview:_buyButton];
    }
    return self;
}

- (void)layoutSubviews
{
    
    _auditionBackgroundView.frame = CGRectMake(0,
                                               0,
                                               self.bounds.size.width - PADDING*2,
                                               240);
    _auditionBackgroundView.center = self.center;
    
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(_auditionBackgroundView.center.x - PADDING,
                                     14);
    
    _dismissButton.frame = CGRectMake(0,0,30,30);
    _dismissButton.center = CGPointMake(_auditionBackgroundView.bounds.size.width - 14,
                                        14);
    
    _contentView.frame = CGRectMake(1, 26, _auditionBackgroundView.bounds.size.width - 2, _auditionBackgroundView.bounds.size.height - 26 - 1);
    
    _videoContainerView.frame = CGRectMake(PADDING,
                                  PADDING,
                                  _contentView.bounds.size.width - PADDING*2,
                                  160);
    
    _playbackView.frame = _videoContainerView.bounds;
    
    
    _sliderContainerView.frame = CGRectMake(0,
                                            _videoContainerView.bounds.size.height * .75 - 2,
                                            _videoContainerView.bounds.size.width,
                                            _videoContainerView.bounds.size.height * .25);
    
    _minimumSliderImageView.frame = CGRectMake(PADDING,
                                               PADDING,
                                               SLIDERIMAGEWIDTH,
                                               SLIDERIMAGEWIDTH);
    
    _minimumSliderImageView.center = CGPointMake(_minimumSliderImageView.center.x,
                                                 _sliderContainerView.bounds.size.height/2);
    
    NSLog(@"Min frame: %@", NSStringFromCGRect(_minimumSliderImageView.frame));
    _volumeSlider.frame = CGRectMake(PADDING * 2 + _minimumSliderImageView.frame.size.width,
                                     0,
                                     _sliderContainerView.bounds.size.width - (SLIDERIMAGEWIDTH*2 +PADDING*4),
                                     20);
    
    _volumeSlider.center = CGPointMake(_sliderContainerView.center.x,
                                       _sliderContainerView.bounds.size.height/2);
    
    _maximumSliderImageView.frame = CGRectMake(_sliderContainerView.bounds.size.width - PADDING - SLIDERIMAGEWIDTH,
                                               PADDING,
                                               SLIDERIMAGEWIDTH,
                                               SLIDERIMAGEWIDTH);

    _maximumSliderImageView.center = CGPointMake(_maximumSliderImageView.center.x,
                                                  _sliderContainerView.bounds.size.height/2);
    NSLog(@"Max frame: %@", NSStringFromCGRect(_maximumSliderImageView.frame));
    
    _activityIndicator.center = _playbackView.center;
    
    [_replayButton sizeToFit];
    _replayButton.frame = CGRectMake(0, 0, 100, 40);
    _replayButton.center = _playbackView.center;
    
    _buyButton.frame = CGRectMake(_contentView.bounds.size.width - PADDING - 100,
                                  _videoContainerView.frame.size.height + 16,
                                  100,
                                  30);
    
    [_songNameLabel sizeToFit];
    CGRect songNameFrame = _songNameLabel.bounds;
    songNameFrame.origin = CGPointMake(PADDING,
                                       _videoContainerView.frame.size.height + 12);
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
