#import "PreviewView.h"
#import "RFColor.h"
#import "RFFont.h"

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
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        [_auditionBackgroundView addSubview:_titleLabel];
        
        _dismissButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [_auditionBackgroundView addSubview:_dismissButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor blackColor];
//        [_auditionBackgroundView addSubview:_contentView];
    
        _videoView = [[UIView alloc] initWithFrame:CGRectZero];
        _videoView.backgroundColor = [UIColor redColor];
//        [_contentView addSubview:_videoView];        
    }
    return self;
}

- (void)layoutSubviews
{
    
    _auditionBackgroundView.frame = CGRectMake(0, 0, self.bounds.size.width - 20, 240);
    _auditionBackgroundView.center = self.center;
    
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(_auditionBackgroundView.center.x, 10);
    
    _dismissButton.center = CGPointMake(_auditionBackgroundView.bounds.size.width - 20, 10);
    
    _contentView.frame = CGRectMake(1, 26, _auditionBackgroundView.bounds.size.width - 2, _auditionBackgroundView.bounds.size.height - 26 - 1);
    
//    _videoView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
//    NSLog(@"PreviewView bounds = %@", NSStringFromCGRect(self.bounds));
//    CGRect videoFrame;
//    videoFrame.origin = CGPointMake(2, 2);
//    videoFrame.size = CGSizeMake(_contentView.bounds.size.width - 4,
//                                 _contentView.bounds.size.height - 4);
//    _videoView.frame = self.bounds;
    

}

- (CGSize)sizeThatFits:(CGSize)size {
    NSLog(@"sizeThatFits %@", NSStringFromCGSize(size));
    return size;
}

@end
