#import "RFFont.h"
#import "NSBundle+RumblefishMobileSDKResources.h"
#import <CoreText/CoreText.h>

@implementation RFFont

+ (void)initialize {
    NSString *fontPath = [[NSBundle rumblefishResourcesBundle] pathForResource:@"TradeGothicLTBoldCondensedNo20" ofType:@"ttf"];
    NSData *inData = [NSData dataWithContentsOfFile:fontPath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"TradeGothic LT CondEighteen" size:size];
}

@end
