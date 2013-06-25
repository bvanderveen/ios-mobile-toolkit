
@interface PreviewView : UIView

@property (nonatomic, strong) UIView *auditionBackgroundView, *contentView, *videoView;
@property (nonatomic, strong) UIButton *dismissButton, *buyButton;
@property (nonatomic, strong) UILabel *titleLabel, *songNameLabel, *artistNameLabel;

@end
