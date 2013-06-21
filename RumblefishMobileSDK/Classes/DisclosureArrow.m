//
//  RFDisclosureArrow.m
//  RumblefishMobileSDK
//
//  Created by Matthew Ward on 6/19/13.
//  Copyright (c) 2013 Rumblefish, Inc. All rights reserved.
//

#import "DisclosureArrow.h"
#import "RFColor.h"

@implementation DisclosureArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // (x,y) is the tip of the arrow
    CGFloat x = CGRectGetMaxX(self.bounds) - 3;
    CGFloat y = CGRectGetMidY(self.bounds);
    const CGFloat R = 4.5;
    CGContextRef ctxt = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctxt, x-R, y-R);
    CGContextAddLineToPoint(ctxt, x, y);
    CGContextAddLineToPoint(ctxt, x-R, y+R);
    CGContextSetLineCap(ctxt, kCGLineCapSquare);
    CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
    CGContextSetLineWidth(ctxt, 3);
    if (self.highlighted)
        CGContextSetStrokeColorWithColor(ctxt, [UIColor whiteColor].CGColor);
    else
        CGContextSetStrokeColorWithColor(ctxt, [RFColor lightGray].CGColor);
    CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

@end
