#import "PreviewView.h"
#import "RFColor.h"
#import "RFFont.h"
#import "UIImage+RumblefishSDKResources.h"

@interface PreviewView ()

@end

@implementation PreviewView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        
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
        [_dismissButton setImage:[UIImage imageInResourceBundleNamed:@"btn_add.png"] forState:UIControlStateNormal];
        [_auditionBackgroundView addSubview:_dismissButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor blackColor];
        [_auditionBackgroundView addSubview:_contentView];
    
        _videoView = [[UIView alloc] initWithFrame:CGRectZero];
        _videoView.backgroundColor = [UIColor lightGrayColor];
        [_contentView addSubview:_videoView];
        
        _songNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _songNameLabel.text = @"Song Name Goes Here";
        _songNameLabel.font = [RFFont fontWithSize:18];
        _songNameLabel.textColor = [UIColor whiteColor];
        _songNameLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_songNameLabel];
        
        _artistNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _artistNameLabel.text = @"Artist Name Here";
        _artistNameLabel.font = [RFFont fontWithSize:14];
        _artistNameLabel.textColor = [RFColor lightGray];
        _artistNameLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:_artistNameLabel];
        
        _buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _buyButton.titleLabel.text = @"$0.99 | BUY";
        [_contentView addSubview:_buyButton];
    }
    return self;
}

- (void)layoutSubviews
{
    _auditionBackgroundView.frame = CGRectMake(0,
                                               0,
                                               self.bounds.size.width - 20,
                                               240);
    _auditionBackgroundView.center = self.center;
    
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(_auditionBackgroundView.center.x, 14);
    
    [_dismissButton sizeToFit];
    _dismissButton.center = CGPointMake(_auditionBackgroundView.bounds.size.width - 14, 14);
    
    _contentView.frame = CGRectMake(1, 26, _auditionBackgroundView.bounds.size.width - 2, _auditionBackgroundView.bounds.size.height - 26 - 1);
    
    _videoView.frame = CGRectMake(10, 10, _contentView.bounds.size.width - 20, 160);
    
    _buyButton.frame = CGRectMake(_contentView.bounds.size.width - 10 - 107, _videoView.frame.size.height + 18, 107, 27);
    
    [_songNameLabel sizeToFit];
    CGRect songNameFrame = _songNameLabel.bounds;
    songNameFrame.origin = CGPointMake(10, _videoView.frame.size.height + 12);
    _songNameLabel.frame = songNameFrame;
    
    [_artistNameLabel sizeToFit];
    CGRect artistNameFrame = _artistNameLabel.bounds;
    artistNameFrame.origin = CGPointMake(10, _songNameLabel.frame.origin.y + 20);
    _artistNameLabel.frame = artistNameFrame;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    NSLog(@"sizeThatFits %@", NSStringFromCGSize(size));
    return size;
}

@end
