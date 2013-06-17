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

#define kCellLabelPadding 11
#define kTitleSubtitlePadding 4

@implementation HomeCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
//        //bgImageView is declared in the header as UIImageView *bgHeader;
        _titleLabel = [[UILabel alloc] init];
        _subtitleLabel = [[UILabel alloc] init];
        _thumbnailView = [[UIImageView alloc] init];
        
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_subtitleLabel];
        [self.contentView addSubview:_thumbnailView];
        
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        
//        bgImageView = [[UIImageView alloc] init];
//        bgImageView.image = [UIImage imageNamed:@"YourFileName.png"];
//        //add the subView to the cell
//        [self.contentView addSubview:bgImageView];
//        //be sure to release bgImageView in the dealloc method!
    }
    return self;
}
                       
- (void)layoutSubviews
{
   [super layoutSubviews];
    
   CGRect thumbFrame = CGRectMake(0,
                                  0,
                                  self.frame.size.height,
                                  self.frame.size.height);
    _thumbnailView.frame = thumbFrame;
    //TODO: Add border to image
    
    CGRect titleFrame = CGRectMake(thumbFrame.size.width + kCellLabelPadding,
                                   21,
                                   self.frame.size.width - thumbFrame.size.width - kCellLabelPadding,
                                   24);
    _titleLabel.frame = titleFrame;
    
    CGRect subtitleFrame = CGRectMake(thumbFrame.size.width + kCellLabelPadding,
                                      titleFrame.origin.y + titleFrame.size.height + kTitleSubtitlePadding,
                                      self.frame.size.width - thumbFrame.size.width - kCellLabelPadding,
                                      15);
    _subtitleLabel.frame = subtitleFrame;
    
}

@end
