#import "RFPlayerPlaybackView.h"
#import "RFAPI.h"

@interface RFPreviewView : UIView

@property (nonatomic, strong) UIView *auditionBackgroundView, *contentView, *videoContainerView, *sliderContainerView;
@property (nonatomic, strong) UIButton *dismissButton, *buyButton, *replayButton;
@property (nonatomic, strong) UILabel *titleLabel, *songNameLabel, *genreLabel;
@property (nonatomic, strong) RFPlayerPlaybackView *playbackView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) UIImageView *minimumSliderImageView, *maximumSliderImageView;

- (id)initWithMedia:(RFMedia *)media;

@end
