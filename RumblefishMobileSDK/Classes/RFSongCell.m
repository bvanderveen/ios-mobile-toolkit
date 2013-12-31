#import "RFSongCell.h"
#import "RFFont.h"
#import "RFColor.h"
#import "UIImage+RumblefishSDKResources.h"

@interface RFSongCell ()

@property (nonatomic, strong) UILabel *priceLabel, *saveLabel;
@property (nonatomic, copy) void(^buttonAction)();
@property (nonatomic, strong) UIButton *accessoryButton;

@end

@implementation RFSongCell

@synthesize songIsSaved = _songIsSaved;

- (void)setSongIsSaved:(BOOL)songIsSaved {
    _songIsSaved = songIsSaved;
    ((UIButton *)self.accessoryView).selected = songIsSaved;
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0.1686f green:0.1686f blue:0.1686f alpha:1.0f];
        
        self.textLabel.font = [RFFont fontWithSize:18];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.detailTextLabel.font = [RFFont fontWithSize:14];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];

        _accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"song_check.png"]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        [_accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"song_check.png"]
                          forState:UIControlStateSelected];
        [_accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"btn_add.png"]
                          forState:UIControlStateNormal];
        [_accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"btn_add_highlighted.png"]
                          forState:UIControlStateHighlighted];
        [_accessoryButton addTarget:self
                             action:@selector(buttonTapped:)
                   forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = _accessoryButton;
        [_accessoryButton sizeToFit];
        
        _saveLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _saveLabel.font = [RFFont fontWithSize:12];
        _saveLabel.textColor = [RFColor mediumGray];
        _saveLabel.backgroundColor = [UIColor clearColor];
        _saveLabel.text = @"SAVE";
        _saveLabel.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:_saveLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [RFFont fontWithSize:14];
        _priceLabel.textColor = [UIColor lightGrayColor];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_priceLabel sizeToFit];
    
    CGFloat margin = 5;
    
    if (self.detailTextLabel.frame.size.width + _priceLabel.frame.size.width + margin > self.contentView.bounds.size.width) {
        CGRect f = self.textLabel.frame;
        f.size.width -= _priceLabel.frame.size.width + self.detailTextLabel.frame.size.width + margin - self.contentView.bounds.size.width;
        self.detailTextLabel.frame = f;
    }
    
    if (self.textLabel.frame.size.width + _priceLabel.frame.size.width + margin > self.contentView.bounds.size.width) {
        CGRect f = self.textLabel.frame;
        f.size.width -= _priceLabel.frame.size.width + self.textLabel.frame.size.width + margin - self.contentView.bounds.size.width + 14;
        self.textLabel.frame = f;
    }
    
    _priceLabel.frame = CGRectMake(self.contentView.bounds.size.width - _priceLabel.frame.size.width,
                                   (self.contentView.bounds.size.height - _priceLabel.frame.size.height) / 2,
                                   _priceLabel.frame.size.width,
                                   _priceLabel.frame.size.height);
    
    
    [_saveLabel sizeToFit];
    _saveLabel.center = CGPointMake(self.accessoryView.center.x, self.accessoryView.center.y + 19);
}

- (void)buttonTapped:(UIButton *)button {
    if (_buttonAction) {
        _saveLabel.text = (button.selected) ? @"SAVE" : @"SAVED";
        _buttonAction();
    }
}

+ (RFSongCell *)cellForMedia:(RFMedia *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action {
    static NSString *ident = @"RFSongCell";
    
    RFSongCell *cell = (RFSongCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell)
        cell = [[RFSongCell alloc] initWithReuseIdentifier:ident];
    
    cell.textLabel.text = media.title;
    cell.detailTextLabel.text = media.genre;
    
#warning update label with actual media price
    cell.priceLabel.text = @"$0.99";
    cell.buttonAction = action;
    cell.songIsSaved = NO;
    cell.saveLabel.hidden = NO;
    
    return cell;
}

+ (RFSongCell *)removeButtonCellForMedia:(RFMedia *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action {
    RFSongCell *cell = [self cellForMedia:media tableView:tableView buttonAction:action];
    
    [cell.accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"btn_remove.png"] forState:UIControlStateNormal];
    [cell.accessoryButton sizeToFit];
    cell.saveLabel.hidden = YES;

    return cell;
}

@end
