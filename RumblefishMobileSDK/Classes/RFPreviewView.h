#import "RFPlayerPlaybackView.h"
#import "RFAPI.h"

@interface RFPreviewView : UIView

@property (nonatomic, strong) UIView *auditionBackgroundView, *contentView, *videoContainerView, *volumeSliderContainerView, *videoSliderContainerView;
@property (nonatomic, strong) UIButton *dismissButton, *buyButton, *replayButton;
@property (nonatomic, strong) UILabel *titleLabel, *songNameLabel, *genreLabel;
@property (nonatomic, strong) RFPlayerPlaybackView *playbackView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UISlider *volumeSlider, *videoSlider;
@property (nonatomic, strong) UIImageView *minimumVolumeSliderImageView, *maximumVolumeSliderImageView;

- (id)initWithMedia:(RFMedia *)media;

@end
