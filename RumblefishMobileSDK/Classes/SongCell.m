#import "SongCell.h"
#import "RFFont.h"
#import "UIImage+RumblefishSDKResources.h"

@interface SongCell ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, copy) void(^buttonAction)();
@property (nonatomic, strong) UIButton *accessoryButton;

@end

@implementation SongCell

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
        [_accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"song_check.png"] forState:UIControlStateSelected];
        [_accessoryButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_accessoryButton sizeToFit];
        self.accessoryView = _accessoryButton;
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [RFFont fontWithSize:14];
        _priceLabel.textColor = [UIColor lightGrayColor];
        _priceLabel.backgroundColor = [UIColor clearColor];
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
        f.size.width -= _priceLabel.frame.size.width + self.textLabel.frame.size.width + margin - self.contentView.bounds.size.width;
        self.textLabel.frame = f;
    }
    
    _priceLabel.frame = CGRectMake(self.contentView.bounds.size.width - _priceLabel.frame.size.width, (self.contentView.bounds.size.height - _priceLabel.frame.size.height) / 2, _priceLabel.frame.size.width, _priceLabel.frame.size.height);
}

- (void)buttonTapped {
    if (_buttonAction)
        _buttonAction();
}

+ (SongCell *)cellForMedia:(Media *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action {
    static NSString *ident = @"SongCell";
    
    SongCell *cell = (SongCell *)[tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell)
        cell = [[SongCell alloc] initWithReuseIdentifier:ident];
    
    [cell.accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"btn_add.png"] forState:UIControlStateNormal];
    [cell.accessoryButton sizeToFit];
    
    cell.textLabel.text = media.title;
    cell.detailTextLabel.text = media.genre;
    cell.priceLabel.text = @"$0.99";
    cell.buttonAction = action;
    cell.songIsSaved = NO;
    
    return cell;
}

+ (SongCell *)removeButtonCellForMedia:(Media *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action {
    SongCell *cell = [self cellForMedia:media tableView:tableView buttonAction:action];
    
    [cell.accessoryButton setImage:[UIImage imageInResourceBundleNamed:@"btn_remove.png"] forState:UIControlStateNormal];
    [cell.accessoryButton sizeToFit];
    
    return cell;
}

@end