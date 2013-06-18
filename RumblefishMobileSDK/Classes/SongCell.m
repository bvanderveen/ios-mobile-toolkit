#import "SongCell.h"
#import "RFFont.h"
#import "UIImage+RumblefishSDKResources.h"

@interface SongCell ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, copy) void(^buttonAction)();

@end

@implementation SongCell

@synthesize songIsSaved = _songIsSaved;

- (void)setSongIsSaved:(BOOL)songIsSaved {
    _songIsSaved = songIsSaved;
    ((UIButton *)self.accessoryView).selected = songIsSaved;
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
        self.textLabel.font = [RFFont fontWithSize:18];
        self.textLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.font = [RFFont fontWithSize:14];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *i = [UIImage imageInResourceBundleNamed:@"btn_add.png"];
        [button setImage:i forState:UIControlStateNormal];
        [button setImage:[UIImage imageInResourceBundleNamed:@"song_check.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        self.accessoryView = button;
        
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
    
    cell.textLabel.text = media.title;
    cell.detailTextLabel.text = media.genre;
    cell.priceLabel.text = @"$0.99";
    cell.buttonAction = action;
    cell.songIsSaved = NO;
    
    return cell;
}

@end
