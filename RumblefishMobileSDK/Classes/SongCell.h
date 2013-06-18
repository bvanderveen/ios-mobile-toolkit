#import "RFAPI.h"

@interface SongCell : UITableViewCell

@property (nonatomic, assign) BOOL songIsSaved;

+ (SongCell *)cellForMedia:(Media *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action;
+ (SongCell *)removeButtonCellForMedia:(Media *)media tableView:(UITableView *)tableView buttonAction:(void(^)())action;

@end
