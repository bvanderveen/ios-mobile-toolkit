#import "PreviewView.h"

@interface PreviewView ()

@end

@implementation PreviewView

- (void)layoutSubviews {
    NSLog(@"PreviewView bounds = %@", NSStringFromCGRect(self.bounds));
    _videoView.frame = self.bounds;
}

- (CGSize)sizeThatFits:(CGSize)size {
    NSLog(@"sizeThatFits %@", NSStringFromCGSize(size));
    return size;
}

@end
