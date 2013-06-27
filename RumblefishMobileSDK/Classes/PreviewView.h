#import "AVPlayerPlaybackView.h"
#import "RFAPI.h"

@interface PreviewView : UIView

@property (nonatomic, strong) UIView *auditionBackgroundView, *contentView, *videoView;
@property (nonatomic, strong) UIButton *dismissButton, *buyButton;
@property (nonatomic, strong) UILabel *titleLabel, *songNameLabel, *genreLabel;
@property (nonatomic, strong) AVPlayerPlaybackView *playbackView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (id)initWithMedia:(Media *)media;

@end
