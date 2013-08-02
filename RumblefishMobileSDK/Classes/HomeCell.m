/*
 Rumblefish Mobile Toolkit for iOS
 
 Copyright 2012 Rumblefish, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License"); you may
 not use this file except in compliance with the License. You may obtain
 a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 License for the specific language governing permissions and limitations
 under the License.
 
 Use of the Rumblefish Sandbox in connection with this file is governed by
 the Sandbox Terms of Use found at https://sandbox.rumblefish.com/agreement
 
 Use of the Rumblefish API for any commercial purpose in connection with
 this file requires a written agreement with Rumblefish, Inc.
 */

#import "HomeCell.h"
#import "RFFont.h"
#import "RFColor.h"
#import "DisclosureArrow.h"
#import "SMWebRequest+Async.h"
#import "UIImage+Undeferred.h"
#import "UIImage+Cached.h"
#import "UIImage+RumblefishSDKResources.h"

#define kCellLabelPadding 11
#define kTitleSubtitlePadding 4
#define kDisclosurePadding 30

@interface ImageSeperator : UIControl

@end

@implementation ImageSeperator

- (void)drawRect:(CGRect)rect
{    
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctxt, 0, 0);
    CGContextAddLineToPoint(ctxt, 0, CGRectGetHeight(self.bounds));
    CGContextSetLineCap(ctxt, kCGLineCapSquare);
    CGContextSetLineWidth(ctxt, 1);
    CGContextSetStrokeColorWithColor(ctxt,
                                     self.highlighted ?
                                     [UIColor whiteColor].CGColor :
                                     [UIColor blackColor].CGColor);
    CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

@end

#pragma mark -

@interface HomeCell ()

@property (nonatomic, strong) ImageSeperator *imageSeparator;
@property (nonatomic, strong) DisclosureArrow *arrow;
@property (nonatomic, copy) CancelCallback cancelImage;

@end

@implementation HomeCell

- (void)setCancelImage:(CancelCallback)cancelImage {
    if (_cancelImage)
        _cancelImage();
    
    _cancelImage = [cancelImage copy];
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    self.imageView.image = [UIImage imageInResourceBundleNamed:@"album_placeholder.png"];

    if (_imageURL) {
        Producer p = [UIImage cachedImageWithURL:imageURL];
        self.cancelImage = p(^ void (UIImage *result) {
            self.imageView.image = result;
            [self setNeedsLayout];
        }, ^ void (NSError *e) { });
    }
    else {
        self.cancelImage = nil;
        [self setNeedsLayout];
    }
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        _arrow = [[DisclosureArrow alloc] initWithFrame:CGRectMake(0, 0, 11, 15)];
        self.accessoryView = _arrow;
        
        _imageSeparator = [[ImageSeperator alloc] initWithFrame:CGRectZero];
        _imageSeparator.backgroundColor = [UIColor blackColor];
        [self addSubview:_imageSeparator];
    
        self.textLabel.font = [RFFont fontWithSize:18];
        self.textLabel.textColor = [UIColor whiteColor];
        
        self.detailTextLabel.font = [RFFont fontWithSize:14];
        self.detailTextLabel.textColor = [RFColor lightGray];
    }
    return self;
}
                       
- (void)layoutSubviews
{
   [super layoutSubviews];
    
    //add 1px border to image
    _imageSeparator.frame = CGRectMake(self.imageView.bounds.size.width, 0, 1, self.bounds.size.height);
}

@end
